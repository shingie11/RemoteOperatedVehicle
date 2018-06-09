A) To install the decoder do the following steps:

1) cd Channelwise-Barcode/ZXingBarcodeDecoder/src/zxing-cpp-master/

2) mkdir build 

3) cd build

4) cmake -G "Unix Makefiles" ..                  (Make sure you have cmake installed in your system)

5) make

This will result in a binary file zxing.exe appear in the build directory. TO check if the binary is working, copy the file "test.png"
to the build directory and run the command

./zxing.exe test.png 
        or
./zxing test.png		

This should result in "www.rochester.edu" message appear on the terminal and a file called "Decoderlogdata.txt" appear in the build directory.

B) Code Explaination:

1) pbatforcohqraz.m : The main file for implementing Pilot block and adaptive thresholding technique.

2) pbotforcohqraz.m : The main file for implementing Pilot block and Otsu thresholding technique.

3) locatebarcode.m : Code for locating the barcode which is embedded in an image (plain or natural).