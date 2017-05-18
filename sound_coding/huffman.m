function y = huffman( x )
%HUFFMAN Summary of this function goes here
%   Detailed explanation goes here

len=length(x);
%liczba roznych symboli
diff = numel(unique(x))
sym = zeros(diff, 2); %tablica na symbole
x=sort(x);
pointer=1; %wskazuje w jakim jestem rzedzie
sym(pointer,:)=[x(1),1]; %wpisuje pierwszy element do tablicy
%prawdopodobienstwa
for i=2:len
    if x(i)-x(i-1)~=0 %jesli nowy element
        pointer=pointer+1;
        sym(pointer,:) = [x(i),1]; %wpisz nowy element z licznikiem 1
    else 
        sym(pointer,2) = sym(pointer,2)+1; %zwieksz o 1 liczbe wystapien
    end
end

%dane zachowywane w formacie: symbol, prawdopodobienstwo
sym(:,2)=sym(:,2)./len;
sym=sortrows(sym,2);  

end

