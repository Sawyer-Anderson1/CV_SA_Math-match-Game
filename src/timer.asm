#---------------------------------------------------
# Program file: timer.asm
# Written by: Sawyer Anderson
# Date created: 10/24/2024
#---------------------------------------------------

#--------------------------------------------------
# Registers:
# 	$t0: register to load in/store time
#	$t1: holds minute value
#	$t2: holds sec value
#	$t3: for the value that holds 60s
#	$t4: the register that holds tnes digit 
#		for both minutes and seconds to edit
#		the output
#	$t7: the ones digit
#	$t5: hold 10 for the calculation of the double digits
#	$t6: for loading time format
#--------------------------------------------------

#-------------
# Data Segment
#-------------
		.data
time:		.word 0
timeFormat:	.asciiz "00:00" # will just edit the string
tens:		
#-------------
# Text Segment
#-------------
.text

.globl Timer
.globl TimerPause
Timer: 
	move	$t0, $a0 # taking a saved timer as the starting point for the timer
	
	# waiting 1 second (loop)
	li	$v0, 32 # sleep syscall
	li	$a0, 1000 # sleep for one second
	syscall 

	addi	$t0, $zero, 1 # adding a second to time
	sw	$t0, time

	# load in the format
	lw	$t6, timeFormat
	
	# jump to the infinite loop timer
	j	Loop

	Loop:
		# waiting 1 second (loop)
		li	$v0, 32 # sleep syscall
		li	$a0, 1000 # sleep for one second
		syscall 

		addi	$t0, $t0, 1 # adding a second to time
		sw	$t0, time
	
		addi	$t3, $zero, 60 # t2 holds the value 60, for calculating time
		div	$t0, $t3 # calculating the minutes and seconds
	
		mfhi	$t2 # get the seconds (remainder)
		mflo	$t1 # get the minutes (result)
	
		# edit the timeFormat
		addi	$t5, $zero, 10 # get 10
		div	$t1, $t5 # if it (minutes) is a tens digit then Lo will return > 0
	
		mflo	$t4 # get the tens digit
		mfhi	$t7 # get the ones digit
	
		li	$v0, 1
		move	$a0, $t4
		syscall
		li	$v0, 1
		move	$a0, $t7
		syscall
	
		li	$v0, 11
		la	$a0, 8($t6)
		syscall
	
		div	$t2, $t5 # if it (seconds) is a tens digit then Lo will return > 0
	
		mflo	$t4 # get it the tens digit
		mfhi	$t7 # get the ones digit
	
		li	$v0, 1
		move	$a0, $t4
		syscall
		li	$v0, 1
		move	$a0, $t7
		syscall
	
		j	Loop

TimerPause:
	add	$v0, $zero, $t0
	jr 	$ra
