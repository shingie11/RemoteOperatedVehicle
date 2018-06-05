function [red,green,blue,cyan,magenta,yellow,nyyy]=dummyQR(image1)
%clear
%close all
%image1=imread('pilotqrQ.png');
image=image1;
figure;imshow(image)
minimum_image=min(image,[],3);
%minimum_image=double(minimum_image);
%figure;imshow(minimum_image)
%xxx=~im2bw(minimum_image,graythresh(minimum_image));
%figure;imshow(xxx)
xxx=~imbinarize(minimum_image);
%xxx=medfilt2(xxx);
%figure;imshow(xxx)
zzz=imfill(xxx,'holes');
%figure;imshow(zzz)
CC=bwconncomp(zzz);
numPixels=(cellfun(@numel,CC.PixelIdxList));
yyy=zeros(size(zzz));
for i=1:4%numel(numPixels)
    [biggest,idx] = max(numPixels);
    if i==1,numPixels(idx)=0;continue;end
    yyy(CC.PixelIdxList{idx}) = 255;
    %yyy=minimum_image(CC.PixelIdxList{idx});
    %CC.PixelIdxList{idx}=[];
    numPixels(idx)=0;
    %numPixels=(cellfun(@numel,CC.PixelIdxList));
    %figure;imshow(yyy)
end
yyy=logical(yyy);
%figure;imshow(yyy)
nyyy=xxx & yyy;
%figure;imshow(nyyy)
newimage=double(minimum_image);
newimage(~nyyy)=255;
% newimage=double(minimum_image+1);
% newimage=newimage.*nyyy;
% newimage(newimage==0)=255;
% newimage=newimage-1;
figure;imshow(uint8(newimage))
image=double(image);
image=image.*nyyy;
image=uint8(image);
figure;imshow((image))
%lab_he = rgb2lab(image);
%ab = lab_he(:,:,1:3);
ab=im2double(image);
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,3);
%ab = ab(any(ab,2),:);
nColors = 7;
% repeat the clustering 3 times to avoid local minima
[cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
                                      'Replicates',10);
pixel_labels = reshape(cluster_idx,nrows,ncols);
%figure;imshow(pixel_labels,[])
%segmented_images = cell(1,nColors);
%rgb_label = repmat(pixel_labels,[1 1 3]);
topleft=[0 0];bottomleft=[1 nrows];topright=[ncols 1];l=1;m=1;n=1;
for k = 1:nColors
    if sum(cluster_center(k,:))<0.1,continue;end
    dumage=zeros(nrows,ncols);
    %color = image;
    %color(rgb_label ~= k) = 255;
    dumage(pixel_labels==k)=255;
    rmcomp=bwconncomp(dumage);nPixels=(cellfun(@numel,rmcomp.PixelIdxList));
    for jj=1:numel(nPixels)
        [biggest,idx] = max(nPixels);
        if jj==1,nPixels(idx)=0;continue;end
        dumage(rmcomp.PixelIdxList{idx}) = 0;
        nPixels(idx)=0;
    end
    dumage=logical(dumage);%dumage=medfilt2(dumage);
    %dumage=bwareaopen(dumage,100);
    figure;imshow(dumage);
    SS=regionprops(dumage,'Centroid');%disp(cluster_center(k,:))
    [~,distm]=min([norm(SS.Centroid-topleft) norm(SS.Centroid-bottomleft) norm(SS.Centroid-topright)]);
    if distm==1, tlcat{l}=dumage;l=l+1;end
    if distm==2, blcat{m}=dumage;m=m+1;end
    if distm==3, trcat{n}=dumage;n=n+1;end
    clear dumage
    %segmented_images{k} = color;
    %figure;imshow(segmented_images{k})
end

tl1=regionprops(tlcat{1},'ConvexArea');
tl2=regionprops(tlcat{2},'ConvexArea');
if tl1.ConvexArea>tl2.ConvexArea
    green=tlcat{1};magenta=tlcat{2};
else
    green=tlcat{2};magenta=tlcat{1};
end
figure;imshow(green | magenta)

tr1=regionprops(trcat{1},'ConvexArea');
tr2=regionprops(trcat{2},'ConvexArea');
if tr1.ConvexArea>tr2.ConvexArea
    red=trcat{1};cyan=trcat{2};
else
    red=trcat{2};cyan=trcat{1};
end
figure;imshow(red | cyan)

bl1=regionprops(blcat{1},'ConvexArea');
bl2=regionprops(blcat{2},'ConvexArea');
if bl1.ConvexArea>bl2.ConvexArea
    blue=blcat{1};yellow=blcat{2};
else
    blue=blcat{2};yellow=blcat{1};
end
figure;imshow(blue | yellow)
dumm=red | cyan | green | magenta | blue | yellow;
image1=double(image1);
image1=image1.*dumm;
image1=uint8(image1);
figure;imshow((image1))
end
% for j=1:nColors
%     newcluster_center(j,:)=lab2rgb(cluster_center(j,:));
% end
%newcluster_center=newcluster_center>0.5;

