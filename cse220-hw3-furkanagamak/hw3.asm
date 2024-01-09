######### Furkan Agamak ##########
######### 114528166 ##########
######### FAGAMAK ##########

######## DO NOT ADD A DATA SECTION ##########
######## DO NOT ADD A DATA SECTION ##########
######## DO NOT ADD A DATA SECTION ##########

.text
.globl initialize
initialize:
	addi $sp, $sp, -28
	sw $ra, 0($sp)	
	sw $s0, 4($sp)	
	sw $s1, 8($sp)	
	sw $s2, 12($sp)	
	sw $s3, 16($sp)	
	sw $s4, 20($sp)	
	sw $s5, 24($sp)
	
	move $s0, $0
	move $s1, $0
	move $s2, $0
	move $s3, $0
	move $s4, $0
	move $s5, $0
	move $t0, $0
	move $t1, $0
	move $t2, $0
	move $t3, $0
	move $t4, $0
	move $t5, $0
	move $t6, $0
	move $t7, $0
	move $t8, $0
	move $t9, $0		
	
	move $s0, $0
	move $s1, $0
	
	move $s4, $a1 ## storing the buffer address in $s4
	
	move $t0, $a0 ## Storing the file name in $t0
	move $t1, $a1 ## Storing the buffer address in $t1
	
	li $v0, 13 ## 13 for opening file
	li $a1, 0 ## 0 for reading from file
	li $a2, 0
	syscall
	
	bltz $v0, error ## Jump to error if file descriptor is negative
	move $t2, $v0 ## Storing the file descriptor in $t2
	
	li $v0, 14 ## 14 for reading from file
	move $a0, $t2 ## File descriptor in $a0
	move $a1, $t1 ## Buffer address in $a1
	li $a2, 1 ## Setting the number of characters to read as 1
	syscall
	
	blez $v0, error ## Jump to error if v0 is negative or zero
	
	li $t3, 0 ## initializing the result of the number of rows to 0
	li $t5, 10
	li $t6, '0'
	li $t7, '9'
	li $t8, '\r'
	li $t9, '\n'
	
	loop1: ## loop to read the number of rows
		lw $t1, 0($a1) ## loading the character we read into $t1
		
		beq $t1, $t8, done1 ## done if \r
		beq $t1, $t9, done1 ## done if \n
		blt $t1, $t6, error ## error if less than 0
		bgt $t1, $t7, error ## error if more than 9
		
		mult $t3, $t5
		mflo $t3 ## store the multiplication by 10 in result
		add $t3, $t3, $t1 ## add the character we read to result
		sub $t3, $t3, $t6 ## subtract '0' by the result
		
		li $v0, 14 ## 14 for reading from file
		syscall
		blez $v0, error ## Jump to error if v0 is negative or zero
		j loop1
		
	done1:
		blez $t3, error ## error if the final result is less than or equal to 0 
		bgt $t3, $t5, error ## error if the final result is more than 10
		sw $t3, 0($a1) ## saving the final result of number of rows in the buffer
		addi $a1, $a1, 4 ## incrementing the buffer
		move $s0, $t3 ## saving the number of rows in $s0
		
		li $t3, 0 ## initializing the result of line 2 to 0
		
		li $v0, 14 ## 14 for reading from file
		syscall
		blez $v0, error ## Jump to error if v0 is negative or zero
		
		j loop2
	
	loop2: ## loop to read the number of cols
		lw $t1, 0($a1) ## loading the character we read into $t1
		
		beq $t1, $t8, done2 ## done if \r
		beq $t1, $t9, done2 ## done if \n
		blt $t1, $t6, error ## error if less than 0
		bgt $t1, $t7, error ## error if more than 9
		
		mult $t3, $t5
		mflo $t3 ## store the multiplication by 10 in result
		add $t3, $t3, $t1 ## add the character we read to result
		sub $t3, $t3, $t6 ## subtract '0' by the result
		
		li $v0, 14 ## 14 for reading from file
		syscall
		blez $v0, error ## Jump to error if v0 is negative or zero
		j loop2
	
	done2: 
		blez $t3, error ## error if the final result is less than or equal to 0 
		bgt $t3, $t5, error ## error if the final result is more than 10
		sw $t3, 0($a1) ## saving the final result of num of cols in the buffer
		addi $a1, $a1, 4 ## incrementing the buffer
		move $s1, $t3 ## saving the number of cols in $s1
		
		li $t3, 0 ## initializing the result to 0
		li $t4, ' ' ## storing whitespace in $t4
		
		li $s2, 0 ## initializing number of columns to be read in the matrix
		li $s3, 0 ## initializing number of rows to be read in the matrix
	
	loop3:
		li $v0, 14 ## 14 for reading from file
		
		syscall
		
		bltz $v0, error ## Jump to error if v0 is negative
		beqz $v0, done3 ## done if v0 is zero which means we reached end of file
		
		lw $t1, 0($a1) ## loading the character we read into $t1
		
		beq $t1, $t4, error ## error if first digit is whitespace
		beq $t1, $t8, error ## error if first digit is \r
		beq $t1, $t9, error ## error if first digit is \n
		blt $t1, $t6, error ## error if first digit is less than 0
		bgt $t1, $t7, error ## error if first digit is more than 9
		
		li $t3, 0 ## initializing the result to 0
		innerLoop:
			mult $t3, $t5
			mflo $t3 ## store the multiplication by 10 in result
			sub $t3, $t3, $t6 ## subtract '0' by the result
			addu $t3, $t3, $t1 ## add the character we read to result
			bltz $t3, error
		
			li $v0, 14 ## 14 for reading from file
			syscall
			
			bltz $v0, error ## Jump to error if v0 is negative
			beqz $v0, innerLoopEndOfFile ## done if v0 is zero which means we reached end of file
			
			lw $t1, 0($a1) ## loading the character we read into $t1
			
			beq $t1, $t4, innerLoopNewCol ## done if whitespace
			beq $t1, $t8, innerLoopNewRow ## done if \r
			beq $t1, $t9, innerLoopNewRow ## done if \n
			blt $t1, $t6, error ## error if less than 0
			bgt $t1, $t7, error ## error if more than 9
			j innerLoop
			
		innerLoopNewCol:
			addi $s2, $s2, 1 ## add 1 to counter of cols
			j innerLoopDone
			
		innerLoopNewRow:
			addi $s2, $s2, 1
			addi $s3, $s3, 1 ## add 1 to counter of rows
			bne $s2, $s1, error ## error if number of cols don't match the entered number of cols
			li $s2, 0
			j innerLoopDone
						
		innerLoopEndOfFile:
			bne $s2, $s1, error ## error if number of cols don't match the entered number of cols
			sw $t3, 0($a1) ## saving the final number before the end of file in the buffer
			addi $a1, $a1, 4 ## incrementing the buffer
			j done3
			
		innerLoopDone:
			sw $t3, 0($a1) ## saving the final number before the end of file in the buffer
			addi $a1, $a1, 4 ## incrementing the buffer
			j loop3
			
	done3:
		bne $s3, $s0, error ## error if number of rows don't match the entered number of rows
		
		li $v0, 16
		syscall
		
		li $v0, 1
		
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp)
		lw $s5, 24($sp)
		addi $sp, $sp, 28
		jr $ra
		
	error:
		li $v0, 16
		syscall
		li $v0, -1 ## return -1 in $v0
		mult $s0, $s1 ## multiply the num of rows x num of cols
		mflo $t0
		addi $t0, $t0, 2
		li $t0, 103
		li $t1, 0 ## counter
		resetBuffer:
			beq $t1, $t0, resetDone
			sw $0, 0($s4) ## store zero in the buffer
			addi $t1, $t1, 1
			addi $s4, $s4, 4
			j resetBuffer
			
		resetDone:
			lw $ra, 0($sp)
			lw $s0, 4($sp)
			lw $s1, 8($sp)
			lw $s2, 12($sp)
			lw $s3, 16($sp)
			lw $s4, 20($sp)
			lw $s5, 24($sp)
			addi $sp, $sp, 28
			jr $ra

