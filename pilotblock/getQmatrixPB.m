function [Q,nyyy,red,green,blue,cyan,magenta,yellow]=getQmatrixPB(image)
%function [Q]=getQmatrixPB(image)
% %image=imread('testpilot1.png');
% imshow(image)
% pos=zeros(4,6);
% [pos(:,1),pos(:,2),pos(:,3),pos(:,4),pos(:,5),pos(:,6)]=gettheposition_sixcombinations();
% pos=round(pos);
% Image_captured=zeros(3,6);
% %Image_display=zeros(3,6);
% for i=1:1:6
%     %R_matrix=zeros(pos(3,i)+1,pos(4,i)+1);
%     %G_matrix=zeros(pos(3,i)+1,pos(4,i)+1);
%     %B_matrix=zeros(pos(3,i)+1,pos(4,i)+1);
%     R_matrix=image(pos(2,i):pos(2,i)+pos(4,i),pos(1,i):pos(1,i)+pos(3,i),1);
%     G_matrix=image(pos(2,i):pos(2,i)+pos(4,i),pos(1,i):pos(1,i)+pos(3,i),2);
%     B_matrix=image(pos(2,i):pos(2,i)+pos(4,i),pos(1,i):pos(1,i)+pos(3,i),3);
%     Image_captured(1,i)=sum(R_matrix(:))/((pos(3,i)+1)*(pos(4,i)+1));
%     Image_captured(2,i)=sum(G_matrix(:))/((pos(3,i)+1)*(pos(4,i)+1));
%     Image_captured(3,i)=sum(B_matrix(:))/((pos(3,i)+1)*(pos(4,i)+1));
% end
% %Read in C,M,Y,CM,CY,MY pattern
% Image_display=[0 1 1;1 0 1;1 1 0;0 0 1;0 1 0;1 0 0];
% %Q=zeros(3,3);
% Q=Image_display\transpose(Image_captured);
% Q=Q.';
%%
%image=imread('testpilot1.png');
[red,green,blue,cyan,magenta,yellow,nyyy]=dummyQR(image);
%Image_captured=zeros(3,6);
redimage=image(:,:,1);greenimage=image(:,:,2);blueimage=image(:,:,3);
c=[mean(redimage(cyan));mean(greenimage(cyan));mean(blueimage(cyan))];
m=[mean(redimage(magenta));mean(greenimage(magenta));mean(blueimage(magenta))];
y=[mean(redimage(yellow));mean(greenimage(yellow));mean(blueimage(yellow))];
b=[mean(redimage(blue));mean(greenimage(blue));mean(blueimage(blue))];
g=[mean(redimage(green));mean(greenimage(green));mean(blueimage(green))];
r=[mean(redimage(red));mean(greenimage(red));mean(blueimage(red))];

Image_captured=[c m y b g r];
%Image_display=zeros(3,6);
%Read in C,M,Y,CM,CY,MY pattern
Image_display=[0 1 1;1 0 1;1 1 0;0 0 1;0 1 0;1 0 0];
%Q=zeros(3,3);
Q=Image_display\transpose(Image_captured);
Q=Q.';
end