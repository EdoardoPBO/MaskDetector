clear;
clc;
%% Mask Detection + EQ for Bark and Frequency Methods
d=dir(uigetdir);
for i=3:length(d)
    names{i-2}=strcat('tracks/',d(i).name);   
    [inputBark{i-2},fs]=audioread(names{i-2});
end
maxLen=0;
Q=10;
rT=10;
input=inputBark;
inputFreq=inputBark;
for j=1:length(inputBark)
    for i=1:length(inputBark)
        if j~=i
            inputBark{j}=barkMethod(inputBark{i},inputBark{j}, Q,rT,fs);
            inputFreq{j}=frequencyMethod(inputFreq{i},inputFreq{j}, Q,rT,fs);
        end
    end
    maxLen=max(maxLen,length(inputFreq{j}));
end
%% Write output wavs for subjective evaluation
mkdir outputBark
mkdir outputFreq

for i=1:length(inputBark)
    audiowrite(strcat('outputBark/',num2str(i),'.wav'),inputBark{i},fs);
    audiowrite(strcat('outputFreq/',num2str(i),'.wav'),inputFreq{i},fs);
end
%% Objective Evaluation: Loudness Gain
input=zeroPad(input);
inputBark=zeroPad(inputBark);
inputFreq=zeroPad(inputFreq);
mix=zeros(maxLen,1);
mixBark=zeros(maxLen,1);
mixFreq=zeros(maxLen,1);
for i = 1:length(input)
    if size(inputBark{i},2)==2
        input{i}=(input{i}(:,1)+input{i}(:,2))/sqrt(2);
        inputBark{i}=(inputBark{i}(:,1)+inputBark{i}(:,2))/sqrt(2);
        inputFreq{i}=(inputFreq{i}(:,1)+inputFreq{i}(:,2))/sqrt(2);
    end
    mix=mix+input{i};
    mixBark=mixBark+inputBark{i};
    mixFreq=mixFreq+inputFreq{i};
end
Lin=integratedLoudness(mix,fs);
LoutBark=integratedLoudness(mixBark,fs);
LoutFreq=integratedLoudness(mixFreq,fs);
LD=['Loudness gain Bark: ',num2str(LoutBark-Lin),' LUFS'];
disp(LD)

LD=['Loudness gain Freq: ',num2str(LoutFreq-Lin),' LUFS'];
disp(LD)