.globl write_file
write_file:
	addi $sp, $sp, -28
	sw $ra, 0($sp)	
	sw $s0, 4($sp)	
	sw $s1, 8($sp)	
	sw $s2, 12($sp)	
	sw $s3, 16($sp)	
	sw $s4, 20($sp)	
	sw $s5, 24($sp)
	
	move $s0, $0
	move $s1, $0
	move $s2, $0
	move $s3, $0
	move $s4, $0
	move $s5, $0
	move $t0, $0
	move $t1, $0
	move $t2, $0
	move $t3, $0
	move $t4, $0
	move $t5, $0
	move $t6, $0
	move $t7, $0
	move $t8, $0
	move $t9, $0
	
	li $t6, 0 ## initialize the number of characters read to 0
	move $s0, $a0 ## move filename to $s0
	move $s1, $a1 ## move buffer address to $s1
	
	li $v0, 13 ## 13 for opening file
	li $a1, 1 ## 1 for writing to file
	li $a2, 0
	syscall
	
	bltz $v0, writeError ## Jump to error if file descriptor is negative
	move $t0, $v0 ## Storing the file descriptor in $t0
	
	move $a1, $s1 ## move buffer back to $a1
	
	li $t5, 10 ## load 10 into $t5
	li $t7, '\n' ## next line in $t7
	
	lw $t1, 0($a1) ## loading the num of rows from the buffer
	div $t1, $t5 ## divide num by 10
	mfhi $t2 ## remainder (if 0 then it's a double digit, else single digit)
	
	beqz $t2, doubleDigitRow
	move $s2, $t2 ## set $s2 to num of rows
	j writeRow
	
	doubleDigitRow:
		li $t2, 10 ## set $t2 to 10 if it's double digit
		move $s2, $t2 ## set $s2 to num of rows
		
		li $t9, '1'
		li $t8, '0'
		sb $t9, 0($a1)
		
		li $v0, 15 ## 15 for writing to file
		move $a0, $t0 ## File descriptor in $a0
		li $a2, 1 ## Setting the number of characters to write as 1
		syscall
		addi $t6, $t6, 1 ## increment num of chars written
		bltz $v0, writeError ## Jump to error if $v0 is negative
		
		##addi $a1, $a1, 4
		
		sb $t8, 0($a1)
		
		li $v0, 15 ## 15 for writing to file
		syscall
		addi $t6, $t6, 1 ## increment num of chars written
		bltz $v0, writeError ## Jump to error if $v0 is negative
		
		sb $t7, 0($a1)
		li $v0, 15 ## 15 for writing to file
		syscall
		addi $t6, $t6, 1 ## increment num of chars written
		bltz $v0, writeError ## Jump to error if $v0 is negative
		
		addi $a1, $a1, 4
		j continueToCol
		
	writeRow:
		addi $t2, $t2, 48
		sb $t2, 0($a1)
		
		li $v0, 15 ## 15 for writing to file
		move $a0, $t0 ## File descriptor in $a0
		move $a1, $a1 ## Buffer address in $a1
		li $a2, 1 ## Setting the number of characters to write as 1
		syscall
		addi $t6, $t6, 1 ## increment num of chars written
		bltz $v0, writeError ## Jump to error if $v0 is negative
		
		sb $t7, 0($a1)
		li $v0, 15 ## 15 for writing to file
		syscall
		addi $t6, $t6, 1 ## increment num of chars written
		bltz $v0, writeError ## Jump to error if $v0 is negative
		
		addi $a1, $a1, 4
		j continueToCol
	
	
	continueToCol:
		lw $t1, 0($a1) ## loading the num of cols from the buffer
		div $t1, $t5 ## divide num by 10
		mfhi $t2 ## remainder (if 0 then it's a double digit, else single digit)
		
		beqz $t2, doubleDigitCol
		move $s3, $t2 ## set $s3 to num of rows
		j writeCol
		
		doubleDigitCol:
		li $t2, 10 ## set $t2 to 10 if it's double digit
		move $s3, $t2 ## set $s3 to num of cols
		
		li $t9, '1'
		li $t8, '0'
		sb $t9, 0($a1)
		
		li $v0, 15 ## 15 for writing to file
		move $a0, $t0 ## File descriptor in $a0
		li $a2, 1 ## Setting the number of characters to write as 1
		syscall
		addi $t6, $t6, 1 ## increment num of chars written
		bltz $v0, writeError ## Jump to error if $v0 is negative
		
		##addi $a1, $a1, 4
		
		sb $t8, 0($a1)
		li $v0, 15 ## 15 for writing to file
		syscall
		addi $t6, $t6, 1 ## increment num of chars written
		bltz $v0, writeError ## Jump to error if $v0 is negative
		
		sb $t7, 0($a1)
		li $v0, 15 ## 15 for writing to file
		syscall
		addi $t6, $t6, 1 ## increment num of chars written
		bltz $v0, writeError ## Jump to error if $v0 is negative
		
		##addi $a1, $a1, 4
		li $t0, 0 ## initialize $t0 to 0
		li $s4, 0 ## initialize num of columns to 0
		li $s5, 0 ## initialize num of rows to 0
		j continueToMatrix
		
	writeCol:
		addi $t2, $t2, 48
		sb $t2, 0($a1)
		
		li $v0, 15 ## 15 for writing to file
		move $a0, $t0 ## File descriptor in $a0
		move $a1, $a1 ## Buffer address in $a1
		li $a2, 1 ## Setting the number of characters to write as 1
		syscall
		addi $t6, $t6, 1 ## increment num of chars written
		bltz $v0, writeError ## Jump to error if $v0 is negative
		
		sb $t7, 0($a1)
		li $v0, 15 ## 15 for writing to file
		syscall
		addi $t6, $t6, 1 ## increment num of chars written
		bltz $v0, writeError ## Jump to error if $v0 is negative
		
		##addi $a1, $a1, 4
		li $t0, 0 ## initialize $t0 to 0
		li $s4, 0 ## initialize num of columns to 0
		li $s5, 0 ## initialize num of rows to 0
		j continueToMatrix
	
	continueToMatrix:
		mult $s3, $s2 ## multiply initial num of rows x num of cols
		mflo $t4 ## store result in $t4
		
		mult $s4, $s5
		mflo $t7
		
		##beq $t4, $t0, endMatrix ## end loop if we reached our target size
		
		addi $a1, $a1, 4 ## increment buffer
		lw $t1, 0($a1) ## loading the num from the buffer
		
		li $t8, 0 ## counter
		startLoop:
			div $t1, $t5 ## divide num by 10
			mflo $t1 ## quotient
			mfhi $t2 ## remainder
			addi $t2, $t2, 48 ## convert to ascii
			
			addi $sp, $sp, -4
			sw $t2, 0($sp)
			addi $t8, $t8, 1
			beqz $t1, doneWithNumber ## if quotient = 0 go to done
			j startLoop
			
		doneWithNumber:
			addi $t0, $t0, 1 ## increment num of numbers in the matrix
			storeOnStack:
				beqz $t8, doneStoring
				lw $t2, 0($sp)
				sw $t2, 0($a1) ## write digit to the file
				li $v0, 15 ## 15 for writing to file
				syscall
				addi $t6, $t6, 1 ## increment num of chars written
				bltz $v0, writeError ## Jump to error if $v0 is negative
				addi $sp, $sp, 4
				addi $t8, $t8, -1
				j storeOnStack
				
			doneStoring:	
				addi $s4, $s4, 1 ## increment column counter
				beq $s4, $s3, addNewRow
				
				li $t2, ' '
				sw $t2, 0($a1) ## write space to the file
				li $v0, 15 ## 15 for writing to file
				syscall
				addi $t6, $t6, 1 ## increment num of chars written
				bltz $v0, writeError ## Jump to error if $v0 is negative
				j continueToMatrix
				
				addNewRow:
					addi $s5, $s5, 1 ## increment row counter
					li $s4, 0 ## reset column counter
					li $t2, '\n'
					sw $t2, 0($a1) ## write space to the file
					li $v0, 15 ## 15 for writing to file
					syscall
					addi $t6, $t6, 1 ## increment num of chars written
					bltz $v0, writeError ## Jump to error if $v0 is negative
					beq $s5, $s2, endMatrix
					j continueToMatrix
			
	endMatrix:
		li $v0, 16
		syscall
		
		move $v0, $t6
	
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp)
		lw $s5, 24($sp)
		addi $sp, $sp, 28
		jr $ra
	
	writeError:
		li $v0, 16
		syscall
		
		li $v0, -1
	
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp)
		lw $s5, 24($sp)
		addi $sp, $sp, 28
		jr $ra