% newimage=uint8(newimage);
% xxx=~im2bw(newimage,graythresh(newimage));
% figure;imshow(xxx)
% figure;imshow(minimum_image(yyy~=0))
%%
% clear
% close all
% image1=imread('aznew.png');
% image=image1;
% minimum_image=min(image,[],3);
% %minimum_image=double(minimum_image);
% figure;imshow(minimum_image)
% %xxx=im2bw(minimum_image,graythresh(minimum_image));
% xxx=imbinarize(minimum_image);
% %xxx=medfilt2(xxx);
% figure;imshow(xxx)
% %zzz=imfill(xxx,'holes');
% %figure;imshow(zzz)
% CC=bwconncomp(xxx);
% numPixels=(cellfun(@numel,CC.PixelIdxList));
% yyy=zeros(size(xxx));
% for i=1:3%numel(numPixels)
%     [biggest,idx] = max(numPixels);
%     if i==1,numPixels(idx)=0;continue;end
%     yyy(CC.PixelIdxList{idx}) = 255;
%     %yyy=minimum_image(CC.PixelIdxList{idx});
%     %CC.PixelIdxList{idx}=[];
%     numPixels(idx)=0;
%     %numPixels=(cellfun(@numel,CC.PixelIdxList));
%     %figure;imshow(yyy)
% end
% yyy=logical(yyy);
% yyy=~yyy;
% figure;imshow(yyy)
% zzz=bwconncomp(yyy);
% numPixels=(cellfun(@numel,zzz.PixelIdxList));
% [biggest,idx] = max(numPixels);
% yyy(zzz.PixelIdxList{idx}) = 0;
% figure;imshow(yyy)
% newimage=double(minimum_image);
% newimage(~yyy)=255;
% figure;imshow(uint8(newimage))
% image=double(image);
% image=image.*yyy;
% image=uint8(image);
% %image(image==0)=255;
% figure;imshow((image))
% ab=im2double(image);
% nrows = size(ab,1);
% ncols = size(ab,2);
% ab = reshape(ab,nrows*ncols,3);
% 
% nColors = 7;
% % repeat the clustering 3 times to avoid local minima
% [cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
%                                       'Replicates',10);
% pixel_labels = reshape(cluster_idx,nrows,ncols);
% figure;imshow(pixel_labels,[])
% leftc=[1 nrows/2];rightc=[ncols nrows/2];topc=[ncols/2 1];bottomc=[ncols/2 nrows];
% centrec=[nrows/2 ncols/2];
% l=1;m=1;n=1;
% for k = 1:nColors
%     if sum(cluster_center(k,:))<0.1,cluster_center(k,:)=[-1 0 0];
%         xaxisrows(k)=NaN;yaxiscols(k)=NaN;finaldumage{k}=NaN;distm(k)=NaN;continue;end
%     dumage=zeros(nrows,ncols);
%     %color = image;
%     %color(rgb_label ~= k) = 255;
%     dumage(pixel_labels==k)=255;
%     rmcomp=bwconncomp(dumage);nPixels=(cellfun(@numel,rmcomp.PixelIdxList));
%     for jj=1:numel(nPixels)
%         [biggest,idx] = max(nPixels);
%         if jj==1,nPixels(idx)=0;continue;end
%         dumage(rmcomp.PixelIdxList{idx}) = 0;
%         nPixels(idx)=0;
%     end
%     dumage=logical(dumage);%dumage=medfilt2(dumage);
%     %dumage=bwareaopen(dumage,100);
%     figure;imshow(dumage);
%     SS=regionprops(dumage,'Centroid');%disp(cluster_center(k,:))
%     xaxisrows(k)=SS.Centroid(2);yaxiscols(k)=SS.Centroid(1);
%     finaldumage{k}=dumage;%ncluster_center(l,:)=cluster_center(k,:);
%     distm(k)=norm(SS.Centroid-centrec);l=l+1;
% %     if distm==1, tccat{l}=dumage;l=l+1;end
% %     if distm==2, bccat{m}=dumage;m=m+1;end
% %     if distm==3, lccat{n}=dumage;n=n+1;end
% %     if distm==4, rccat{o}=dumage;o=o+1;end
% %     if distm==5, cccat{p}=dumage;p=p+1;end
%     clear dumage
%     %segmented_images{k} = color;
%     %figure;imshow(segmented_images{k})
% end
% ncluster_center=cluster_center;
% [~,nidx]=min(distm);
% cyan=finaldumage{nidx};ncluster_center(nidx,:)=[-1 0 0];
% xaxisrows(nidx)=NaN;yaxiscols(nidx)=NaN;
% 
% [~,nidx]=max(xaxisrows);magenta=finaldumage{nidx};
% ncluster_center(nidx,:)=[-1 0 0];xaxisrows(nidx)=NaN;yaxiscols(nidx)=NaN;
% [~,nidx]=min(xaxisrows);red=finaldumage{nidx};
% ncluster_center(nidx,:)=[-1 0 0];xaxisrows(nidx)=NaN;yaxiscols(nidx)=NaN;
% 
% for kk=1:size(ncluster_center,1)
%     if sum(ncluster_center(kk,:)==-1),narea(kk)=NaN;continue;end
%     dumnarea=regionprops(finaldumage{kk},'Area');
%     narea(kk)=dumnarea.Area;
% end
% 
% %narea(narea==0)=NaN;
% [~,nidx]=min(narea);
% 
% yellow=finaldumage{nidx};ncluster_center(nidx,:)=[-1 0 0];xaxisrows(nidx)=NaN;yaxiscols(nidx)=NaN;
% 
% [~,nidx]=max(yaxiscols);blue=finaldumage{nidx};
% ncluster_center(nidx,:)=[-1 0 0];xaxisrows(nidx)=NaN;yaxiscols(nidx)=NaN;
% [~,nidx]=min(yaxiscols);green=finaldumage{nidx};
% ncluster_center(nidx,:)=[-1 0 0];xaxisrows(nidx)=NaN;yaxiscols(nidx)=NaN;
% 
% 
% dumm=red | cyan | green | magenta | blue | yellow;
% image1=double(image1);
% image1=image1.*dumm;
% image1=uint8(image1);
% figure;imshow((image1))