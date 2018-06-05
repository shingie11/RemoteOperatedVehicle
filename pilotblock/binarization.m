function threshold = binarization(image,k,red,green,blue,cyan,magenta,yellow)
% imshow(image)
% h=imrect;
% k=imrect;
% l=imrect;
% x=round(getPosition(h));
% y=round(getPosition(k));
% z=round(getPosition(l));
% A(1)=mean(mean(image(x(2):x(2)+x(4),x(1):x(1)+x(3))));
% A(2)=mean(mean(image(y(2):y(2)+y(4),y(1):y(1)+y(3))));
% A(3)=mean(mean(image(z(2):z(2)+z(4),z(1):z(1)+z(3))));
% MAX_IMUM=min(A);%C,CM,CY   M,CM,MY   Y,CY,MY
% close all
% imshow(image)
% h=imrect;
% k=imrect;
% l=imrect;
% x=round(getPosition(h));
% y=round(getPosition(k));
% z=round(getPosition(l));
% B(1)=mean(mean(image(x(2):x(2)+x(4),x(1):x(1)+x(3))));
% B(2)=mean(mean(image(y(2):y(2)+y(4),y(1):y(1)+y(3))));
% B(3)=mean(mean(image(z(2):z(2)+z(4),z(1):z(1)+z(3))));
% MIN_IMUM=max(B);%M,Y,MY   C,Y,CY   C,M,CM
% threshold=(MAX_IMUM+MIN_IMUM)/2;
if k==1
    MAX_IMUM=max([mean(image(red)) mean(image(yellow)) mean(image(magenta))]);
    MIN_IMUM=min([mean(image(green)) mean(image(blue)) mean(image(cyan))]);
    threshold=(MAX_IMUM+MIN_IMUM)/2;
end
if k==2
    MAX_IMUM=max([mean(image(green)) mean(image(yellow)) mean(image(cyan))]);
    MIN_IMUM=min([mean(image(red)) mean(image(blue)) mean(image(magenta))]);
    threshold=(MAX_IMUM+MIN_IMUM)/2;
end
if k==3
    MAX_IMUM=max([mean(image(blue)) mean(image(magenta)) mean(image(cyan))]);
    MIN_IMUM=min([mean(image(red)) mean(image(green)) mean(image(yellow))]);
    threshold=(MAX_IMUM+MIN_IMUM)/2;
end