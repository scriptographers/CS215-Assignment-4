clc;
clear;
close all;

% Paths:
DATA_PATHS = ["../data/points2D_Set1.mat" "../data/points2D_Set2.mat"];
SAVE_PATHS = ["plots/q3i.jpg" "plots/q3ii.jpg"];

for i = [1 2]
    
    % Load data
    load(DATA_PATHS(i), "-mat");

    % Scatter Plot
    hold off;
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
    mean = sum(data_uncentered)./N;
    % Center the data about the mean
    data = data_uncentered - mean;

    % Computing the sample covariance matrix
    C11 = sum(data(:,1).^2)/N;
    CXX = sum(data(:,1).*data(:,2))/N;
    C22 = sum(data(:,2).^2)/N;
    C = [C11 CXX; CXX C22];
    % Eigenvalue decomposition of C
    [Q, lambda] = eig(C);

    % Selecting the principal mode of variance
    diagonal = diag(lambda); % converts daigonal matrix into a column vector
    [~, idx] = max(diagonal); % getting index via argmax
    v = Q(:, idx); % Selecting column of q which corresponds to the principal mode of variance

    % Computing parameters of the line
    m = v(2)/v(1); % slope of the line to be fitted
    c = mean(2)-m*mean(1); % intercept

    % Plotting the fitted line
    x_line = min(x):0.005:max(x); 
    y_line = m*x_line + c;
    hold on;
    plot(x_line, y_line, 'r');
    legend(["Given Data", "Fitted line using PCA"], "Location", "Northwest");
    saveas(gcf, SAVE_PATHS(i)); % Save current figure

end


