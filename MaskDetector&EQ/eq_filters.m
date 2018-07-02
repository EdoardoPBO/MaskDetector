function y = eq_filters(x, fs, type, fc, varargin)

    a0 = 1; a1 = 0; a2 = a1; b1 = a1; b2 = a1;
    z1 = 0.0;
    z2 = 0.0;
    fc = fc/fs;
    K = tan(pi*fc); 

    switch type

        case 'low_pass'

            %Q = varargin{1}{1};
            Q = varargin{1};
         
            norm = 1 / (1 + K / Q + K * K);
            a0 = K * K * norm;
            a1 = 2 * a0;
            a2 = a0;
            b1 = 2 * (K * K - 1) * norm;
            b2 = (1 - K / Q + K * K) * norm;

        case 'high_pass'

            Q = varargin{1}{1};
            norm = 1 / (1 + K / Q + K * K);
            a0 = 1 * norm;
            a1 = -2 * a0;
            a2 = a0;
            b1 = 2 * (K * K - 1) * norm;
            b2 = (1 - K / Q + K * K) * norm;
            
        case 'peak'

            Q = varargin{1}{1}(1);
            pG = varargin{1}{1}(2);
            V = 10^(abs(pG)/20.0); % dB to linear
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
            
        case 'low_shelf'
            
            pG = varargin{1}{1};
            V = 10^(abs(pG)/20.0); % dB to linear
            if (pG >= 0)    % boost

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
            
        case 'high_shelf'
            
            pG = varargin{1}{1};
            V = 10^(abs(pG)/20.0); % dB to linear
            if (pG >= 0)    % boost

              norm = 1 / (1 + sqrt(2) * K + K * K);
              a0 = (V + sqrt(2*V) * K + K * K) * norm;
              a1 = 2 * (K * K - V) * norm;
              a2 = (V - sqrt(2*V) * K + K * K) * norm;
              b1 = 2 * (K * K - 1) * norm;
              b2 = (1 - sqrt(2) * K + K * K) * norm;

            else     % cut

              norm = 1 / (V + sqrt(2*V) * K + K * K);
              a0 = (1 + sqrt(2) * K + K * K) * norm;
              a1 = 2 * (K * K - 1) * norm;
              a2 = (1 - sqrt(2) * K + K * K) * norm;
              b1 = 2 * (K * K - V) * norm;
              b2 = (V - sqrt(2*V) * K + K * K) * norm;

            end

    end

    y = zeros(size(x));
    for i=1:length(x)
         
          y(i) = a0 * x(i)  + z1;
          z1 = a1 * x(i) - b1 * y(i) + z2 ;
          z2 = a2 * x(i) - b2 * y(i);
        
    end

end