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
    [Q, D] = eig(cov);
    dia = diag(D);
    [lamb1, index1] = max(dia);
    v1 = Q(:,index1);
    
    dia = sort(dia,'descend');
    dia(dia<=0)=0; % Fixing numerical error in eig() due to precision
    
    hold off;
    
    subplot(1,3,1);
    imagesc(reshape(mean - sqrt(lamb1)*v1, [WIDTH WIDTH]));
    title("\mu - \surd{\lambda_1} * v_1");
    axis equal, axis off;
    
    subplot(1,3,2);
    imagesc(reshape(mean, [WIDTH WIDTH]));
    title("\mu");
    axis equal, axis off;
    
    subplot(1,3,3);
    imagesc(reshape(mean + sqrt(lamb1)*v1, [WIDTH WIDTH]))
    title("\mu + \surd{\lambda_1} * v_1");
    axis equal, axis off;
    
    sgtitle(sprintf("Digit %i", digit));
    colormap('gray');
    saveas(gcf, sprintf("plots/q4/trip_img_%i.jpg", digit)); % Save current figure
    
    hold off;
    subplot(1,1,1);
    plot(1:SIZE,dia);
    title(sprintf("Sorted Eigenvalues for Digit %i", digit));
    sgtitle("");
    saveas(gcf, sprintf("plots/q4/eigenvalues_%i.jpg", digit)); % Save current figure
    semilogx(1:SIZE,dia);
    fprintf("Significant mode of variations for Digit %i is %i (Number of Eigenvalues > 1%% of Max Eigenvalue)\n", digit, sum(dia>=dia(1)/100));
    title(sprintf("Sorted Eigenvalues for Digit %i (X-axis log scaled)", digit));
    saveas(gcf, sprintf("plots/q4/eigenvalues_log_%i.jpg", digit)); % Save current figure
end

close all;
