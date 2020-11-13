clc;
clear;
close all;

% Paths:
DATA_PATHS = ["../data/points2D_Set1.mat", "../data/points2D_Set2.mat"];
SAVE_PATHS = ["plots/q3/q3i.jpg", "plots/q3/q3ii.jpg"];

for i = [1 2]
    % Load data
    load(DATA_PATHS(i), "-mat");
    
    % Scatter Plot
    figure;
    scatter(x, y, 5, "filled");
    grid on;
    axis equal;
    xlabel("x");
    ylabel("y");
    title("Question 3");
    
    % Create R^2 data
    N = size(x, 1);
    data_uncentered = [x y]; % Nx2 matrix of observed data
    
    % Computing the sample mean
    mu = sum(data_uncentered)./N;
    
    % Center the data about the mean
    data = data_uncentered - mu;
    
    % Computing the sample covariance matrix
    C = (1/(N-1)).*(data' * data);
    
    % Eigenvalue decomposition of C
    [v, ~] = eigs(C, 1); % Select only the first principal component
    
    % Computing parameters of the line
    m = v(2)/v(1); % slope of the line to be fitted
    c = mu(2)-m*mu(1); % intercept
    
    % Plotting the fitted line
    x_line = min(x):0.005:max(x);
    y_line = m*x_line + c;
    hold on;
    plot(x_line, y_line, 'r');
    legend(["Given Data", "Fitted line using PCA"], "Location", "Northwest");
    saveas(gcf, SAVE_PATHS(i)); % Save current figure
end

clear i;
