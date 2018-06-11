%Get the 'k' captured pixels and form a 3xk matrix
function [Q,iteration]=getQmatrixEMnew(image)
%image=imread('pilot.png');
convergence=10^-6;
%Ic=getthepixel(image);
wsize=30;i=1;
while i<19
    rstrt=(randi([round(0.15*size(image,1)) round(0.85*size(image,1))],1,1));
    rstp=(randi([round(0.15*size(image,2)) round(0.85*size(image,2))],1,1));
    if (rstrt+wsize<size(image,1) && rstp+wsize<size(image,2))
    Ic(1,i)=mean2(image(rstrt:rstrt+wsize,rstp:rstp+wsize,1));
    Ic(2,i)=mean2(image(rstrt:rstrt+wsize,rstp:rstp+wsize,2));
    Ic(3,i)=mean2(image(rstrt:rstrt+wsize,rstp:rstp+wsize,3));
    i=i+1;
    else
    continue;
    end
end
%%
row1=size(Ic,1);column1=size(Ic,2);
totalsize1=row1*column1;
%%
%Initializations
%Q=[1 0 0;0 1 0;0 0 1];
Q=getproperEMQmatrix(image);
row2=size(Q,1);column2=size(Q,2);
totalsize2=row2*column2;
A=eye(column1);
B=eye(3);
%x0=zeros(3,1);                            %Initial points
%y0=zeros(9,1);
lb1=zeros(totalsize1,1);ub1=ones(totalsize1,1);             %lower bounds and upper bounds
lb2=zeros(totalsize2,1);ub2=255*ones(totalsize2,1);
%ub2=[Inf;Inf;Inf;Inf;Inf;Inf;Inf;Inf;Inf];
%%
iteration=0;
%xxx=0;
while(1)
%Step 1    
iteration=iteration+1;
D=kron(A,Q);
d=reshape(Ic,totalsize1,1);
x=lsqlin(D,d,[],[],[],[],lb1,ub1);
I=x;
Id=reshape(I,row1,column1);
%Step 2
Id_1=Id.';
Ic_1=Ic.';
I_1=kron(B,Id_1);
d_1=reshape(Ic_1,totalsize1,1);
y=lsqlin(I_1,d_1,[],[],[],[],lb2,ub2);
Q_1=reshape(y,row2,column2);
Q=Q_1.';
if (norm(Q*Id-Ic))^2 < convergence
    break;
end
%xxx=xxx+1;
disp(sprintf('%d\n',iteration));
disp(sprintf('%f\n',(norm(Q*Id-Ic))^2));
end
end