.globl rotate_clkws_90
rotate_clkws_90:
	addi $sp, $sp, -28
	sw $ra, 0($sp)	
	sw $s0, 4($sp)	
	sw $s1, 8($sp)	
	sw $s2, 12($sp)	
	sw $s3, 16($sp)	
	sw $s4, 20($sp)	
	sw $s5, 24($sp)
	
	move $s0, $0
	move $s1, $0
	move $s2, $0
	move $s3, $0
	move $s4, $0
	move $s5, $0
	move $t0, $0
	move $t1, $0
	move $t2, $0
	move $t3, $0
	move $t4, $0
	move $t5, $0
	move $t6, $0
	move $t7, $0
	move $t8, $0
	move $t9, $0
	
	move $s0, $a0 ## store the buffer address in $s0
	move $s1, $a1 ## store the file name in $s1
	
	lw $s2, 0($a0) ## store the num of rows in $s2
	lw $s3, 4($a0) ## store the num of cols in $s3
	
	mul $s5, $s2, $s3 ## num of elements in the matrix
	
	addiu $t1, $s3, -1 ## store num of cols - 1 in $t1
	li $t9, 4 ## store 4 in $t9
	
	move $t3, $0 ## initialize row counter
	move $t4, $0 ## initialize col counter
	move $t5, $0 ## initialize base address to 0
	move $t8, $0 ## initalize $t8 to zero
	
	move $t0, $sp ## store sp in $t0
	move $t7, $sp
	
	iter_arr_row:
		addiu $t3, $s2, -1 ## decrement from row
		iter_arr_col:
			mult $s3, $t3 ## j * col count
			mflo $t5
			addu $t5, $t5, $t4 ## (j * col count) + i
			mult $t5, $t9 ## 4 * (j * col count) + i
			mflo $t5
			addu $t5, $t5, $s0
			addiu $t2, $t2, 1
			
			lw $t8, 8($t5) ## load the element at the address
			addiu $sp, $sp, -4
			addu $t2, $t2, $0
			sw $t8, 0($sp)
			
			beq $t3, $0, end_iter_col
			move $t2, $0
			addiu $t3, $t3, -1 ## increment col counter j
			j iter_arr_col
			
		end_iter_col:
			addiu $t2, $t2, 1
			move $t2, $t4
		 	beq $t4, $t1, end_iter_row
			addiu $t4, $t4, 1 ## increment row counter i
			move $t2, $0
			j iter_arr_row
			
		end_iter_row:
			move $t2, $0
			j done
			
	done: 
		sw $s3, 0($a0) ## store the num of cols as the first element of the buffer
		sw $s2, 4($a0) ## store the num of rows as the second element of the buffer
		
		addiu $a0, $a0, 8
		
		move $t1, $0 ## initialize counter to 0
		move $t5, $0 ## initialize element to 0
		bufferStoreLoop:
			addiu $t0, $t0, -4 ## decrement the stack
			lw $t5, 0($t0) ## get element from the stack
			sw $t5, 0($a0) ## store element in the buffer
			addiu $a0, $a0, 4 ## increment the buffer
			
			addiu $t1, $t1, 1
			beq $t1, $s5, doneBufferLoop ## end loop if counter equals num of elements in the matrix
			j bufferStoreLoop
		
		doneBufferLoop:
			mul $t9, $s5, $t9 ## multiply num of elements in the matrix by 4
			
			##add $sp, $sp, $t9 ## restore the stack
			move $sp, $t7 ## restore the stack
			
			move $a0, $s1 ## store file name in $a0
			move $a1, $s0 ## store buffer in $a1
			
			jal write_file
			
			lw $ra, 0($sp)
			lw $s0, 4($sp)
			lw $s1, 8($sp)
			lw $s2, 12($sp)
			lw $s3, 16($sp)
			lw $s4, 20($sp)
			lw $s5, 24($sp)
			addi $sp, $sp, 28
  		jr $ra

