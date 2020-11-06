% MinMax scaler for scaling images to [0, 1]
function [y] = toImg(x, shape)
    y = x - min(x);
    y = y/max(y);
    y = reshape(y, shape);
end