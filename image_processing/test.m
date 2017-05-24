function y = test ( q )

close all;
img = double( imread( 'cameraman.tif' ) );
bits = jpegCode( img, q );
out = jpegDeCode( bits );
figure(1); imagesc( img ); colormap gray;
figure(2); imagesc( out ); colormap gray;

end