function [y] = peak(x, fc, Q, pG)

    fs = 44100;
    fc = fc/fs;
    z1 = 0.0;
    z2 = 0.0;

    V = 10^(abs(pG)/20.0); % dB to linear
    K = tan(pi*fc);


    if (pG >= 0)    %boost

        norm = 1 / (1 + 1/Q * K + K * K);
        a0 = (1 + V/Q * K + K * K) * norm;
        a1 = 2 * (K * K - 1) * norm;
        a2 = (1 - V/Q * K + K * K) * norm;
        b1 = a1;
        b2 = (1 - 1/Q * K + K * K) * norm;

    else  %cut

        norm = 1 / (1 + V/Q * K + K * K);  
        a0 = (1 + 1/Q * K + K * K) * norm;
        a1 = 2 * (K * K - 1) * norm;
        a2 = (1 - 1/Q * K + K * K) * norm;
        b1 = a1;
        b2 = (1 - V/Q * K + K * K) * norm;

    end

    y = zeros(size(x));
    for i=1:length(x)
        y(i) = x(i) * a0 + z1;
        z1 = x(i) * a1 + z2 - b1 * y(i);
        z2 = x(i) * a2 - b2 * y(i);
    end
  
end