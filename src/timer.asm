#---------------------------------------------------
# Program file: timer.asm
# Written by: Carlos Vazquez & Sawyer Anderson
# Date created: 10/24/2024
#---------------------------------------------------
#-------------
# Data Segment
#-------------
.data
message_end:   		.asciiz "Elapsed Time: \n"
message_minutes: 	.asciiz "Minutes: "
message_seconds: 	.asciiz ", Seconds: "
nLine:			.asciiz	"\n"
currTime:		.word 0
	
#-------------
# Text Segment
#-------------
.text
.globl CurrTime

CurrTime:
	# Record end time
	li 	$v0, 30              	# Syscall: get runtime (milliseconds)
	syscall
	
	# Load time into register
	lw 	$t0, timer
	
	sub $t3, $a0, $t0	# get current time in milliseconds
	
	bge $t3, 60000, Minute		# If milliseconds > minute, calculate minutes
	blt $t3, 60000, Seconds		# If not calculate seconds
	
		Minute:
			# Calculate minutes, seconds, and remaining milliseconds
			li 	$t4, 60000		# $t4 = 60,000 ms (1 minute)
			div 	$t5, $t3, $t4       	# $t5 = minutes (integer division)
			mflo	$t6                	# $t6 = remaining milliseconds after minutes
			div 	$t7, $t6, 1000      	# $t7 = seconds (integer division)
			j 	TimePrint
		Seconds:
			div 	$t7, $t3, 1000      	# $t7 = seconds (integer division)
	
	TimePrint:
	# Print "Elapsed Time: \n"
	li 	$v0, 4               	# Syscall: print string
	la 	$a0, message_end
	syscall
	
	# Print minutes
	li 	$v0, 4               	# Syscall: print string
	la 	$a0, message_minutes
	syscall
	li 	$v0, 1               	# Syscall: print integer
	move 	$a0, $t5           	# Load minutes
	syscall
	
	# Print seconds
	li 	$v0, 4               	# Syscall: print string
	la 	$a0, message_seconds
	syscall
	li 	$v0, 1               	# Syscall: print integer
	move 	$a0, $t7           	# Load seconds
	syscall
	
	# Print new line
	li 	$v0, 4               	# Syscall: print string
	la 	$a0, nLine
	syscall
	
	jr 	$ra
