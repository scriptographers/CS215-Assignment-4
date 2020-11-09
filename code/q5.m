clc;
clear;
close all;

tic;

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
    [Q, D] = eig(cov);
    dia = sort(diag(D),'descend');
    dia(dia<=0)=0; % Fixing numerical error in eig() due to precision
end

close all;

toc;