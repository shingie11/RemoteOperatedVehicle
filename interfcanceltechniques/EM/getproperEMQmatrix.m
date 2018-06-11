function Q=getproperEMQmatrix(image)
% image1=zeros(size(image));
% for k=1:3
% thresh(k)=otsuthreshold(image(:,:,k));
% for i=1:size(image,1)
% for j=1:size(image,2)
% if image(i,j,k)>thresh(k)*255
% image1(i,j,k)=255;
% else image1(i,j,k)=0;
% end
% end
% end
% end
% imshow(image1)
% pos=zeros(4,6);
% [pos(:,1),pos(:,2),pos(:,3),pos(:,4),pos(:,5),pos(:,6)]=gettheposition_sixcombinations();
% pos=round(pos);
% Image_captured=zeros(3,6);
% %Image_display=zeros(3,6);
% for i=1:1:6
%     %R_matrix=zeros(pos(3,i)+1,pos(4,i)+1);
%     %G_matrix=zeros(pos(3,i)+1,pos(4,i)+1);
%     %B_matrix=zeros(pos(3,i)+1,pos(4,i)+1);
%     R_matrix=image1(pos(2,i):pos(2,i)+pos(4,i),pos(1,i):pos(1,i)+pos(3,i),1);
%     G_matrix=image1(pos(2,i):pos(2,i)+pos(4,i),pos(1,i):pos(1,i)+pos(3,i),2);
%     B_matrix=image1(pos(2,i):pos(2,i)+pos(4,i),pos(1,i):pos(1,i)+pos(3,i),3);
%     %Image_captured(1,i)=sum(R_matrix(:))/((pos(3,i)+1)*(pos(4,i)+1));
%     %Image_captured(2,i)=sum(G_matrix(:))/((pos(3,i)+1)*(pos(4,i)+1));
%     %Image_captured(3,i)=sum(B_matrix(:))/((pos(3,i)+1)*(pos(4,i)+1));
%     Image_captured(1,i)=mean(mean(R_matrix));
%     Image_captured(2,i)=mean(mean(G_matrix));
%     Image_captured(3,i)=mean(mean(B_matrix));
% end
% %Read in C,M,Y,CM,CY,MY pattern
% Image_display=[0 1 1;1 0 1;1 1 0;0 0 1;0 1 0;1 0 0];
% Q=zeros(3,3);
% Q=Image_display\transpose(Image_captured);
% Q=Q.';


image1=zeros(size(image));
image1(:,:,1)=imbinarize(image(:,:,1));
image1(:,:,2)=imbinarize(image(:,:,2));
image1(:,:,3)=imbinarize(image(:,:,3));
image1=image1.*255;
% for k=1:3
% thresh(k)=otsuthreshold(image(:,:,k));
% for i=1:size(image,1)
% for j=1:size(image,2)
% if image(i,j,k)>thresh(k)*255
% image1(i,j,k)=255;
% else image1(i,j,k)=0;
% end
% end
% end
% end
% 
% 

