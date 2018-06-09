%image=imread('25mmL.png');
function Q=pilotblock_otsuthresholding(imgname,cname)
pilot_image=imread(imgname);
figure;imshow(pilot_image)
%minimage=min(pilot_image,[],3);
%[red,green,blue]=getRGBchannel(image);
[Q,nyyy,red,green,blue,cyan,magenta,yellow]=getQmatrixPB(pilot_image,cname);
%Q=getQmatrixPB(pilot_image);
close all;
imagecancel_beforebin=zeros(size(pilot_image,1),size(pilot_image,2),3);
for i=1:size(pilot_image,1)
for j=1:size(pilot_image,2)
imagecancel_beforebin(i,j,:) = 255*inv(Q)*double(reshape(pilot_image(i,j,:),3,1));
end
end


%figure;imshow(uint8(imagecancel_beforebin))
imagecancel_afterbin=zeros(size(imagecancel_beforebin));

imagecancel_afterbin(:,:,1)=imbinarize(uint8(imagecancel_beforebin(:,:,1)));
imagecancel_afterbin(:,:,2)=imbinarize(uint8(imagecancel_beforebin(:,:,2)));
imagecancel_afterbin(:,:,3)=imbinarize(uint8(imagecancel_beforebin(:,:,3)));

% for k=1:3
% threshold=binarization(pilot_image(:,:,k),k,red,green,blue,cyan,magenta,yellow);
% for i=1:size(imagecancel_beforebin,1)
% for j=1:size(imagecancel_beforebin,2)
% if imagecancel_beforebin(i,j,k)>threshold
% imagecancel_afterbin(i,j,k)=255;
% else imagecancel_afterbin(i,j,k)=0;
% end
% end
% end
% end

[xx,yy]=find(nyyy~=0);
dummy1=imagecancel_afterbin(:,:,1);dummy2=imagecancel_afterbin(:,:,2);dummy3=imagecancel_afterbin(:,:,3);
%figure;imshow(uint8(imagecancel_beforebin))
for i=1:size(xx,1)
dummy1(xx(i),yy(i))=0;
dummy2(xx(i),yy(i))=0;
dummy3(xx(i),yy(i))=0;
end
imagecancel_afterbin=cat(3,dummy1,dummy2,dummy3);

close all;
%chl=1; figure(1); imshow(uint8(imagecancel_beforebin(:,:,chl))); figure(2); imshow(image(:,:,chl));figure(3); imshow(uint8(imagecancel_afterbin(:,:,chl)));
%chl=2; figure(4); imshow(uint8(imagecancel_beforebin(:,:,chl))); figure(5); imshow(image(:,:,chl));figure(6); imshow(uint8(imagecancel_afterbin(:,:,chl)));
%chl=3; figure(7); imshow(uint8(imagecancel_beforebin(:,:,chl))); figure(8); imshow(image(:,:,chl));figure(9); imshow(uint8(imagecancel_afterbin(:,:,chl)));
AA=uint8(imagecancel_beforebin(:,:,1));
imwrite(AA,'4.png');
BB=uint8(imagecancel_beforebin(:,:,2));
imwrite(BB,'5.png');
CC=uint8(imagecancel_beforebin(:,:,3));
imwrite(CC,'6.png');

DD=pilot_image(:,:,1);
imwrite(DD,'7.png');
EE=pilot_image(:,:,2);
imwrite(EE,'8.png');
FF=pilot_image(:,:,3);
imwrite(FF,'9.png');
GG=(imagecancel_afterbin(:,:,1));
imwrite(GG,'1.png');
HH=(imagecancel_afterbin(:,:,2));
imwrite(HH,'2.png');
II=(imagecancel_afterbin(:,:,3));
imwrite(II,'3.png');
end
