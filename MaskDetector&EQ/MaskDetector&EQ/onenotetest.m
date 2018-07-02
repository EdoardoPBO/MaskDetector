close all
clear
x1=audioread('tracks/pianobb3.wav');
x1=1/sqrt(2)*(x1(:,1)+x1(:,2));
x2=audioread('tracks/synthbb3.wav');
x2=1/sqrt(2)*(x2(:,1)+x2(:,2));
fs=44100;
X1=fft(x1(1:length(x1)-1));
X1=fftshift(X1);
X1=X1(length(X1)/2+1:end);
X1=(abs(X1));
X2=fft(x2(1:length(x1)-1));
X2=fftshift(X2);
X2=X2(length(X2)/2+1:end);
X2=(abs(X2));

f = fs/2*linspace(0,1,length(X1));
[mel,mr]=frq2mel(f);
[b,c]=frq2bark(f);
gridbark=barkgrid(b,mag2db(X1));
bin=gridbark>0;
fn=f(bin);

subplot(2,1,1)
plot(b,mag2db(X1)); hold on
plot(b,gridbark); hold off
axis([min(b) max(b) min(mag2db(abs(X1))) max(mag2db(abs(X1)))])
subplot(2,1,2)
plot(b,mag2db(X2));hold on
plot(b,gridbark); hold off
axis([min(b) max(b) min(mag2db(X1)) max(mag2db(X2))])

Xres=X1-X2;
figure;
plot(b,mag2db(Xres)); hold on
plot(b,gridbark);
axis([min(b) max(b) min(mag2db(Xres)) max(mag2db(Xres))])

figure;
plot(f,mag2db(X1)); hold on
plot(f,mag2db(X2)); hold off
axis([min(f) max(f) min(mag2db(X1)) max(mag2db(X1))])
