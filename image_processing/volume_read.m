clear all; close all;
%cd('./Dane/CT_1' ) % wej�cie do katalogu z DICOM-ami
%% ---- ustalenie wymiaru przekroju
%figure,
I = dicomread('c32b1_009.dcm'); imshow(I,[]) % wczytanie pierwszego z brzegu przekroju
info = dicominfo('c32b1_009.dcm');
%imcontrast() % tutaj imcontrast do ustalenia progów: 750 i 1150-robiłem na
%obrazku 9 bo łatow było się do instrukcji odnieść

Nx = info.Width ; % znale�� wymiary przekroju
Ny = info.Height; % znale�� wymiary przekroju
%% zapisywanie przekroj�w do macierzy 3D i 
pliki = dir('*.dcm');   % struktura z nazwami wszystkich plik�w w formacie .dcm znajduj�cych si� w bie��cym folderze
CT = zeros(Nx,Ny,length(pliki));  % macierz zer do zapisywania kolejnych przekroj�w DICOM
kontrolaZ=zeros(1,length(pliki));

for i = 1:length(pliki)
    % zapisywanie przekroj�w
    slice = dicomread(pliki(i).name);
    info = dicominfo(pliki(i).name);
    CT(:,:,info.InstanceNumber) = slice;
    % zapisywanie potzebnych metadanych
    kontrolaZ(info.InstanceNumber) = info.SliceLocation;
    kontrolaSeries(info.InstanceNumber)=info.SeriesNumber;
    kontrolaSlice(info.InstanceNumber)=info.SliceThickness;
    kontrolaPosition(info.InstanceNumber,:)=info.ImagePositionPatient;
    kontrolaSpacing(info.InstanceNumber,:)=info.PixelSpacing;
    
end


%% weryfikacja poprawno�ci zapisania danych
% subplot(121)
figure,
plot(kontrolaSpacing(:,2));hold on;
plot(kontrolaSlice(1,:),'g');
plot(kontrolaPosition(:,3),'r');grid on;
plot(kontrolaZ,'c');grid on;
legend('Pixel Spacing','SliceThickness','ImagePositionPatient','SliceLocation');
figure;
PS_sl_num = 256;
CT_sp = squeeze(CT(:,PS_sl_num,:));
CT_sp = imresize(CT_sp,[512 512],'bilinear');
% subplot(122);
%imshow(CT_sp,[1000 1100])
B1=dicomread(pliki(1).name);
[ k, l ] = size(B1);
B = zeros(k, l, length(pliki));
progd=850;
progg=1180;
for i=1:length(pliki)
   % if(i==9)
   %figure(1)
   B1=dicomread(pliki(i).name);
   B(:,:,i)=B1;
   B1(B1<progd)=0;
   B1(B1>progg)=2000;
   %B1(B1==0)=2000;
  
   %imshow(B1,[]);colormap('gray');colorbar
    %else continue;
    %end;
end

figure(2);
colormap('gray');
contourslice(B,[],[],[1, 12, 27],4);
view(3);
axis tight