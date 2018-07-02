function [y] = cascade_filt(x, fs, type, fc, num_pases, varargin) 
    
    y=x;
    
    % Normalización de la Q 
%         range = [0.707 15];
%         norm_range = range(2) - range(1);
%         Q_range = [0 1];
%         min_Q = Q_range(1); max_Q = Q_range(2);
%         
%         for i = 1:length(varargin{1, 1})
%             varargin{1}{i}(1) = (norm_range) * (varargin{1}{i}(1) - min_Q) / (max_Q - min_Q) + range(1);
%             %varargin{i} = (norm_range) * (varargin{i} - min_Q) / (max_Q - min_Q) + range(1);
%         end
    
    % Slope del LPF y el HPF definido por la cascada de filtros
%     if (strcmp(type, 'low_pass'))||(strcmp(type, 'high_pass')) %error
%         for i=1:num_pases
%             for j=1:length(fc)
%                 y = eq_filters(y, fs, type{j}, fc(j), varargin{1}(j));
%             end
%         end
%     else
    % Cascada de filtros
    for i=1:length(fc)
        y = eq_filters(y, fs, type{i}, fc(i), varargin{1}(i));
%        y = eq_filters(y, fs, type, fc(i), varargin{1});
    end
%    end
    
%     % Plot de la señal de entrada
%     f_x = fft(x);
%     mag_x = abs(f_x(1:length(f_x)/2));
%     mag_x = 20*log10(floor(mag_x)); % eje 'y' en dB
%     frequ_x = (fs/length(f_x))*(0:length(f_x)/2-1);
%     semilogx(frequ_x,mag_x,'b'); % eje 'x' en escala log
%     xlim([0,3e4]);
%     
%     % Plot de la señal de salida
%     figure();
%     f_y = fft(y);
%     mag_y = abs(f_y(1:length(f_y)/2));
%     mag_y = 20*log10(mag_y); % eje 'y' en dB
%     frequ_y = (fs/length(f_y))*(0:length(f_y)/2-1);
%     semilogx(frequ_y,mag_y,'b'); % eje 'x' en escala log
%     xlim([0,3e4]);
    
end