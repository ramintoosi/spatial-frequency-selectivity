function [acc, m, ord, weight] = classification_leave_p_out(feat, label, p_test, n_rep, do_pca, eq_sample)
% classification_leave_p_out - Perform classification with leave-p-out cross-validation.
%
% Syntax:
%   [acc, m, ord, weight] = classification_leave_p_out(feat, label, p_test, n_rep, do_pca, eq_sample)
%
% Inputs:
%   feat     - Features matrix (samples x features).
%   label    - Class labels corresponding to each sample.
%   p_test   - Fraction of data to leave out for testing in each iteration.
%   n_rep    - Number of repetitions of cross-validation.
%   do_pca   - (Optional) Boolean indicating whether to perform PCA (default: false).
%   eq_sample - (Optional) Equalize sample sizes across classes. If -1, uses the smallest class size (default: 0).
%
% Outputs:
%   acc      - Vector of classification accuracies for each repetition.
%   m        - Confusion matrices for each repetition.
%   ord      - Class order used in the confusion matrices.
%   weight   - Model weights (coefficients) from the discriminant model.


if nargin
    eq_sample = 0;
end

if eq_sample == -1
    tb = tabulate(label);
    freq = cell2mat(tb(:,2));
    eq_sample = min(freq);
end

if nargin < 5
    do_pca = false;
end
nPCA = 2;

if do_pca
    [~,feat] = pca(feat, 'NumComponents', nPCA);
end

% equalize label population number
l_u = unique(label);
n_data_min = inf;
for iu = 1 : length(l_u)
    ltmp = label == l_u(iu);
    n_data_min = min([sum(ltmp),n_data_min]);
end

acc = zeros(n_rep,1);

i = 0;
while i <  n_rep

    feat_new = [];
    label_new = [];
    for j = 1 : length(l_u)
        ltmp = find(label == l_u(j));
        if eq_sample > 0
            iselect = randperm(length(ltmp),eq_sample);
        else
            iselect = randperm(length(ltmp),n_data_min);
        end
        feat_new = cat(1,feat_new, feat(ltmp(iselect),:));
        label_new = cat(1,label_new,label(ltmp(iselect)));
    end
    n_data = size(feat_new,1);
    n_test = floor(p_test*n_data);
    
    
    ind_leave = randperm(n_data,n_test);
    ind_test = false(1,n_data);
    ind_test(ind_leave) = true;

     if (sum(ind_test) == 0) || (length(unique(label_new(ind_test))) ~= length(l_u))
        continue
    end
    i = i + 1;
    
    model = fitcdiscr(feat_new(~ind_test,:),label_new(~ind_test), 'Prior','uniform', ...
        'discrimType', 'pseudoLinear');

    ltp = predict(model,feat_new(ind_test,:));
    acc(i) = sum(ltp == label_new(ind_test)) / length(ltp); 
    [m(:,:,i),ord(:,i)] = confusionmat(label_new(ind_test), ltp);
    weight(i,:) = model.Coeffs(1,2).Linear;
end