% imshow(image1)
% pos=zeros(4,6);
% [pos(:,1),pos(:,2),pos(:,3),pos(:,4),pos(:,5),pos(:,6)]=gettheposition_sixcombinations();
% pos=round(pos);
% Image_displayed=zeros(3,6);
% Image_captured=zeros(3,6);
% %Image_display=zeros(3,6);
% for i=1:1:6
%     %R_matrix=zeros(pos(3,i)+1,pos(4,i)+1);
%     %G_matrix=zeros(pos(3,i)+1,pos(4,i)+1);
%     %B_matrix=zeros(pos(3,i)+1,pos(4,i)+1);
%     R_matrix=image1(pos(2,i):pos(2,i)+pos(4,i),pos(1,i):pos(1,i)+pos(3,i),1);
%     G_matrix=image1(pos(2,i):pos(2,i)+pos(4,i),pos(1,i):pos(1,i)+pos(3,i),2);
%     B_matrix=image1(pos(2,i):pos(2,i)+pos(4,i),pos(1,i):pos(1,i)+pos(3,i),3);
%     %Image_captured(1,i)=sum(R_matrix(:))/((pos(3,i)+1)*(pos(4,i)+1));
%     %Image_captured(2,i)=sum(G_matrix(:))/((pos(3,i)+1)*(pos(4,i)+1));
%     %Image_captured(3,i)=sum(B_matrix(:))/((pos(3,i)+1)*(pos(4,i)+1));
%     Image_displayed(1,i)=mean(mean(R_matrix));
%     Image_displayed(2,i)=mean(mean(G_matrix));
%     Image_displayed(3,i)=mean(mean(B_matrix));
%     
%     R_matrixd=image(pos(2,i):pos(2,i)+pos(4,i),pos(1,i):pos(1,i)+pos(3,i),1);
%     G_matrixd=image(pos(2,i):pos(2,i)+pos(4,i),pos(1,i):pos(1,i)+pos(3,i),2);
%     B_matrixd=image(pos(2,i):pos(2,i)+pos(4,i),pos(1,i):pos(1,i)+pos(3,i),3);
%     
%     Image_captured(1,i)=mean(mean(R_matrixd));
%     Image_captured(2,i)=mean(mean(G_matrixd));
%     Image_captured(3,i)=mean(mean(B_matrixd));
% end
% %Read in C,M,Y,CM,CY,MY pattern
% %Image_display=[0 1 1;1 0 1;1 1 0;0 0 1;0 1 0;1 0 0];



[uniquergb, ~, uidx] = unique( reshape(image1, [], 3),'rows' );
rgbidx = reshape(uidx, size(image1,1), []);
rmatrix=image(:,:,1);gmatrix=image(:,:,2);bmatrix=image(:,:,3);
for i=2:7
    [x,y]=find(rgbidx==i);
    aa=[x y];
    BW=zeros(size(rgbidx));
    BW(sub2ind(size(BW),aa(:,1),aa(:,2)))=255;
    BW=imbinarize(BW);
    BW=imerode(BW,strel('disk',1));
    CC = bwconncomp(BW);
    numPixels = cellfun(@numel,CC.PixelIdxList);
    [biggest,idx] = max(numPixels);
    [newx,newy]=ind2sub(size(BW),CC.PixelIdxList{idx});
    sz=3;
    %yy=zeros(size(BW));
    %yy(median(newx)-sz:median(newx)+sz,median(newy)-sz:median(newy)+sz)=255;
%     aaaa=rmatrix(median(newx)-sz:median(newx)+sz,median(newy)-sz:median(newy)+sz);
%     bbbb=gmatrix(median(newx)-sz:median(newx)+sz,median(newy)-sz:median(newy)+sz);
%     cccc=bmatrix(median(newx)-sz:median(newx)+sz,median(newy)-sz:median(newy)+sz);
    newaa=[newx newy];
    %yy=zeros(size(BW));
    %yy(sub2ind(size(yy),newaa(:,1),newaa(:,2)))=255;
    %yy=imbinarize(yy);stat=regionprops(yy,'Centroid');
    aaaa=rmatrix(sub2ind(size(rmatrix),newaa(:,1),newaa(:,2)));
    bbbb=gmatrix(sub2ind(size(gmatrix),newaa(:,1),newaa(:,2)));
    cccc=bmatrix(sub2ind(size(bmatrix),newaa(:,1),newaa(:,2)));
    
    Image_captured(i-1,1)=mean(mean(aaaa));
    Image_captured(i-1,2)=mean(mean(bbbb));
    Image_captured(i-1,3)=mean(mean(cccc)); 
end
Image_displayed=[uniquergb(2,:);uniquergb(3,:);uniquergb(4,:);uniquergb(5,:);uniquergb(6,:);uniquergb(7,:)];
Image_captured=double(Image_captured);


 Q=zeros(3,3);
 Q=(Image_displayed/255)\(Image_captured);
 %Q=transpose(Image_displayed/255)\transpose(Image_captured);
 Q=Q.';
end