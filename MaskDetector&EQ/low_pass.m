function [y] = low_pass(x, fc, Q)

    fs = 44100;
    fc = fc/fs;
    z1 = 0.0;
    z2 = 0.0;
    
    K = tan(pi*fc);
    
    norm = 1 / (1 + K / Q + K * K);
    a0 = K * K * norm;
    a1 = 2 * a0;
    a2 = a0;
    b1 = 2 * (K * K - 1) * norm;
    b2 = (1 - K / Q + K * K) * norm;

    y = zeros(size(x));
    for i=1:length(x)
        y(i) = x(i) * a0 + z1;
        z1 = x(i) * a1 + z2 - b1 * y(i);
        z2 = x(i) * a2 - b2 * y(i);
    end
    
end