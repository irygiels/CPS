close all;
clear;
clf;

[x,fpr]=audioread('mowa1.wav');	

org = x;
sp = 1.1e4:1.16e4; 
d = 1e4:1.06e4; 
nd = 3.95e4:4.05e4; 

hold on;
plot(x); title('speech signal');
plot(x(nd), 'r');
plot(x(d), 'g');
plot(x(sp), 'm');
hold off;
% pause;

%spectral densities

%comment: if x is a signal then its spectral density is equal to fft of its
%autocorrelation
%sp_den_n=fft(xcorr(x(n),x(n)))
%plot(abs(sp_den_n))
%plot(10*log10(abs(sp_den_n))
%sp_den_d=fft(xcorr(x(d),x(d)))
%plot(d, org(d))

%spectrum - a general formula
%Fs = fpr; 
%t = 0:1/Fs:1-1/Fs; 
%Y=fft(x); 
%W=(abs(Y)).^2; 
%Z=10*log10(W); 
%plot(Z) 

N=length(x);    %signal length
Mlen=240;       %hamming window length
Mstep=180;      %time shift
Np=10;          %prediction filter
pos=Mstep+1;    %initial position

lpc=[];								 
s=[]; %speech synthesis (all fragments)								
ss=[]; %speech synthesis (one fragment)								  
bs=zeros(1,Np);
Nframes=floor((N-Mlen)/Mstep+1);	

x=filter([1 -0.9735], 1, x);	%pre-emphasis
plot(d, org(d), d, x(d), 'r');

for  nr = 1 : Nframes
    %next fragment of the signal
    n = 1+(nr-1)*Mstep : Mlen + (nr-1)*Mstep;
    bx = x(n);
    
    %thresholding
    P = 0.3 * max (bx);
    for k=1:length(bx)
       if(bx(k) >= P)
           bx(k) = bx(k) - P;
       elseif bx(k) <= -P
           bx(k) = bx(k) + P;
       else
           bx(k) = 0;
       end
    end
    
    %determining if sounds are resonant
    bx = bx - mean(bx); 
    for k = 0 : Mlen-1
        r(k+1) = sum( bx(1 : Mlen - k).* bx(1+k : Mlen)); %autocorrelation
    end
    
    %plot(n,bx); title('speech signal fragment');
    %plot(r); title('speech signal fragment autocorr');
    
    offset=20; rmax=max( r(offset : Mlen) ); %max of autocorr	  
    imax=find(r==rmax); %index of autocorr max
    
    if ( rmax > 0.35*r(1) ) T=imax; else T=0; end 
    T %resonant/not			
    TM(nr)=T;
    rr(1:Np,1)=(r(2:Np+1))';
    for m=1:Np
        R(m,1:Np)=[r(m:-1:2) r(1:Np-(m-1))]; %autocorr matrix	
    end
    a=-inv(R)*rr; %prediction filter indexes											
    amplifier=r(1)+r(2:Np+1)*a;			
    %H=freqz(1,[1;a]);
    %plot(abs(H));

    if (T~=0) pos=pos-Mstep; end					
    for n=1:Mstep
        if( T==0)
            pob=2*(rand(1,1)-0.5); pos=(3/2)*Mstep+1;			
        else
            if (n==pos) pob=1; pos=pos+T;	   
            else pob=0; end
        end
        ss(n)=amplifier*pob-bs*a;		
        bs=[ss(n) bs(1:Np-1) ];	
    end
    s = [s ss];						
end
s=filter(1,[1 -0.9735],s); % de-emphasis
%plot(s); title('speech synthesis'); pause
%soundsc(s, fpr); pause
%soundsc(x,fpr);	

