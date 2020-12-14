# import the opencv library 
import cv2 
import time, sys
import RPi.GPIO as GPIO

R0=2
R1=3
R2=4
G0=17
G1=27
G2=22
B0=5
B1=6
SYNCF=13 # frame sync
SYNCP=19 # pixel sync


# define a video capture object 
vid = cv2.VideoCapture(0) 

GPIO.setmode(GPIO.BCM) 
GPIO.setwarnings(False)
GPIO.setup(R0, GPIO.OUT)
GPIO.setup(R1, GPIO.OUT)
GPIO.setup(R2, GPIO.OUT)
GPIO.setup(G0, GPIO.OUT)
GPIO.setup(G1, GPIO.OUT)
GPIO.setup(G2, GPIO.OUT)
GPIO.setup(B0, GPIO.OUT)
GPIO.setup(B1, GPIO.OUT)
GPIO.setup(SYNCF, GPIO.OUT)
GPIO.setup(SYNCP, GPIO.OUT)

counter = 0

if False:
	GPIO.output(SYNCP,True)
	GPIO.output(SYNCF,False)
	GPIO.output(R0, True)
	GPIO.output(R1, False)
	GPIO.output(R2, True)
	GPIO.output(G0, False)
	GPIO.output(G1, True)
	GPIO.output(G2, False)
	GPIO.output(B0, True)
	GPIO.output(B1, False)
	time.sleep(1)
	GPIO.output(SYNCP,False)
	GPIO.output(SYNCF,True)
	GPIO.output(R0, False)
	GPIO.output(R1, True)
	GPIO.output(R2, False)
	GPIO.output(G0, True)
	GPIO.output(G1, False)
	GPIO.output(G2, True)
	GPIO.output(B0, False)
	GPIO.output(B1, True)
	time.sleep(1)

img = cv2.imread('lenna.png', cv2.IMREAD_COLOR)
resized = cv2.resize(img, (16, 16) ,interpolation=cv2.INTER_AREA)

while(True): 
	cv2.imshow('frame', resized) 
	if cv2.waitKey(1) & 0xFF == ord('q'): 
		break

while(True): 
	GPIO.output(SYNCF,True)
	counter += 1
	p = 0
	for row in resized:
		for pixel in row:
			p += 1
			R = int((float(pixel[0])/256)*7)
			G = int((float(pixel[1])/256)*7)
			B = int((float(pixel[2])/256)*3)
			GPIO.output(SYNCP,False)
			GPIO.output(R0, R & 0x1)
			GPIO.output(R1, R & 0x10)
			GPIO.output(R2, R & 0x001)
			GPIO.output(G0, G & 0x1)
			GPIO.output(G1, G & 0x10)
			GPIO.output(G2, G & 0x001)
			GPIO.output(B0, B & 0x1)
			GPIO.output(B1, B & 0x10)
			GPIO.output(SYNCP,True)
			'''sys.stdout.write("{}{}{}{}{}{}{}{}\t".format(R & 0x1, R & 0x10, R & 0x001, G & 0x1, G & 0x10, G & 0x001, B & 0x1, B & 0x10))
			if p % 10 == 0:
				sys.stdout.write("\n")
		sys.stdout.write("\n")
	sys.stdout.write("\n")'''
	GPIO.output(SYNCF,False)
	print("frarme: {}\tshape: {}".format(counter, resized.shape))
	if cv2.waitKey(1) & 0xFF == ord('q'): 
		break
	

# Destroy all the windows 
cv2.destroyAllWindows() 
