#-----------------------------------------------------------
# Program File: locationCheck.asm
# Written by: Sawyer Anderson and Carlos Vazquez
# Date Created: 11/5/2024
# Description: The file that returns actual value for a specific card
#-----------------------------------------------------------
		.data

cardValArr: 	.word 4, 4, 6, 6, 8, 8, 9, 9, 10, 10, 12, 12, 15, 15, 16, 16 # Array of card values

.text
.globl	locationCheck

# Registers of locationCheck
#	a0: row index
# 	a1: column index
#	a2: the base address of the randomization file's newIndArr
#	t0: the base address of the newIndArr adjusted for the current row index, 
#		then becomes the address for the value (index for cardValArr) of newIndArr,
#		then loaded with the address of the cardValArr at index found from newIndArr
#	t1: the adjusted column index
#	t2: the actual value from cardValArr
#	v0: the return value (t2)


locationCheck: # checks and goes to location in the array
	
	beq	$a0, 0, Row0
	beq	$a0, 1, Row1
	beq	$a0, 2, Row2
	beq    	$a0, 3, Row3
	
	Row0: 
		#la	$t0, cardValArr
		addi	$t0, $s3, 0
		
		mul	$t1, $a1, 4
		add	$t0, $t1, $t0
		lw 	$t0, 0($t0)
		mul	$t0, $t0, 4
		la	$t1, cardValArr
		add	$t0, $t0, $t1
		
		j	Return
		
	Row1: 
		#la	$t0, cardValArr+16
		addi	$t0, $s3, 16
		
		mul	$t1, $a1, 4
		add	$t0, $t1, $t0
		lw 	$t0, 0($t0)
		mul	$t0, $t0, 4
		la	$t1, cardValArr
		add	$t0, $t0, $t1
		
		j	Return
		
	Row2: 
		#la	$t0, cardValArr+32
		addi	$t0, $s3, 32
		
		mul	$t1, $a1, 4
		add	$t0, $t1, $t0
		lw 	$t0, 0($t0)
		mul	$t0, $t0, 4
		la	$t1, cardValArr
		add	$t0, $t0, $t1
		
		j	Return
		
	Row3:
		#la	$t0, cardValArr+48
		addi	$t0, $s3, 48
		
		mul	$t1, $a1, 4
		add	$t0, $t1, $t0
		lw 	$t0, 0($t0)
		mul	$t0, $t0, 4
		la	$t1, cardValArr
		add	$t0, $t0, $t1
		
		j	Return
		
	Return:
		lw	$t2, 0($t0)
		move	$v0, $t2
		
		j	end
		
	end:
		jr	$ra
