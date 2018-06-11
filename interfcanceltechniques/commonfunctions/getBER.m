function ber=getBER(enc,dec)
fileID = fopen(enc,'r');
formatSpec = '%c';
A = fscanf(fileID,formatSpec);
Encode_data=strread(A,'%c');
fclose(fileID);
fileID = fopen(dec,'r');
formatSpec = '%c';
B = fscanf(fileID,formatSpec);
Decode_data=strread(B,'%c');
fclose(fileID);
count=0;
length_ED=length(Encode_data);
length_DD=length(Decode_data);
if length_ED~=length_DD
    fprintf(stderr,'%s','Something is wrong');
end
for i=1:length_ED
    if Encode_data(i)~=Decode_data(i)
        count=count+1;
    end
end
ber=count/length_ED;
end