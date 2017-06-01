function [resize_value, percent] = watermark( resize_value );

% digital images watermarks
close all;

% parameters
K = 16;     % watermark size (KxK)
amp = 1;    % amplify

A = imread('goldhill512.png');
B = double(A); 
[M, N] = size(B);

A = imresize(A,resize_value);
A = imresize(A, [M, N]);
B = double(A); 

% adding a watermark
Mb = (M/K); Nb=(N/K);                 % number of watermark 'blocks' in every row and column
plusminus1 = sign( randn(1,Mb*Nb) );  % random sequence of +1/-1
Sign = zeros( size(B) );              % matrix of +1/-1 of the image
for i = 1:Mb
    for j = 1:Nb
        Sign( (i-1)*K+1 : i*K, (j-1)*K+1 : j*K ) = plusminus1(i*j); % filling with KxK +1/-1
    end
end
Noise = round( randn(size(B)) );         % random noise with values -4:4
noisesign = amp * Noise .* Sign;         % watermark modulation
C = uint8( B + noisesign );              % image + watermark, conversion to 8 bits

% plots
%figure, subplot(1,2,1), imshow(Sign,[]);   title('watermark')
%subplot(1,2,2), imshow(noisesign,[]); title('sign modulated with noise')
%figure, subplot(1,2,1); imshow(A,[]);      title('original image')
%subplot(1,2,2); imshow(C,[]);      title('image with hidden watermark')

% watermark detection
D = double(C);                              % back to double precision conversion

% filtration
L = 10; L2=2*L+1;                           % filter size 2D (L x L)
w = hamming(L2); w = w * w';                % 2D window from 1D Hamming

f0=0.5; 
wc = pi*f0; 
[m n] = meshgrid(-L:L,-L:L);                         % LowPass filter
lp = wc * besselj( 1, wc*sqrt(m.^2 + n.^2) )./(2*pi*sqrt(m.^2 + n.^2) ); 
lp(L+1,L+1)= wc^2/(4*pi);                                                
hp = - lp; hp(L+1,L+1) = 1 - lp(L+1,L+1);   % HighPass from LowPass (without 2D window)
h = hp .* w;                                % with 2D window
F = conv2( D, h, 'same');                   % filtration

Demod = F .* Noise;                         % demodulation
detectedsign = zeros( size(F) );            
for i=1:Mb
    for j=1:Nb
%         sum( sum( Demod((i-1)*K+1:i*K, (j-1)*K+1:j*K) ) )
        detectedsign((i-1)*K+1:i*K, (j-1)*K+1:j*K) = ...
            sign( sum( sum( Demod((i-1)*K+1:i*K, (j-1)*K+1:j*K) ) ) );
    end
end
detection_err = sum(sum( abs(Sign-detectedsign) ));

% plots
%figure, subplot(1,2,1); imshow(Demod,[]);      title('demodulation')
%subplot(1,2,2); imshow(detectedsign,[]); title('sign detection')

percent = 100*detection_err/(M*N);
end