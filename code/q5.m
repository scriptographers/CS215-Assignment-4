clc;
clear;
close all;

DATA_PATH = "../data/mnist.mat";
load(DATA_PATH, "-mat"); % Load data
N = length(digits_train);
WIDTH = 28;
SIZE = WIDTH^2;
% Reshape, Recast, Normalize image intensity
train_data = cast(reshape(digits_train, [SIZE N]), 'double')/255;

for digit=0:9
    count = sum(labels_train==digit);
    digit_data = train_data(:, labels_train == digit);
    mean = sum(digit_data, 2)/count; % MLE of mean
    cov = (digit_data-mean)*(digit_data'-mean')/count; % MLE of cov
    
    % Eigendecomposition of cov: eigs() is much much faster than eig()
    [Q, L] = eigs(cov, 84); % Get 84 largest eigenvalues and corresponding eigenvectors
    % Q represents 84 columns representing a 84-dimensional basis
    
    test_data = digit_data(:,end); % Seemed to give nice results
    reduced_data = reduce_dim(test_data, Q, mean);
    
    subplot(1,2,1);
    imagesc(reshape(test_data, [WIDTH WIDTH]));
    title("Original Image");
    pbaspect([1 1 1]); % equivalent to axis equal here as range of both axes is (1,28)
    axis off;
    subplot(1,2,2);
    imagesc(reshape(reconstruct_img(reduced_data, Q, mean), [WIDTH WIDTH]));
    title("Reconstructed Image");
    pbaspect([1 1 1]); % equivalent to axis equal here as range of both axes is (1,28)
    axis off;
    
    sgtitle(sprintf("Digit %i", digit));
    colormap('gray');
    saveas(gcf, sprintf("plots/q5/comp_%i.jpg", digit)); % Save current figure
end

close all;

function [reduced_data] = reduce_dim(digit_img, Q, mean)
    reduced_data = Q'*(digit_img-mean);
end

function [reduced_img] = reconstruct_img(reduced_data, Q, mean)
    reduced_img = mean + Q*reduced_data;
end
