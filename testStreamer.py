# import the opencv library 
import cv2 
import time, sys
import RPi.GPIO as GPIO

'''
THIS CODE IS LITLE ENDIAN BASED
IT IS FOR USE WITH DOWNTO STD_LOGIC_VECTOR IN VHDL CODE
'''

D0=4
D1=17
D2=27
D3=22
D4=3
D5=2
D6=6
D7=5

# 00 invalid
# 01 addr enable
# 10 data enable
# 11 EOF
S0=19 # addr
S1=13 # data



# define a video capture object 
GPIO.setmode(GPIO.BCM) 
GPIO.setwarnings(False)
GPIO.setup(D0, GPIO.OUT)
GPIO.setup(D1, GPIO.OUT)
GPIO.setup(D2, GPIO.OUT)
GPIO.setup(D3, GPIO.OUT)
GPIO.setup(D4, GPIO.OUT)
GPIO.setup(D5, GPIO.OUT)
GPIO.setup(D6, GPIO.OUT)
GPIO.setup(D7, GPIO.OUT)
GPIO.setup(S0, GPIO.OUT)
GPIO.setup(S1, GPIO.OUT)

counter = -1



def loopTest():
	global counter
	GPIO.output(S0,True)
	counter += 1
	p = -1
	for i in range(16):
		for j in range(16):
			for x in range(2):
				if x == 0:
					p += 1
					GPIO.output(S0,False)
					GPIO.output(S1,False)
					GPIO.output(D7, p & 0b10000000)
					GPIO.output(D6, p & 0b01000000)
					GPIO.output(D5, p & 0b00100000)
					GPIO.output(D4, p & 0b00010000)
					GPIO.output(D3, p & 0b00001000)
					GPIO.output(D2, p & 0b00000100)
					GPIO.output(D1, p & 0b00000010)
					GPIO.output(D0, p & 0b00000001) 
					GPIO.output(S0,False)
					GPIO.output(S1,True)
				elif x == 1:
					if i == 0 or i == 14 or j == 0 or j == 14 or i%2 == 0 or j%2 == 0:
						R = 7
						G = 7
						B = 3
					else:
						R = 0
						B = 0
						G = 0
					GPIO.output(S0,False)
					GPIO.output(S1,False)
					GPIO.output(D0, R & 0b100)
					GPIO.output(D1, R & 0b010)
					GPIO.output(D2, R & 0b001)
					GPIO.output(D3, G & 0b100)
					GPIO.output(D4, G & 0b010)
					GPIO.output(D5, G & 0b001)
					GPIO.output(D6, B & 0b10)
					GPIO.output(D7, B & 0b01)
					GPIO.output(S0,True)
					GPIO.output(S1,False)

	# sets the addr read state for a bit, this is ok, as we are not sending data
	GPIO.output(S0,True)
	time.sleep(0.0001)
	GPIO.output(S1,True)


def loopLenna():
	global counter
	img = cv2.imread('lenna.png', cv2.IMREAD_COLOR)
	resized = cv2.resize(img, (16, 16) ,interpolation=cv2.INTER_AREA)	
	global counter
	GPIO.output(S0,True)
	counter += 1
	p = -1
	for row in resized:
		for pixel in row:
			for x in range(2):
				if x == 0:
					p += 1
					GPIO.output(S0,False)
					GPIO.output(S1,False)
					GPIO.output(D7, p & 0b10000000)
					GPIO.output(D6, p & 0b01000000)
					GPIO.output(D5, p & 0b00100000)
					GPIO.output(D4, p & 0b00010000)
					GPIO.output(D3, p & 0b00001000)
					GPIO.output(D2, p & 0b00000100)
					GPIO.output(D1, p & 0b00000010)
					GPIO.output(D0, p & 0b00000001) 
					GPIO.output(S0,False)
					GPIO.output(S1,True)
				elif x == 1:
					
					GPIO.output(S0,False)
					GPIO.output(S1,False)
					GPIO.output(D0, int(pixel[0]) & 0b100)
					GPIO.output(D1, int(pixel[0]) & 0b010)
					GPIO.output(D2, int(pixel[0]) & 0b001)
					GPIO.output(D3, int(pixel[1]) & 0b100)
					GPIO.output(D4, int(pixel[1]) & 0b010)
					GPIO.output(D5, int(pixel[1]) & 0b001)
					GPIO.output(D6, int(pixel[2]) & 0b10)
					GPIO.output(D7, int(pixel[2]) & 0b01)
					GPIO.output(S0,True)
					GPIO.output(S1,False)

	# sets the addr read state for a bit, this is ok, as we are not sending data
	GPIO.output(S0,True)
	time.sleep(0.0001)
	GPIO.output(S1,True)


	
while(True): 
#for _ in range(6):
	loopLenna()
	time.sleep(0.001)
	

# Destroy all the windows 
cv2.destroyAllWindows() 
