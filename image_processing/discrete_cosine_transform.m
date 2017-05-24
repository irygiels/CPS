function y = discrete_cosine_transform

IM1 = zeros(128,128);
IM2 = zeros(128,128);
IM3 = zeros(128,128);
IM4 = zeros(128,128);

IM1(2,10)=1;
IM2(15,4)=1;
IM3(35,17)=1;
IM4(8,26)=1;

im1 = idct2(IM1);
im2 = idct2(IM2);
im3 = idct2(IM3);
im4 = idct2(IM4);

im = im1 + im2 + im3 + im4;

J=dct2(im);
% J(15,4)=0;
% J(35,17)=0;
% J(8,26)=0;

figure(1)
imshow(log(abs(J)),[])
colormap(gca,jet(64))
colorbar

end

