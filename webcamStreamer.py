# import the opencv library 
import cv2 
import time
import RPi.GPIO as GPIO

R0=2
R1=3
R2=4
G0=17
G1=27
G2=22
B0=5
B1=6
SYNC=0
SYNC2=1


# define a video capture object 
vid = cv2.VideoCapture(0) 
vid.set(3,100)
vid.set(4,200)


GPIO.setmode(GPIO.BCM) 
GPIO.setup(R0, GPIO.OUT)
GPIO.setup(R1, GPIO.OUT)
GPIO.setup(R2, GPIO.OUT)
GPIO.setup(G0, GPIO.OUT)
GPIO.setup(G1, GPIO.OUT)
GPIO.setup(G2, GPIO.OUT)
GPIO.setup(B0, GPIO.OUT)
GPIO.setup(B1, GPIO.OUT)
GPIO.setup(SYNC, GPIO.OUT)
GPIO.setup(SYNC2, GPIO.OUT)

counter = 0

while(True): 
	
	# Capture the video frame 
	# by frame 

	ret, frame = vid.read() 
	GPIO.output(SYNC2,True)

	if ret:
		#cv2.imshow('frame', frame) 
		counter += 1
		for row in frame:
			for pixel in row:
				GPIO.output(SYNC,False)
				R = int((float(pixel[0])/256)*7)
				G = int((float(pixel[1])/256)*7)
				B = int((float(pixel[2])/256)*3)
				GPIO.output(R0, R & 0x1)
				GPIO.output(R1, R & 0x10)
				GPIO.output(R2, R & 0x001)
				GPIO.output(G0, G & 0x1)
				GPIO.output(G1, G & 0x10)
				GPIO.output(G2, G & 0x001)
				GPIO.output(B0, B & 0x1)
				GPIO.output(B1, B & 0x10)
				GPIO.output(SYNC,True)

	#if counter % 10 == 0:
	print(counter)
	GPIO.output(SYNC2,False)

	
	# the 'q' button is set as the 
	# quitting button you may use any 
	# desired button of your choice 
	if cv2.waitKey(1) & 0xFF == ord('q'): 
		break

# After the loop release the cap object 
vid.release() 
# Destroy all the windows 
cv2.destroyAllWindows() 
