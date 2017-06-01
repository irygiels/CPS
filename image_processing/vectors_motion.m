function vectors_motion(blocksize, range)
L=double(imread('L188Undistorted.png'));
P=double(imread('P188Undistorted.png'));
M=motionEstES(P,L,blocksize,range);
figure(2)
imshow(L,[]);
hold on;
quiver(M(2,:),M(1,:),M(4,:),M(3,:),'r');
end

