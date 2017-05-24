function img = jpegDeCode( bits )

idx = 1;
q = bin2dec( char( bits(idx:idx+15)+48 )' );
idx = idx +16;
xi = bin2dec( char( bits(idx:idx+15)+48 )' );
idx = idx +16;
yi = bin2dec( char( bits(idx:idx+15)+48 )' );
idx = idx +16;

img = zeros( xi, yi );
DC = 0;
for x = 1:8:xi
    for y = 1:8:yi
        [ DC, pair, idx ] = DeVLC( DC, bits, idx );
        zblok = DeRLE( DC, pair );
        qblok = DeZigZag( zblok );
        dblok = DeKwant( qblok, q );
        blok = IDCT8x8( dblok );
        img( x:x+7, y:y+7 ) =  blok;
    end
end
end


function [ DC2, y, idx2 ] = DeVLC( DC1, x, idx1 )
% DC1: wartosc DC w poprzednim bloku
% x: strumien bitowy
% idx1: biezaca pozycja w strumieniu bitowym
% DC2: wyznaczona wartosc DC w biezacym bloku
% y: ,,pary'' w formacie Nx2 gdzie N oznacza ilosc par (kazdy wiersz to jedna para)
%      ilosc par w konkretnym bloku 8x8 zalezy od danych danych wejsciowych
% idx2: indeks w stumieniu bitowym po przeczytaniu biezacego bloku

y = [];
idx2 = idx1;

l = bin2dec( char( x(idx2:idx2+3)+48 )' );
idx2 = idx2 + 4;
if( l == 0 )
    DC = 0;
else
    if( x(idx2) == 0 )
        b = char( 1-x(idx2:idx2+l-1)+48 )';
        DC = -bin2dec( b );
    else
        b = char( x(idx2:idx2+l-1)+48 )';
        DC = bin2dec( b );
    end
    idx2 = idx2 + l;
end
DC2 = DC1 - DC;

bblok = 63;
while bblok>0
    x1 = bin2dec( char( x(idx2:idx2+3)+48 )' );
    idx2 = idx2 + 4;
    bblok = bblok - x1;
    
    l = bin2dec( char( x(idx2:idx2+3)+48 )' );
    idx2 = idx2 + 4;
    bblok = bblok - 1;
    if( l == 0 & x1 == 0 )
        y = [ y; [ 0, 0 ] ];
        return;
    elseif( l == 0 )
        y = [ y; [ x1, l ] ];
    else
        if( x(idx2) == 0 )
            b = char( 1-x(idx2:idx2+l-1)+48 )';
            x2 = -bin2dec( b );
        else
            b = char( x(idx2:idx2+l-1)+48 )';
            x2 = bin2dec( b );
        end
        idx2 = idx2 + l;
        y = [ y; [ x1, x2 ] ];
    end
end
end


function y = DeRLE( DC, x )
% x: ,,pary'' w formacie Nx2 gdzie N oznacza ilosc par (kazdy wiersz to jedna para)
% DC: wartosc parametru DC
% y: skwantowane wspolczynniki w formacie wektora o wymiarach 64x1

idx = 1;
y = zeros( 64, 1 );
y(1) = DC;
idx = idx + 1;

[ xx, ~ ] = size( x );
for i=1:xx
    pair = x( i, : );
    if( pair(1) == 0 && pair(2) == 0 )
        y(idx:end) = 0;
        return;
    end
    l = pair(1);
    y(idx:idx+l-1) = 0;
    idx = idx + l;
    y(idx) = pair(2);
    idx = idx + 1;
end
end


function  y = DeZigZag( x )
% x: wektor o wymiarach 64x1
% y: blok 8x8 wyznaczony algorytem ZigZag
for i=1:8
    y(i,:)=x((i-1)*8+1:i*8);
end
end


function y = DeKwant( x, q )
% x: blok 8x8 skwantowanych wspolczynnikow transformaty DCT
% q: wspolczynnik kwantyzacji
% y: unormowane wspolczynniki x
y=(x-0.5)*q;
end


function y = IDCT8x8( x )
% x: blok 8x8 wspolczynnikow DCT
% y: blok 8x8 pix
y=idct2(x);
end