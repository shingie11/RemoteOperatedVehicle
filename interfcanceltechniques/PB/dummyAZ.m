function [red,green,blue,cyan,magenta,yellow,yyy]=dummyAZ(image1)
%image1=imread('aznew.png');
image=image1;
minimum_image=min(image,[],3);
%minimum_image=double(minimum_image);
figure;imshow(minimum_image)
%xxx=im2bw(minimum_image,graythresh(minimum_image));
xxx=imbinarize(minimum_image);
xxx=medfilt2(xxx);
figure;imshow(xxx)
%zzz=imfill(xxx,'holes');
%figure;imshow(zzz)
CC=bwconncomp(xxx);
numPixels=(cellfun(@numel,CC.PixelIdxList));
yyy=zeros(size(xxx));
for i=1:3%numel(numPixels)
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
yyy=~yyy;
figure;imshow(yyy)
zzz=bwconncomp(yyy);
numPixels=(cellfun(@numel,zzz.PixelIdxList));
[biggest,idx] = max(numPixels);
yyy(zzz.PixelIdxList{idx}) = 0;
figure;imshow(yyy)
newimage=double(minimum_image);
newimage(~yyy)=255;
figure;imshow(uint8(newimage))
image=double(image);
image=image.*yyy;
image=uint8(image);
%image(image==0)=255;
figure;imshow((image))
ab=im2double(image);
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,3);

nColors = 7;
% repeat the clustering 3 times to avoid local minima
[cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
                                      'Replicates',10);
pixel_labels = reshape(cluster_idx,nrows,ncols);
figure;imshow(pixel_labels,[])
leftc=[1 nrows/2];rightc=[ncols nrows/2];topc=[ncols/2 1];bottomc=[ncols/2 nrows];
centrec=[nrows/2 ncols/2];
l=1;m=1;n=1;
for k = 1:nColors
    if sum(cluster_center(k,:))<0.1,cluster_center(k,:)=[-1 0 0];
        xaxisrows(k)=NaN;yaxiscols(k)=NaN;finaldumage{k}=NaN;distm(k)=NaN;continue;end
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
    xaxisrows(k)=SS.Centroid(2);yaxiscols(k)=SS.Centroid(1);
    finaldumage{k}=dumage;%ncluster_center(l,:)=cluster_center(k,:);
    distm(k)=norm(SS.Centroid-centrec);l=l+1;
%     if distm==1, tccat{l}=dumage;l=l+1;end
%     if distm==2, bccat{m}=dumage;m=m+1;end
%     if distm==3, lccat{n}=dumage;n=n+1;end
%     if distm==4, rccat{o}=dumage;o=o+1;end
%     if distm==5, cccat{p}=dumage;p=p+1;end
    clear dumage
    %segmented_images{k} = color;
    %figure;imshow(segmented_images{k})
end
ncluster_center=cluster_center;
[~,nidx]=min(distm);
cyan=finaldumage{nidx};ncluster_center(nidx,:)=[-1 0 0];
xaxisrows(nidx)=NaN;yaxiscols(nidx)=NaN;

[~,nidx]=max(xaxisrows);magenta=finaldumage{nidx};
ncluster_center(nidx,:)=[-1 0 0];xaxisrows(nidx)=NaN;yaxiscols(nidx)=NaN;
[~,nidx]=min(xaxisrows);red=finaldumage{nidx};
ncluster_center(nidx,:)=[-1 0 0];xaxisrows(nidx)=NaN;yaxiscols(nidx)=NaN;

for kk=1:size(ncluster_center,1)
    if sum(ncluster_center(kk,:)==-1),narea(kk)=NaN;continue;end
    dumnarea=regionprops(finaldumage{kk},'Area');
    narea(kk)=dumnarea.Area;
end

%narea(narea==0)=NaN;
[~,nidx]=min(narea);

yellow=finaldumage{nidx};ncluster_center(nidx,:)=[-1 0 0];xaxisrows(nidx)=NaN;yaxiscols(nidx)=NaN;

[~,nidx]=max(yaxiscols);blue=finaldumage{nidx};
ncluster_center(nidx,:)=[-1 0 0];xaxisrows(nidx)=NaN;yaxiscols(nidx)=NaN;
[~,nidx]=min(yaxiscols);green=finaldumage{nidx};
ncluster_center(nidx,:)=[-1 0 0];xaxisrows(nidx)=NaN;yaxiscols(nidx)=NaN;


dumm=red | cyan | green | magenta | blue | yellow;
image1=double(image1);
image1=image1.*dumm;
image1=uint8(image1);
figure;imshow((image1))
end