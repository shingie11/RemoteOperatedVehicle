clear
cname='qr';%If code is QR
%cname='az';%If code is Aztec
colors={'red';'green';'blue'}';
pth='Outputfromdispcam/';
sublist=folderSubFolders(pth,Inf);
j=1;
for i=1:numel(sublist)
    temp=strsplit(sublist{i},'\');%For Linux change it to '/'
    if (strcmp(temp{end},'30') || strcmp(temp{end},'40') || strcmp(temp{end},'50'))
        if sum(contains(temp,'Coherent'))==1
            newflist{j}=sublist{i};
            j=j+1;
        end
    end
end
newflist=newflist';
for j=1:numel(newflist)
    currDir=newflist{j};
    pth2dec=[currDir,'\','dectxt'];
    mkdir(pth2dec)
    pth2decimgs=[currDir,'\','decimg'];
    mkdir(pth2decimgs)
    tempnew=strsplit(currDir,'\');%Linux change
    list=dir([currDir,'\','*.png']);
    N=natsortfiles({list.name})';
    %N=N(3:end)';
    statmatrix=zeros(size(N,1),18);
    encfpth=[strjoin(tempnew(1:end-1),'\'),'\'];
    encfiles=(dir([encfpth,'*.txt']));
    encfiles=natsortfiles({encfiles.name})';
    for k=1:size(N,1)
        imgname=[currDir,'\',N{k}];%Linux change
        [~,name,~]=fileparts(imgname);
        Q=pilotblock_otsuthresholding(imgname,cname);
        
        strall=['zxing.exe --try-harder ','1.png'];
        [~,result]=system(strall,'-echo');
        if contains(result,'decoding failed')
            statmatrix(k,3)=NaN;
        else
            statmatrix(k,3)=1;
        end
        if exist('Decoderlogdata.txt','file')
            %movefile('Decoderlogdata.txt',str);
            %movefile('Decoderlogdata.txt',[currDir,'\']);
            strenc=[encfpth,encfiles{3}];
            strdec='Decoderlogdata.txt';
            %biterrorrate=getBER(strenc,strdec);
            biterrorrate=0.9;%Temporary
            statmatrix(k,1)=biterrorrate;
            statmatrix(k,2)=1;
            decnfname=[name,colors{1},'.txt'];
            movefile('Decoderlogdata.txt',decnfname);
            movefile(decnfname,[pth2dec,'\']);
        else
            statmatrix(k,1)=NaN;
            statmatrix(k,2)=NaN;
        end
        
        strall=['zxing.exe --try-harder ','2.png'];
        [~,result]=system(strall,'-echo');
        if contains(result,'decoding failed')
            statmatrix(k,6)=NaN;
        else
            statmatrix(k,6)=1;
        end
        if exist('Decoderlogdata.txt','file')
            %movefile('Decoderlogdata.txt',str);
            %movefile(str,[pth,decf,'/']);
            strenc=[encfpth,encfiles{1}];
            strdec='Decoderlogdata.txt';
            %biterrorrate=getBER(strenc,strdec);
            biterrorrate=0.9;%Temporary
            statmatrix(k,4)=biterrorrate;
            statmatrix(k,5)=1;
            decnfname=[name,colors{2},'.txt'];
            movefile('Decoderlogdata.txt',decnfname);
            movefile(decnfname,[pth2dec,'\']);
        else
            statmatrix(k,4)=NaN;
            statmatrix(k,5)=NaN;
        end
 
        strall=['zxing.exe --try-harder ','3.png'];
        [~,result]=system(strall,'-echo');
        if contains(result,'decoding failed')
            statmatrix(k,9)=NaN;
        else
            statmatrix(k,9)=1;
        end
        if exist('Decoderlogdata.txt','file')
            %movefile('Decoderlogdata.txt',str);
            %movefile(str,[pth,decf,'/']);
            strenc=[encfpth,encfiles{2}];
            strdec='Decoderlogdata.txt';
            %biterrorrate=getBER(strenc,strdec);
            biterrorrate=0.9;%Temporary
            statmatrix(k,7)=biterrorrate;
            statmatrix(k,8)=1;
            decnfname=[name,colors{3},'.txt'];
            movefile('Decoderlogdata.txt',decnfname);
            movefile(decnfname,[pth2dec,'\']);
        else
            statmatrix(k,7)=NaN;
            statmatrix(k,8)=NaN;
        end
        statmatrix(k,10:18)=Q(:)';
        
        decnimgname=[name,'1',colors{1},'.png'];
        movefile('1.png',decnimgname);
        movefile(decnimgname,[pth2decimgs,'\']);
        
        decnimgname=[name,'2',colors{2},'.png'];
        movefile('2.png',decnimgname);
        movefile(decnimgname,[pth2decimgs,'\']);
        
        decnimgname=[name,'3',colors{3},'.png'];
        movefile('3.png',decnimgname);
        movefile(decnimgname,[pth2decimgs,'\']);
        
        decnimgname=[name,'4',colors{1},'.png'];
        movefile('4.png',decnimgname);
        movefile(decnimgname,[pth2decimgs,'\']);
        
        decnimgname=[name,'5',colors{2},'.png'];
        movefile('5.png',decnimgname);
        movefile(decnimgname,[pth2decimgs,'\']);
        
        decnimgname=[name,'6',colors{3},'.png'];
        movefile('6.png',decnimgname);
        movefile(decnimgname,[pth2decimgs,'\']);
        
        decnimgname=[name,'7',colors{1},'.png'];
        movefile('7.png',decnimgname);
        movefile(decnimgname,[pth2decimgs,'\']);
        
        decnimgname=[name,'8',colors{2},'.png'];
        movefile('8.png',decnimgname);
        movefile(decnimgname,[pth2decimgs,'\']);
        
        decnimgname=[name,'9',colors{3},'.png'];
        movefile('9.png',decnimgname);
        movefile(decnimgname,[pth2decimgs,'\']);
    end
end
