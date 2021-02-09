# import the opencv library 
import cv2 
import time, sys
import RPi.GPIO as GPIO

'''
THIS CODE IS LITLE ENDIAN BASED
IT IS FOR USE WITH DOWNTO STD_LOGIC_VECTOR IN VHDL CODE
'''
D = [
	14, 15, 18, 23, 2, 3, 4, 17,
	24, 25, 16, 26
]

S = [19, 13]
# 00 invalid
# 01 addr enable
# 10 data enable
# 11 EOF




# define a video capture object 
GPIO.setmode(GPIO.BCM) 
GPIO.setwarnings(False)
for d in D:
	GPIO.setup(d, GPIO.OUT)

for s in S:
	GPIO.setup(s, GPIO.OUT)

counter = -1



def loopTest(imgsize):
	global counter
	counter += 1
	p = -1
	for i in range(imgsize):
		for j in range(imgsize):
			for x in range(2):
				if x == 0:
					p += 1
					GPIO.output(S[0],False)
					GPIO.output(S[1],False)
					GPIO.output(D[11], p & 0b100000000000)
					GPIO.output(D[10], p & 0b010000000000)
					GPIO.output(D[9],  p & 0b001000000000)
					GPIO.output(D[8],  p & 0b000100000000)
					GPIO.output(D[7],  p & 0b000010000000)
					GPIO.output(D[6],  p & 0b000001000000)
					GPIO.output(D[5],  p & 0b000000100000)
					GPIO.output(D[4],  p & 0b000000010000)
					GPIO.output(D[3],  p & 0b000000001000)
					GPIO.output(D[2],  p & 0b000000000100)
					GPIO.output(D[1],  p & 0b000000000010)
					GPIO.output(D[0],  p & 0b000000000001) 
					GPIO.output(S[0],False)
					GPIO.output(S[1],True)
				elif x == 1:
					if i == 0 or i == imgsize-1 or j == 0 or j == imgsize-2:# or i%2 == 0 or j%2 == 0:
						R = 7
						G = 7
						B = 7
					else:
						R = 0
						B = 0
						G = 0
					GPIO.output(S[0],False)
					GPIO.output(S[1],False)
					GPIO.output(D[0], R & 0b100)
					GPIO.output(D[1], R & 0b010)
					GPIO.output(D[2], R & 0b001)
					GPIO.output(D[3], G & 0b100)
					GPIO.output(D[4], G & 0b010)
					GPIO.output(D[5], G & 0b001)
					GPIO.output(D[6], B & 0b100)
					GPIO.output(D[7], B & 0b010)
					GPIO.output(D[8], B & 0b001)
					GPIO.output(S[0],True)
					GPIO.output(S[1],False)

	# sets the addr read state for a bit, this is ok, as we are not sending data
	GPIO.output(S[0],True)
	time.sleep(0.0001)
	GPIO.output(S[1],True)

def loopLenna(imgsize):
	global counter
	img = cv2.imread('lenna.png', cv2.IMREAD_COLOR)
	resized = cv2.resize(img, (imgsize, imgsize) ,interpolation=cv2.INTER_AREA)	
	global counter
	counter += 1
	p = -1
	for row in resized:
		for pixel in row:
			for x in range(2):
				if x == 0:
					p += 1
					GPIO.output(S[0],False)
					GPIO.output(D[11], p & 0b100000000000)
					GPIO.output(D[10], p & 0b010000000000)
					GPIO.output(D[9],  p & 0b001000000000)
					GPIO.output(D[8],  p & 0b000100000000)
					GPIO.output(D[7],  p & 0b000010000000)
					GPIO.output(D[6],  p & 0b000001000000)
					GPIO.output(D[5],  p & 0b000000100000)
					GPIO.output(D[4],  p & 0b000000010000)
					GPIO.output(D[3],  p & 0b000000001000)
					GPIO.output(D[2],  p & 0b000000000100)
					GPIO.output(D[1],  p & 0b000000000010)
					GPIO.output(D[0],  p & 0b000000000001) 
					GPIO.output(S[0],False)
					GPIO.output(S[1],True)
				elif x == 1:
					GPIO.output(S[0],False)
					GPIO.output(S[1],False)
					GPIO.output(D[0], int(pixel[0]) & 0b10000000)
					GPIO.output(D[1], int(pixel[0]) & 0b01000000)
					GPIO.output(D[2], int(pixel[0]) & 0b00100000)
					GPIO.output(D[3], int(pixel[1]) & 0b10000000)
					GPIO.output(D[4], int(pixel[1]) & 0b01000000)
					GPIO.output(D[5], int(pixel[1]) & 0b00100000)
					GPIO.output(D[6], int(pixel[2]) & 0b10000000)
					GPIO.output(D[7], int(pixel[2]) & 0b01000000)
					GPIO.output(D[8], int(pixel[2]) & 0b00100000)
					GPIO.output(S[0],True)
					GPIO.output(S[1],False)

	# sets the addr read state for a bit, this is ok, as we are not sending data
	GPIO.output(S[0],True)
	time.sleep(0.0001)
	GPIO.output(S[1],True)

	
while(True): 
	loopLenna(64)
	time.sleep(0.001)
	

# Destroy all the windows 
cv2.destroyAllWindows() 