.globl rotate_clkws_180
rotate_clkws_180:
	addi $sp, $sp, -28
	sw $ra, 0($sp)	
	sw $s0, 4($sp)	
	sw $s1, 8($sp)	
	sw $s2, 12($sp)	
	sw $s3, 16($sp)	
	sw $s4, 20($sp)	
	sw $s5, 24($sp)
	
	move $s0, $0
	move $s1, $0
	move $s2, $0
	move $s3, $0
	move $s4, $0
	move $s5, $0
	move $t0, $0
	move $t1, $0
	move $t2, $0
	move $t3, $0
	move $t4, $0
	move $t5, $0
	move $t6, $0
	move $t7, $0
	move $t8, $0
	move $t9, $0
	
	li $t9, 4
	move $s3, $0
	move $t7, $0
	lw $s0, 0($a0)
	lw $s1, 4($a0)
	
	mult $s0, $s1
	mflo $t7
	
	addiu $s4, $sp, 0
	
	addiu $s3, $s0, -1
	mult $s1, $s3
	mflo $s3
	addiu $t2, $t2, 1
	addu $s3, $s3, $s1
	addu $t0, $t0, $t2
	addiu $s3, $s3, -1
	mult $s3, $t9
	mflo $s3
	addu $t0, $t0, $t2
	addiu $s3, $s3, 8
	addu $s3, $s3, $a0
	
	move $t8, $0
	
	loop180:
		addiu $t0, $t0, 1
		
		lw $t8, 0($s3)
		addu $t0, $t2, $t0
		addiu $sp, $sp, -4
		sw $t8, 0($sp)
		
		addiu $t2, $t2, 1
		beq $t7, $0 doneLoop180
		addu $t0, $t0, $t2
		addiu $s3, $s3, -4
		addu $t5, $t0, $t4
		addiu $t7, $t7, -1
		move $t0, $t2
		j loop180
	
	doneLoop180:
		addiu $t2, $t2, 1
		addu $t0, $t0, $t2
		
		addiu $t7, $a0, 0
		addiu $sp, $s4, 0
		addiu $sp, $sp, -4
		mult $s1, $s0
		mflo $t1
		
		addiu $t6, $a0, 0
		addiu $t6, $t6, 4
		move $s3, $0
		
		bufferStoreLoop180:
			addiu $t6, $t6, 4
			lw $s3, 0($sp)
			addiu $t2, $t2, 1
			addu $t0, $t0, $t2
			sw $s3, 0($t6)
			addu $t4, $t4, $t5
			
			addiu $t1, $t1, -1
			addiu $sp, $sp, -4
			move $t3, $t5
			beq $t1, $0 bufferStoreLoopDone180
			addu $t0, $t0, $t2
			j bufferStoreLoop180
		
		bufferStoreLoopDone180:
			addiu $sp, $s4, 0
			addiu $s0, $a0, 0
			addiu $a0, $a1, 0
			addiu $a1, $s0, 0
			
			jal write_file
			
			lw $ra, 0($sp)
			lw $s0, 4($sp)
			lw $s1, 8($sp)
			lw $s2, 12($sp)
			lw $s3, 16($sp)
			lw $s4, 20($sp)
			lw $s5, 24($sp)
			addi $sp, $sp, 28
			jr $ra

