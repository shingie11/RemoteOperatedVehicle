To install the decoder do the following steps:

1) cd Channelwise-Barcode/MobileColorBarcodes/ExternalLibrariesNApplications/ZXingBarcodeDecoder/src/zxing-cpp-master/

2) mkdir build 

3) cd build

4) cmake -G "Unix Makefiles" ..

5) make

This will result in a binary file zxing.exe appear in the build directory. TO check if the binary is working, copy the file "test.png"
to the build directory and run the command

./zxing.exe test.png 
        or
./zxing test.png		

This should result in "www.rochester.edu" message appear on the terminal and a file called "Decoderlogdata.txt" appear in the build directory.