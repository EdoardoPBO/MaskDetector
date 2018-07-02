function [ y ] = fftOvMean( x,ov,win,type )
%fftOvMean: Function that computes the mean FFT for input track x
%   Input:
%       x: input track
%       ov: overlap (0-1)
%       win: window size
%       type: window type (rectangular or hanning)
%   Output:
%       y: mean FFT of x
%    
    if ~(ov<=1 && ov>0)
        disp('overlap must be between 0 and 1')
    else
        
        cont=1;
        len=length(x);
        hop=floor(ov*win);
        sec=1:hop:len; %hop vector
        X=zeros(length(sec),win);
        
        for i=sec %from 1 to end of track with step size equal to hop
           
            if strcmp(type,'rectangular') %rectangular window
                window=ones(length(x(i:i+min([win-1,len-i]))),1);
                X(cont,:)=fft(window.*x(i:i+min([win-1,len-i])),win);
            else %hanning window
                window=hanning(length(x(i:i+min([win-1,len-i]))));
                X(cont,:)=fft(window.*x(i:i+min([win-1,len-i])),win);
            end
            
            cont=cont+1;
        end
        max_X=abs(max(max(X'))); %overall maximum
        for i=1:cont-1
        
            if abs(max(X(i,:)))<0.9*max_X %gate threshold set at 90% of overall maximum
                X(i,:)=zeros(1,win);
            end 
        end
        X( ~any(X,2),: ) = []; %remove rows that are zeros
        %output
        y=mean(X,1);
        
    end
    
    
    
end