.globl rotate_clkws_270
rotate_clkws_270:
	addi $sp, $sp, -28
	sw $ra, 0($sp)	
	sw $s0, 4($sp)	
	sw $s1, 8($sp)	
	sw $s2, 12($sp)	
	sw $s3, 16($sp)	
	sw $s4, 20($sp)	
	sw $s5, 24($sp)
	
	move $s0, $0
	move $s1, $0
	move $s2, $0
	move $s3, $0
	move $s4, $0
	move $s5, $0
	move $t0, $0
	move $t1, $0
	move $t2, $0
	move $t3, $0
	move $t4, $0
	move $t5, $0
	move $t6, $0
	move $t7, $0
	move $t8, $0
	move $t9, $0
	
	li $t4, 4
	move $s5, $0
	move $t0, $0
	move $s0, $0
	move $t2, $0
	lw $s1, 0($a0)
	lw $t5, 4($a0)
	move $t1, $0
	move $t3, $0
	move $t6, $0
	
	addiu $s5, $t5, -1
	addiu $t9, $s1, -1
	addiu $s2, $sp, 0
	
	loop270:
		move $t0, $0
		addiu $t9, $s1, 0
		addiu $t9, $t9, -1
		
		row270:
			mult $t0, $t5
			mflo $s0
			addu $s0, $s0, $s5
			mult $s0, $t4
			mflo $s0
			addu $s0, $s0, $a0
			addiu $t1, $t1, 1
			addu $t3, $t3, $t1
			addu $t6, $t6, $t3
			addiu $t3, $t3, 1
			
			lw $t2, 8($s0)
			addiu $sp, $sp, -4
			addu $t3, $t3, $t1
			sw $t2, 0($sp)
			beq $t9, $t0, endRow270
			addu $t6, $t3, $t1
			addiu $t0, $t0, 1
			j row270
			
		endRow270:
			addiu $t1, $t1, 1
			addu $t3, $t3, $t1
			beqz $s5, bufferLoop4
			addiu $s5, $s5, -1
			j loop270
		
		bufferLoop4:
			addiu $t1, $t1, 1
			addu $t3, $t3, $t1
			addu $t6, $t6, $t3
			sw $t5, 0($a0)
			sw $s1, 4($a0)
			
			addiu $s5, $a0, 0
			addu $t3, $t3, $t6
			addiu $sp, $s2, 0
			addiu $sp, $sp, -4
			
			mult $t5, $s1
			mflo $t0
			addu $t3, $t3, $t6
			addiu $s3, $a0, 4
			move $s0, $0
			
		bufferStoreLoop4:
			addiu $t1, $t1, 1
			addu $t3, $t3, $t1
			addu $t6, $t6, $t3
			addiu $s3, $s3, 4
			lw $s0, 0($sp)
			addiu $t6, $t6, 1
			sw $s0, 0($s3)
			
			addu $t1, $t1, $t3
			addu $t3, $t3, $t1
			addiu $sp, $sp, -4
			addu $t6, $t6, $t3
			addiu $t0, $t0, -1
			
			beq $t0, $0, bufferStoreLoopDone4
			j bufferStoreLoop4
		
		bufferStoreLoopDone4:
			addiu $sp, $s2, 0
			addiu $s1, $a0, 0
			addiu $a0, $a1, 0
			addiu $a1, $s1, 0
			
			jal write_file
			
			lw $ra, 0($sp)
			lw $s0, 4($sp)
			lw $s1, 8($sp)
			lw $s2, 12($sp)
			lw $s3, 16($sp)
			lw $s4, 20($sp)
			lw $s5, 24($sp)
			addi $sp, $sp, 28
			jr $ra
			
