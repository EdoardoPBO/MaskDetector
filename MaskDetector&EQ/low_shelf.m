function [y] = low_shelf(x, fc, pG)

    fs = 44100;
    fc = fc/fs;
    z1 = 0.0;
    z2 = 0.0;

    V = 10^(abs(pG)/20.0); % dB to linear
    K = tan(pi*fc);


   if (peakGain >= 0)    % boost

       norm = 1 / (1 + sqrt(2) * K + K * K);
       a0 = (1 + sqrt(2*V) * K + V * K * K) * norm;
       a1 = 2 * (V * K * K - 1) * norm;
       a2 = (1 - sqrt(2*V) * K + V * K * K) * norm;
       b1 = 2 * (K * K - 1) * norm;
       b2 = (1 - sqrt(2) * K + K * K) * norm;
           
   else     % cut
       norm = 1 / (1 + sqrt(2*V) * K + V * K * K);
       a0 = (1 + sqrt(2) * K + K * K) * norm;
       a1 = 2 * (K * K - 1) * norm;
       a2 = (1 - sqrt(2) * K + K * K) * norm;
       b1 = 2 * (V * K * K - 1) * norm;
       b2 = (1 - sqrt(2*V) * K + V * K * K) * norm;
   end

    y = zeros(size(x));
    for i=1:length(x)
        y(i) = x(i) * a0 + z1;
        z1 = x(i) * a1 + z2 - b1 * y(i);
        z2 = x(i) * a2 - b2 * y(i);
    end
  
end