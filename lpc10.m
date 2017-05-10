close all;
clear;
clf;

[x,fpr]=audioread('mowa1.wav');	

org = x;
n = 1.1e4: 1.2e4; 
d = 1e4:1.1e4; 

%wyswietl na wykresie
hold on;
plot(x); title('speech signal');
plot(x(n), 'r');
plot(x(d), 'g');
hold off;
% pause;

N=length(x);	 %signal length
Mlen=240;		 %hamming window length
Mstep=180;		 %time shift
Np=10;			 %prediction filter
pos=Mstep+1;	 %initial position

lpc=[];								 
s=[];								
ss=[];								  
bs=zeros(1,Np);
Nframes=floor((N-Mlen)/Mstep+1);	
for  nr = 1 : Nframes
    
    n = 1+(nr-1)*Mstep : Mlen + (nr-1)*Mstep;
    bx = x(n);
    
    bx = bx - mean(bx); 
    for k = 0 : Mlen-1
        r(k+1) = sum( bx(1 : Mlen - k).* bx(1+k : Mlen));
    end
    
    offset=20; rmax=max( r(offset : Mlen) );	  
    imax=find(r==rmax);
    if ( rmax > 0.35*r(1) ) T=imax; else T=0; end 
    T							  
    rr(1:Np,1)=(r(2:Np+1))';
    for m=1:Np
        R(m,1:Np)=[r(m:-1:2) r(1:Np-(m-1))];			
    end
    a=-inv(R)*rr;											
    amplifier=r(1)+r(2:Np+1)*a;									
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
plot(s); title('speech - synthesis'); pause
soundsc(s, fpr); pause
soundsc(x,fpr);	