.globl mirror
mirror:
	addi $sp, $sp, -28
	sw $ra, 0($sp)	
	sw $s0, 4($sp)	
	sw $s1, 8($sp)	
	sw $s2, 12($sp)	
	sw $s3, 16($sp)	
	sw $s4, 20($sp)	
	sw $s5, 24($sp)
	
	move $s0, $0
	move $s1, $0
	move $s2, $0
	move $s3, $0
	move $s4, $0
	move $s5, $0
	move $t0, $0
	move $t1, $0
	move $t2, $0
	move $t3, $0
	move $t4, $0
	move $t5, $0
	move $t6, $0
	move $t7, $0
	move $t8, $0
	move $t9, $0
	
	move $s0, $a0 ## store the buffer address in $s0
	move $s1, $a1 ## store the file name in $s1
	
	lw $s2, 0($a0) ## store the num of rows in $s2
	lw $s3, 4($a0) ## store the num of cols in $s3
	
	mul $s5, $s2, $s3 ## num of elements in the matrix
	
	addiu $t1, $s3, -1 ## store num of cols - 1 in $t1
	li $t9, 4 ## store 4 in $t9
	
	move $t3, $0 ## initialize row counter
	move $t4, $0 ## initialize col counter
	move $t5, $0 ## initialize base address to 0
	move $t8, $0 ## initalize $t8 to zero
	
	move $t6, $0
	move $t2, $0
	move $s4, $0
	
	move $t0, $sp ## store sp in $t0
	move $t7, $sp
	
	iter_arr_row6:
		##addi $t3, $s2, -1 ## decrement from row
		addiu $t4, $t1, 0
		iter_arr_col6:
			mult $s3, $t3 ## j * col count
			mflo $t5
			addiu $s4, $s4, 1
			addu $t5, $t5, $t4 ## (j * col count) + i
			mult $t5, $t9 ## 4 * (j * col count) + i
			mflo $t5
			addu $t5, $t5, $s0
			
			lw $t8, 8($t5) ## load the element at the address
			addu $t6, $t2, $s4
			addiu $sp, $sp, -4
			sw $t8, 0($sp)
			addiu $t6, $t6, 4
			
			beq $t4, $0, end_iter_col6
			addiu $t4, $t4, -1 ## increment col counter j
			addu $t6, $t2, $s4
			j iter_arr_col6
			
		end_iter_col6:
			addu $s4, $s4, $t5
			addu $t6, $t6, $t4
		 	beq $t3, $s2, end_iter_row6
		 	addu $t2, $t2, $t4
			addiu $t3, $t3, 1 ## increment row counter i
			j iter_arr_row6
			
		end_iter_row6:
			j done6
			
	done6: 
		sw $s2, 0($a0) ## store the num of rows as the first element of the buffer
		sw $s3, 4($a0) ## store the num of cols as the second element of the buffer
		
		addiu $a0, $a0, 8
		
		move $t1, $0 ## initialize counter to 0
		move $t5, $0 ## initialize element to 0
		bufferStoreLoop6:
			addiu $t0, $t0, -4 ## decrement the stack
			lw $t5, 0($t0) ## get element from the stack
			sw $t5, 0($a0) ## store element in the buffer
			addiu $a0, $a0, 4 ## increment the buffer
			
			addiu $t1, $t1, 1
			beq $t1, $s5, doneBufferLoop6 ## end loop if counter equals num of elements in the matrix
			j bufferStoreLoop6
		
		doneBufferLoop6:
			mul $t9, $s5, $t9 ## multiply num of elements in the matrix by 4
			##add $sp, $sp, $t9 ## restore the stack
			move $sp, $t7 ## restore the stack
			
			move $a0, $s1 ## store file name in $a0
			move $a1, $s0 ## store buffer in $a1
			
			jal write_file
			
			lw $ra, 0($sp)
			lw $s0, 4($sp)
			lw $s1, 8($sp)
			lw $s2, 12($sp)
			lw $s3, 16($sp)
			lw $s4, 20($sp)
			lw $s5, 24($sp)
			addi $sp, $sp, 28
  		jr $ra

