clc;
clear;
close all;

DATA_PATH = "../data/mnist.mat";
load(DATA_PATH, "-mat"); % Load data
N = length(digits_train);
WIDTH = size(digits_train, 1);
SIZE = WIDTH^2;
% Reshape, Recast, Normalize image intensity
train_data = cast(reshape(digits_train, [SIZE N]), 'double')/255;

for digit=0:9
    count = sum(labels_train==digit);
    digit_data = train_data(:, labels_train == digit);
    mean = sum(digit_data, 2)/count; % sample mean
    cov = (digit_data-mean)*(digit_data'-mean')/(count-1); % sample cov
    [Q, D] = eig(cov);
    dia = diag(D); % Get the diagonals elements as a vector
    
    % Find the highest eigenvalue and its corresponding eigenvector
    [lamb1, index1] = max(dia);
    v1 = Q(:,index1);
    
    % Sort the eigenvalues to analyse their distribution
    dia = sort(dia,'descend');
    dia(dia<0)=0; % Fixing precision error due to eig()
    
    hold off;
    
    subplot(1,3,1);
    imagesc(reshape(mean - sqrt(lamb1)*v1, [WIDTH WIDTH]));
    title("\mu - \surd{\lambda_1} * v_1");
    pbaspect([1 1 1]); % equivalent to axis equal here as range of both axes is (1,28)
    axis off;
    subplot(1,3,2);
    imagesc(reshape(mean, [WIDTH WIDTH]));
    title("\mu");
    pbaspect([1 1 1]); % equivalent to axis equal here as range of both axes is (1,28)
    axis off;
    subplot(1,3,3);
    imagesc(reshape(mean + sqrt(lamb1)*v1, [WIDTH WIDTH]))
    title("\mu + \surd{\lambda_1} * v_1");
    pbaspect([1 1 1]); % equivalent to axis equal here as range of both axes is (1,28)
    axis off;
    
    sgtitle(sprintf("Digit %i", digit));
    colormap('gray');
    saveas(gcf, sprintf("../results/trip_img_%i.jpg", digit)); % Save current figure
    
    hold off;
    subplot(1,1,1);
    plot(1:SIZE,dia);
    title(sprintf("Sorted Eigenvalues for Digit %i", digit));
    sgtitle("");
    saveas(gcf, sprintf("../results/eigenvalues_%i.jpg", digit)); % Save current figure
    semilogx(1:SIZE,dia);
    fprintf("%i Significant modes of variation for Digit %i (Number of Eigenvalues > 1%% of Max Eigenvalue)\n", sum(dia>dia(1)/100), digit);
    title(sprintf("Sorted Eigenvalues for Digit %i (X-axis log scaled)", digit));
    saveas(gcf, sprintf("../results/eigenvalues_log_%i.jpg", digit)); % Save current figure
end

close all;
