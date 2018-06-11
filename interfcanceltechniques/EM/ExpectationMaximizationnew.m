function Q_actual=ExpectationMaximizationnew(imgname)
image=imread(imgname);
%imshow(image1)
%h=imrect;pos=round(getPosition(h));
%image=imcrop(image1,pos);
%pilot_image=imread('pilot.png');   %added
[Q,iteration]=getQmatrixEMnew(image);
Q_actual=zeros(3,3);
for i=1:3
[num,idx]=max(Q(:,i));
if (idx~=i)
    Q_actual(:,idx)=Q(:,i);
else Q_actual(:,i)=Q(:,i);
end
end
%%
imagecancel_beforebin=zeros(size(image,1),size(image,2),3);
for i=1:size(image,1)
for j=1:size(image,2)
imagecancel_beforebin(i,j,:) = 255*inv(Q_actual)*double(reshape(image(i,j,:),3,1));
end
end
close all;

%  imagecancel_afterbin=imagecancel_beforebin;
% 
% for k=1:3
% threshold=binarization(pilot_image(:,:,k));
% for i=1:size(imagecancel_beforebin,1)
% for j=1:size(imagecancel_beforebin,2)
% if imagecancel_afterbin(i,j,k)>threshold
% imagecancel_afterbin(i,j,k)=255;
% else imagecancel_afterbin(i,j,k)=0;
% end
% end
% end
% end

% imagecancel_afterbin=imagecancel_beforebin;%zeros(size(imagecancel_beforebin,1),size(imagecancel_beforebin,2),3);
% for k=1:3
% imagecancel_afterbin(:,:,k)=localthreshold(imagecancel_beforebin(:,:,k));
% end


imagecancel_afterbin=zeros(size(imagecancel_beforebin));
imagecancel_afterbin(:,:,1)=imbinarize(uint8(imagecancel_beforebin(:,:,1)));
imagecancel_afterbin(:,:,2)=imbinarize(uint8(imagecancel_beforebin(:,:,2)));
imagecancel_afterbin(:,:,3)=imbinarize(uint8(imagecancel_beforebin(:,:,3)));
% for k=1:3
% thresh(k)=otsuthreshold(imagecancel_beforebin(:,:,k));
% for i=1:size(imagecancel_beforebin,1)
% for j=1:size(imagecancel_beforebin,2)
% if imagecancel_beforebin(i,j,k)>thresh(k)*255
% imagecancel_afterbin(i,j,k)=255;
% %else imagecancel_afterbin(i,j,k)=0;
% end
% end
% end
% end



% chl=1; figure(1); imshow(uint8(imagecancel_beforebin(:,:,chl))); figure(2); imshow(image(:,:,chl));figure(3); imshow(imagecancel_afterbin(:,:,chl));
% chl=2; figure(4); imshow(uint8(imagecancel_beforebin(:,:,chl))); figure(5); imshow(image(:,:,chl));figure(6); imshow(imagecancel_afterbin(:,:,chl));
% chl=3; figure(7); imshow(uint8(imagecancel_beforebin(:,:,chl))); figure(8); imshow(image(:,:,chl));figure(9); imshow(imagecancel_afterbin(:,:,chl));

AA=uint8(imagecancel_beforebin(:,:,1));
imwrite(AA,'4.png');
BB=uint8(imagecancel_beforebin(:,:,2));
imwrite(BB,'5.png');
CC=uint8(imagecancel_beforebin(:,:,3));
imwrite(CC,'6.png');

DD=image(:,:,1);
imwrite(DD,'7.png');
EE=image(:,:,2);
imwrite(EE,'8.png');
FF=image(:,:,3);
imwrite(FF,'9.png');

GG=(imagecancel_afterbin(:,:,1));
imwrite(GG,'1.png');
HH=(imagecancel_afterbin(:,:,2));
imwrite(HH,'2.png');
II=(imagecancel_afterbin(:,:,3));
imwrite(II,'3.png');
end

