clc;
clear;
close all;

% Find A from Covariance matrix C where C=A*A'
mu = [1; 2];
cov = [1.6250 -1.9486; -1.9486 3.8750];
[Q, D] = eig(cov);
A = Q*sqrt(D);

% Find norm of mu and frobenius norm of cov
norm_mu = norm(mu);
norm_cov = norm(cov);

% Initialize empty matrices to store error
mean_err = zeros(100, 5);
cov_err = zeros(100, 5);

for lN=1:5 % Looping over values of log10(N)
    N = 10^lN;
    for iter=1:100 % Repeating 100 times for a given N
        rng(2*iter); % Setting seed to reproduce results
        x_mu = A * randn(2,N); % values from (X - mu)
        x = x_mu + mu; % values from X
        
        % ML estimate of mean is sum(x)/N
        mean_mle = sum(x,2) / N;
         % ML estimate of covariance matrix is sum((x-mu)(x-mu)')/N
        cov_mle = x_mu*x_mu' / N;
        
        % Error measure of mean and covariance
        mean_err(iter,lN) = norm(mu - mean_mle) / norm_mu;
        cov_err(iter,lN) = norm(cov - cov_mle) / norm_cov;
    end
    
    hold off;
     % Plot data points for seed=100
    scatter(x(1,:), x(2,:));
    
    % Calculating principal mode of variation
    [Q, lambda] = eig(cov_mle);
    if lambda(1, 1) > lambda(2, 2)
        ep = D(1,1)*Q(:, 1);
    else
        ep = D(2,2)*Q(:, 2);
    end
    line([0 ep(1)] + mean_mle(1), [0 ep(2)] + mean_mle(2),'Color','red','LineStyle','--','LineWidth',1);

    title(sprintf("N = %i", N));
    saveas(gcf, sprintf("plots/q2/d_%i.jpg", N)); % Save current figure
end

hold off;
% Box plotting the mean error values for different N
boxplot(mean_err);
title('Error b/w True mean & ML estimate');
ylabel('Error');
xlabel('log_{10}(N)');
saveas(gcf, "plots/q2/mean_err.jpg"); % Save current figure

hold off;
% Box plotting the covariance error values for different N
boxplot(cov_err);
title('Error b/w True covariance & ML estimate');
ylabel('Error');
xlabel('log_{10}(N)');
saveas(gcf, "plots/q2/cov_err.jpg"); % Save current figure

close all;

function ret = norm(vec)
    ret = sqrt(sum(vec.*vec, 'all'));
end