.globl duplicate
duplicate:
	addi $sp, $sp, -36
	sw $ra, 0($sp)	
	sw $s0, 4($sp)	
	sw $s1, 8($sp)	
	sw $s2, 12($sp)	
	sw $s3, 16($sp)	
	sw $s4, 20($sp)	
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)
	
	move $t4, $0
	move $s6, $0
	move $t6, $0
	move $t7, $0
	move $s3, $0
	move $t8, $0
	li $t9, 4
	move $s0, $0
	move $t0, $0
	move $t5, $0
	li $t3, 101
	
	lw $s1, 0($a0)
	lw $s2, 4($a0)
	addi $a0, $a0, 8
	addiu $t1, $s2, -1
	
	move $s7, $0
	addiu $t2, $s1, -1
	
	dupLoop:
		beq $s6, $t2, endDupLoop
		move $t6, $0

		mult $s6, $s2
		mflo $t8
		mult $t8, $t9
		mflo $t8
		addu $t8, $t8, $a0
		
		addiu $t0, $s2, -1
		addiu $s7, $s6, 1
		move $t7, $0
		
		initialRowLoop:
			addiu $s5, $t4, 1
			lw $s0, 0($t8)
			sllv $s0, $s0, $t0
			addiu $s5, $s5, 1
			addu $t7, $t7, $s0
			addiu $t4, $t4, 2
			
			beq $t6, $t1, currentRowLoop
			
			addiu $t8, $t8, 4
			addiu $t0, $t0, -1
			addiu $t6, $t6, 1
			addu $t5, $t5, $s5
			j initialRowLoop
			
			currentRowLoop:
				addiu $s5, $t4, 0
				addiu $s5, $s5, 1
				addiu $t0, $s2, -1
				move $t6, $0
				
				mult $s7, $s2
				mflo $t8
				mult $t8, $t9
				mflo $t8
				addu $t8, $t8, $a0
				move $s3, $0
				
					currentRowNumber:
						addiu $s5, $t4, 0
						addiu $s5, $s5, 1
						lw $s0, 0($t8)
						addiu $t4, $t4, 2
						sllv $s0, $s0, $t0
						addiu $s5, $t4, 1
						addu $s3, $s3, $s0
						addi $t5, $t5, 4
						
						beq $t6, $t1, checkRows
						
						addiu $t8, $t8, 4
						addiu $t0, $t0, -1
						addiu $t6, $t6, 1
						addu $t5, $t5, $t4
						j currentRowNumber
						
			checkRows:
				addiu $t4, $t4, 1
				bne $t7, $s3, notEqualRow
			
			equalRow:
				addi $s5, $s5, 1
				blt $s7, $t3, changeRowIndex
				j notEqualRow
				
				changeRowIndex:
					addiu $t3, $s7, 0
			
			notEqualRow:
				addu $t4, $t4, $t5
				beq $s7, $t2, keepDupLoop
				addiu $s7, $s7, 1
				addu $s5, $s5, $t4
				j currentRowLoop
				
		keepDupLoop:
			addu $t5, $t4, $t5
			addiu $s6, $s6, 1
			j dupLoop
			
		endDupLoop: 
			addiu $s5, $t4, 1
			li $s3, 101
			addiu $t4, $t4, 1
			beq $t3, $s3, noDuplicates
			
			addiu $v0, $0, 1
			addiu $v1, $t3, 1
			
			j endDuplicate
			
		noDuplicates:
			move $v1, $0
			addiu $v0, $0, -1
		
		endDuplicate:
		 
			lw $ra, 0($sp)
			lw $s0, 4($sp)
			lw $s1, 8($sp)
			lw $s2, 12($sp)
			lw $s3, 16($sp)
			lw $s4, 20($sp)
			lw $s5, 24($sp)
			lw $s6, 28($sp)
			lw $s7, 32($sp)
			addi $sp, $sp, 36
 			jr $ra