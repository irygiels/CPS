function y = entropy( x )
len=length(x);
%number of different symbols
diff = numel(unique(x))
sym = zeros(diff, 2); %an array for storing symbols
x=sort(x);
pointer=1; %which row is now considered
sym(pointer,:)=[x(1),1]; %the first column is x
for i=2:len
    if x(i)-x(i-1)~=0 %move pointer and write the new element
        pointer=pointer+1;
        sym(pointer,:) = [x(i),1];
    else 
        sym(pointer,2) = sym(pointer,2)+1; %increase the counter
    end
end

%data stored in format: x(i), probability(x(i))
sym(:,2)=sym(:,2)./len;

%sort (ascending probability)
sym=sortrows(sym,2);  
sym

%entropy
H=0;
for i=1:diff
    H=H-sym(i,2)*log2(sym(i,2));
end

H
end