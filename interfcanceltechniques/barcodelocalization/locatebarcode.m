clear
addpath('Localize')
Imain = imread('locatebcodeimage/a.jpg');
Imain=imresize(Imain,0.5); %Comment this line an try if localization is not successful in first attempt
I = min(Imain,[],3);
I =imresize(I,0.5);%Comment this line an try if localization is not successful in first attempt
%I=I-min(min(I));
cname='az';
[fipls,flens,img] = GetPattern_message_Fn(I,cname);
if strcmp(cname,'qr')
flens=round(flens);
lrow=min(fipls(:,1))-7*round(mean(flens));mrow=max(fipls(:,1))+7*round(mean(flens));
lcol=min(fipls(:,2))-7*round(mean(flens));mcol=max(fipls(:,2))+7*round(mean(flens));
hei=mrow-lrow;wid=mcol-lcol;
%figure;imshow(I);hold on
%rectangle('Position',[mrow mcol hei wid])
finalimg=Imain(lrow:lrow+hei,lcol:lcol+wid,:);
figure;imshow(finalimg)
end
if strcmp(cname,'az')
flens=round(flens);
imgcenter=[round(size(I,1)/2) round(size(I,2)/2)];
[~,index] =min(pdist2(imgcenter,fipls,'euclidean'));
bcentre=fipls(index,:);
thickness=flens(index);
imgsize=round(15*thickness);
lcol=bcentre(2)-imgsize;mcol=bcentre(2)+imgsize;
lrow=bcentre(1)-imgsize;mrow=bcentre(1)+imgsize;
finalimg=Imain(lrow:lrow+2*imgsize,lcol:lcol+2*imgsize,:);
figure;imshow(finalimg)
end
rmpath('Localize')