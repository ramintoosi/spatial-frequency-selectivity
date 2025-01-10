clear; clc;

%% load the provided sample data

load data.mat
% label_matrix_fast: Labels corresponding to the fast trials.
% label_matrix_slow: Labels corresponding to the slow trials.
% neuron_response_fast: Neuronal responses recorded during fast presentation trials.
% neuron_response_slow: Neuronal responses recorded during slow presentation trials.
% x: Real-time points corresponding to the time dimension.

rng(561371)

%% train a model and calculate the recall

n_repeat = 100; % in the main paper this repeatation is 1000

recall = zeros(n_repeat, size(neuron_response_fast, 3), 5, 2); % repeatations x time x label x presenation condition

data_total = {neuron_response_fast, neuron_response_slow};
label_total = {label_matrix_fast, label_matrix_slow};

for ipres = 1 : 2
    for itime = 1 : size(neuron_response_fast, 3)
        feat = data_total{ipres}(:,:,itime);
        label = label_total{ipres}(:,1);
        [~, m] = classification_leave_p_out(feat, label, 0.3, n_repeat, 0, -1);
        for ilabel = 1 : 5
            recall(:, itime, ilabel, ipres) = squeeze(m(ilabel,ilabel,:)) ./ squeeze(sum(m(ilabel,:,:),2));
        end
        disp([ipres, itime])
    end
end


%% plot recall

colors = matlab_colors();

target_time = (x>70) & (x<170);

titles = {'Recall Fast', 'Recall Slow'};

for ipres = 1 : 2
    for ifreq = 1 : 5
        r = squeeze(mean(recall(:,target_time,:, ipres), 2));
        subplot(1,2,ipres)
        errorbar(ifreq, mean(r(:,ifreq)), std(r(:, ifreq)),'Color',colors(ifreq+1,:), 'LineWidth',3)
        hold on
    end
    plot(1:5, mean(r), 'LineStyle', '--','Color','k', 'LineWidth',1.5)
    title(titles{ipres});
    xticks(1:5)
    xticklabels({'R1', 'R2', 'R3', 'R4', 'R5'})
    axis square
    xlim([0.5, 5.5])
    ylim([0.1, 0.5])
end


%% calculate and plot onset
figure
colors = matlab_colors();

% smoothing
L = 3;
alpha = (L-1)/(2*10);
gaussian_window = gausswin(L,alpha)';
gaussian_window = gaussian_window ./ sum(gaussian_window);

base_time = (x >= -50) & (x <= 50);
target_time = (x>70) & (x<170);

hsmooth = @(x) conv2(x,gaussian_window,'same');
hnormalize = @(x) x - repmat(nanmean(x(:,base_index),2),1,size(x,2));


onsets = [];

for ipres = 1 : 2
    for ifreq = 1 : 5

        r = hsmooth(recall(:, :, ifreq, ipres));
        r_base = mean(r(:, base_time), 2);
        threshold = mean(r_base) + std(r_base);
        onset_candidates = r(:, target_time) > threshold;
        onset_candidates = consecutive_ones_mat(onset_candidates);
        os = [];
        for io = 1:size(onset_candidates, 1)

            % in the main paper we check for significancy
            % here because of the lower number of the sample neurons,
            % we only check if the value is greater

            tmp = find(onset_candidates(io, :) > 5);
            if ~isempty(tmp)
                os(io) = tmp(1);
            else
                os(io) = NaN;
            end
        end
        onsets(:, ifreq, ipres) = os;

    end
end

titles = {'Onset Fast', 'Onset Slow'};

onsets =  onsets * 5 + 70; % convert to miliseconds

for ipres = 1 : 2
    subplot(1,2,ipres)
    os = onsets(:,:,ipres);
    plot(nanmean(os), 'Color',colors(1,:), 'LineStyle','-', 'LineWidth',2)
    hold on
    for ifreq = 1 : 5
        tmp = os(:,ifreq);
        errorbar(ifreq, nanmean(tmp), nanstd(tmp) , ...
            'LineStyle','-', 'Color',colors(ifreq+1,:), 'LineWidth',3, 'MarkerSize',2)
    end
    xticks(1:5)
    xticklabels({'R1', 'R2', 'R3', 'R4', 'R5'})
    set(gca,'fontsize',7)
    axis square
    xlim([0.5, 5.5])
    title(titles{ipres});
end

