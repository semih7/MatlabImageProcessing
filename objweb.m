%video giriþi hazýrlandý
clc; clear all;
vid = videoinput('winvideo',2,'YUY2_1280x720');
%web kamerasýndan elde edilen videonun frame geçiþi belirlendi
vid.FramesPerTrigger=inf;
%her 5 milisaniyede frame geçiþi ayarlandý
set(vid,'ReturnedColorspace','rgb');
vid.FrameGrabInterval=5;
%kamera baþlatýldý
hmain = gca;
area = zeros(16,2)
start(vid);
for i=1:100
    %snapshot ile görüntü alýndý
    data = getsnapshot(vid);
    %Renkler ayýklandý
    data_gray = imsubtract(data(:,:,1),rgb2gray(data));
    %Renkler ayýklandý
    data_gray = medfilt2(data_gray,[3,3]);
    %Ýmage dosyasýný binary'e çevirir.
    %Ýmage'deki bütün pixelleri binary'e çevirdi
    data_gray = im2bw(data_gray,0.24);
    %kamera açýsý sýnýrlandýrýldý
    data_gray = bwareaopen(data_gray,100);
    bw = bwlabel(data_gray,8);
    %Belirlenen nesnenin kenarlarý çizildi
    stats = regionprops(bw,'BoundingBox','Centroid');
    %video çözünürlüðü grafik olarak gösterildi
    image(data)
    hold on
    for(object = 1:length(stats))
        bb = stats(object).BoundingBox;
        bc = stats(object).Centroid;
        rectangle('Position',bb,'EdgeColor','y','LineWidth',2);
        %Nesne çizildi
        plot(bc(1),bc(2),'-m+');
        %Koordinatlar santimetre formatýnda yazýldý
        a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))*0.019), 'Y: ', num2str(round(bc(2))*0.022)));
        set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
        
        textarea = text(bc(1)+15,bc(2), ['  area:  ', num2str(round(area(object,2))/100)*100],'Parent',hmain);
        set(textarea, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
    end
    hold off
    end
stop(vid);
flushdata(vid);