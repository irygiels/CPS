function y = ortogonal_transform ( image , threshold )

A = imread(image);
J = dct2(A);
%show the image
figure(1)
imshow(log(abs(J)),[])
colormap(gca,jet(64))
colorbar

%if magnitude < threshold then 0
J(abs(J) < threshold) = 0; 
K = idct2(J);

%display the original image alongside the processed image
figure(2)
imshowpair(A,K,'montage');
title('Original Image (Left) and Processed Image (Right)');