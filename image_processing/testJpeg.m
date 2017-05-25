function y = testJpeg ( q )

close all;
img = double( imread( 'cameraman.tif' ) );
[bits, idxs] = jpegCode( img, q );
out = jpegDecode( bits, idxs );
figure(1); imagesc( img ); colormap gray;
figure(2); imagesc( out ); colormap gray;

end