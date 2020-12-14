# import the opencv library 
import cv2 
import time, sys
import RPi.GPIO as GPIO

# define a video capture object 
vid = cv2.VideoCapture(0) 
vid.set(3,64)
vid.set(4,64)

while(True): 
	
	# Capture the video frame 
	# by frame 

	ret, frame = vid.read()
	GPIO.output(SYNCF,True)

	if ret:
		cv2.imshow('frame', frame) 
			
	# the 'q' button is set as the 
	# quitting button you may use any 
	# desired button of your choice 
	if cv2.waitKey(1) & 0xFF == ord('q'): 
		break

# After the loop release the cap object 
vid.release() 
# Destroy all the windows 
cv2.destroyAllWindows() 
