A=zeros(1,10); 
B=zeros(1,10);

for i=1:10
    [A(i) B(i)] = watermark(0.1*i);
end
plot(A,B, '*r'); xlabel('resize scale'); ylabel('percent of detected errors'); axis([0 1.05 0 2*max(B)]);
hold on;
p = polyfit(A,B,1);
x1 = linspace(0, 1.05);
y1 = polyval(p, x1);
plot(x1,y1);