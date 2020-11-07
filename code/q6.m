clc;
clear;
close all;

% Reading the data
DATA_PATH = "../data/data_fruit/";
IMG_PATHS = dir(fullfile(DATA_PATH, "image_*.png"));
N = numel(IMG_PATHS);
SHAPE = [80, 80, 3];
data = [];

% data(:, i) == ith column of data contains image_i
for i = 1:N
    path = fullfile(DATA_PATH, IMG_PATHS(i).name);
    img = imread(path);
    x = img(:);
    data = [data x];
end

% Cast as double for further processing: 
data = double(data);

% Clear variables not needed further:
clear x;
clear i;
clear img;
clear path;

% Compute sample mean of the original data
mu = sum(data, 2)./N;

% Preprocessing:
% Centering the data about mu
data = data - mu; 
% Normalization
data = data./255;

% Computing the covariance matrix (19200 x 19200) matrix (This shall take up 2.6GB of your RAM)
C = (1/(N-1)).*(data * data');
% save("covarianceFruits.mat", 'C', "-v7.3"); % This will be 2.6GB, only save if you are running this file again and again

% Eigendecomposition of C: eigs() is much much faster than eig()
[Q, L] = eigs(C, 10); % Get 10 largest eigenvalues and corresponding eigenvectors

clear C;

Q4 = Q(:, 1:4); % First 4 columns of Q, normalized eigenvectors of C
eigvals = diag(L); % All diagonal values in a column vector

clear Q;
clear L;

% Part 1:
% 1+4 mean + Eigenvectors plots 
subplot(1,5,1);
image(toImg(mu, SHAPE));
pbaspect([1 1 1]);
axis off;
title("Mean");
for i=2:5
    subplot(1,5,i);
    image(toImg(Q4(:,i-1), SHAPE));
    pbaspect([1 1 1]);
    axis off;
    title("Eigenvector: " + (i-1));
end
saveas(gcf, "plots/q6/q6i.jpg");
clear i;

% Plot eigenvalues:
figure;
x_eigs = 1:10;
plot(x_eigs, eigvals, 'r');
hold on;
scatter(x_eigs, eigvals, 'b');
grid on;
xlabel("n");
ylabel("Eigenvalue");
title("Question 6: First 10 Eigenvalues");
saveas(gcf, "plots/q6/q6ii.jpg");
hold off;

% Part 2: Reconstruction of original data
coeffs = data' * Q4; % 16x4
data_reconstructed = mu./255 + Q4*coeffs';

hold off;
for i=1:16
    f = figure('visible', 'off');
    subplot(1, 2, 1);
    image(toImg(data(:, i)+mu./255, SHAPE)); % Original uncentered image
    title("Original: "+i);
    pbaspect([1 1 1]);
    axis off;
    subplot(1, 2, 2);
    image(toImg(data_reconstructed(:, i), SHAPE));
    title("Reconstructed: "+i);
    pbaspect([1 1 1]);
    axis off;
    saveas(f, "plots/q6/comparison_"+i+".jpg");
end

% MinMax scaler for scaling images to [0, 1]
function [y] = toImg(x, shape)
    y = x - min(x);
    y = y/max(y);
    y = reshape(y, shape);
end