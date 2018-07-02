function [mel,mr] = frq2mel(frq)

persistent k
if isempty(k)
    k=1000/log(1+1000/700); %  1127.01048
end
    af=abs(frq);
    mel = sign(frq).*log(1+af/700)*k;
    mr=(700+af)/k;
    if ~nargout
        plot(frq,mel,'-x');
        xlabel(['Frequency (' xticks 'Hz)']);
        ylabel(['Frequency (' yticks 'Mel)']);
    end
end