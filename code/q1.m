clc;
clear;
rng(0);

% For n <= 10^8
n_list = [10 10^2 10^3 10^4 10^5 10^6 10^7 10^8];

for n = n_list
    X1 = single(2*rand(n, 1)-1);
    X2 = single(2*rand(n, 1)-1);
    n_u = sum((X1.^2 + X2.^2) <= 1);
    fprintf("N = %i, pi = %.4f \n", n, 4*single(n_u)/single(n));
end


% For large values of n (>= 10^9), we sample n/10^8 10^8 arrays
n_fixed = single(10^8);
n_large = single(10^9);
n_iters = single(n_large/n_fixed);

n_u = single(0);
for i = 1:n_iters
    X1 = single(2*rand(n_fixed, 1)-1);
    X2 = single(2*rand(n_fixed, 1)-1);
    n_u = n_u + sum((X1.^2 + X2.^2) <= 1);
end

pi_accurate = 4*single(n_u/n_large);
fprintf("(Large N) N = %i, pi = %.4f \n", n_large, pi_accurate);
