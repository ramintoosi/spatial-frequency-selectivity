function outf = consecutive_ones_mat(Am)
% consecutive_ones_mat - Computes the length of consecutive ones for each row of a binary matrix.
%
% Syntax:
%   outf = consecutive_ones_mat(Am)
%
% Inputs:
%   Am - A binary matrix where each row is processed independently.
%
% Outputs:
%   outf - A matrix of the same size as Am, where each element in a row
%          represents the length of the consecutive ones ending at that position.
%
% Example:
%   Am = [1 1 0 1 1 1;
%         0 1 1 1 0 0];
%   outf = consecutive_ones_mat(Am);
%   % outf =
%   % [1 2 0 1 2 3;
%   %  0 1 2 3 0 0]

outf = [];
for i = 1 : size(Am,1)
    A = Am(i,:);
    out = double(diff([~A(1);A(:)]) == 1);
    v = accumarray(cumsum(out).*A(:)+1,1);
    out(out == 1) = v(2:end);
    outf(i,:) = out;
end