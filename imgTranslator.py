import cv2

img = cv2.imread('lenna.png', cv2.IMREAD_COLOR)

filetxt = open("lenna.txt",'w')

for row in img:
    for pixel in row:
        R = float((float(pixel[0])/256)*7)
        G = float((float(pixel[1])/256)*7)
        B = float((float(pixel[2])/256)*3)
        #print(pixel[2], B, "\t{0:03b}, {0:03b}, {02:02b}".format(int(R), int(G), int(B)))
        filetxt.write("{0:03b}{0:03b}{02:02b}".format(int(R), int(G), int(B)))

filetxt = open("lenna.txt",'r')
binarytxt = filetxt.read()

filebin = open("lenna.bin",'bw')

binaryimg = bytearray([int(binarytxt[i:i+8], 2) for i in range(0, len(binarytxt), 8)])
filebin.write(binaryimg)

filebin.close()
filetxt.close()