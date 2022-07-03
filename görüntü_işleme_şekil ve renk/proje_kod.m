imread('C:\Users\Erkan\Desktop\matlab_proje\kirmizi_elma.jpg');
meyve_resmi = imread('C:\Users\Erkan\Desktop\matlab_proje\kirmizi_elma.jpg');
image(meyve_resmi);

kirmizi = meyve_resmi(:,:,1); % Meyvenin kırmızı renk değerini değişkene atama işlemi.
yesil = meyve_resmi(:,:,2); % Meyvenin yesil renk değerini değişkene atama işlemi.
mavi = meyve_resmi(:,:,3); % Meyvenin mavi renk değerini değişkene atama işlemi.

renk = 0;

if (kirmizi > 160 & mavi < 30 & yesil < 40 )
    renk = 1; % Kırmızı renk kodu
elseif (kirmizi < 20 & yesil > 160 & mavi < 25 )
    renk = 2; % % Yeşil renk kodu
elseif (kirmizi < 25 & yesil < 30 & mavi > 120 & mavi < 255 )
    renk = 3; % Mavi renk kodu
elseif (kirmizi > 200 & yesil < 140 & yesil > 100 & mavi < 30)
    renk = 4; % Turuncu renk kodu
elseif (kirmizi > 200 & yesil > 200 & mavi < 10)
    renk = 5; % Sarı renk kodu
elseif( kirmizi > 100 & kirmizi < 150 & yesil < 60 & yesil > 60 & mavi < 30)
    renk = 6; % Kahverengi renk kodu

end
figure(1), imshow(meyve_resmi); % Resmi gösterme

griye_cevirme=rgb2gray(meyve_resmi); % Renkli resmi gri tona dönüştürme.
figure(2), imshow(griye_cevirme);

seviye = graythresh(griye_cevirme); % Parlaklık eşiği belirlendi ve 0 ile 1 arasında sayı oluşturuldu.
bw = im2bw(griye_cevirme,0.48); % Resim tamamen siyah-beyaz piksellere dönüştü.
figure(3), imshow(bw);

bw = bwareaopen(bw,30); % 30 px'den daha az sayıda olan pikseller kaldırılıyor. 
figure(4), imshow(bw); % 

se = strel('disk',10); % yarıçapı 10px olan disk biçiminde yapısal element oluşturuyoruz.
bw = imclose(bw,se); % yapısal element yardımıyla iç kısımdaki boşluklar kayboldu.
figure(5), imshow(bw);

[B,L] = bwboundaries(bw,'noholes'),disp(B)
figure(6), imshow(label2rgb(L, @jet, [.5 .5 .5]))

hold on

for k = 1:length(B)
         boundary = B{k}; % 'k' etiketindeki nesnenin sınır koordinatlarını (X.Y) belirler.
          plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
      end

istatistik = regionprops(L,'Area','Centroid');

% Nesneleri sayan loopun başlangıcı
for k = 1:length(B)

    % 'k' etiketindeki nesnenin sınır koordinatlarını (X.Y) belirler
    boundary = B{k};

    % Nesnenin çevresini hesaplar
    delta_kare = diff(boundary).^2;
    cevre = sum(sqrt(sum(delta_kare,2)));

    % 'k' etiketli nesnenin alanını hesaplar
    alan = istatistik(k).Area;

    % Nesnenin metric değerini hesaplar
    metric = 4*pi*alan/cevre^2;

    % Hesaplanan değeri gösterir
    metric_string = sprintf('%2.2f',metric);
    centroid = istatistik(k).Centroid;
    'FillColor'; 'Custom'; ...

    % Eğer metric değer eşik değerden daha büyük ise yuvarlak nesne kabul edilir.
if metric > 0.9344
    text(centroid(1),centroid(2),'Meyve algılanamadı. Lütfen net bir resim ekleyiniz.');

elseif (metric <= 0.6250) && (metric >= 0.6100) || (renk == 1)
    text(centroid(1),centroid(2),'Kırmızı Elma');
elseif (metric <= 0.6555) && (metric >= 0.6251) || (renk == 1)
    text(centroid(1),centroid(2),'Nar');
elseif (metric <= 0.6915) && (metric >= 0.6890) || (renk == 4)
    text(centroid(1),centroid(2),'Mandalina');
elseif (metric <= 0.7500) && (metric >= 0.7350) || (renk == 5)
    text(centroid(1),centroid(2),'Muz');
elseif (metric <= 0.7880) && (metric >= 0.7720) || (renk == 4)
    text(centroid(1),centroid(2),'Portakal')
elseif (metric <= 0.6800) && (metric >= 0.6620) || (renk == 2)
    text(centroid(1),centroid(2),'Karpuz');
elseif (metric <= 0.3455) && (metric >= 0.3220) || (renk == 6) 
    text(centroid(1),centroid(2),'Kivi');
elseif (metric <= 0.5955) && (metric >= 0.5620) || (renk == 1)
    text(centroid(1),centroid(2),'Kiraz');

end
disp(metric)
text(boundary(1,2)-35,boundary(1,1)+13,metric_string,'Color','y',...
    'FontSize',14,'FontWeight','bold');
end