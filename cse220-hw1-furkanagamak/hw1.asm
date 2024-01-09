################# Furkan Agamak #################
################# FAGAMAK #################
################# 114528166 #################
################# DON'T FORGET TO ADD GITHUB USERNAME IN BRIGHTSPACE #################

################# DO NOT CHANGE THE DATA SECTION #################

.data
arg1_addr: .word 0
arg2_addr: .word 0
num_args: .word 0
invalid_arg_msg: .asciiz "Invalid Arguments\n"
args_err_msg: .asciiz "Program requires exactly two arguments\n"
invalid_hand_msg: .asciiz "Loot Hand Invalid\n"
newline: .asciiz "\n"
zero: .asciiz "Zero\n"
nan: .asciiz "NaN\n"
inf_pos: .asciiz "+Inf\n"
inf_neg: .asciiz "-Inf\n"
mantissa: .asciiz ""

.text
.globl hw_main
hw_main:
    sw $a0, num_args
    sw $a1, arg1_addr
    addi $t0, $a1, 2
    sw $t0, arg2_addr
    j start_coding_here

start_coding_here:
    lw $t1, num_args
    li $t2, 2
    beq $t1, $t2, validateArgument1
    
    j args_error

validateArgument1:
	lw $t3, arg1_addr
	lb $t4, 1($t3)
	beqz $t4, validateArgument1Characters
	
	j invalid_arg
    
validateArgument1Characters:
	lb $s0, 0($t3)
	
	li $s1, 'D'
	beq $s0, $s1, stringToDecimal
	
	li $s1, 'O'
	beq $s0, $s1, convertHexadecimal
	
	li $s1, 'S'
	beq $s0, $s1, convertHexadecimal
	
	li $s1, 'T'
	beq $s0, $s1, convertHexadecimal
	
	li $s1, 'E'
	beq $s0, $s1, convertHexadecimal
	
	li $s1, 'H'
	beq $s0, $s1, convertHexadecimal
	
	li $s1, 'U'
	beq $s0, $s1, convertHexadecimal
	
	li $s1, 'F'
	beq $s0, $s1, convertForPart4
	
	li $s1, 'L'
	beq $s0, $s1, verifyHand
	
	j invalid_arg

stringToDecimal:
	lw $t5, arg2_addr
	li $t6, 0
	li $s2, '0'
	li $s3, '1'
	
	loop: 
		lb $t7, 0($t5)
		beqz $t7, done
		beq $t7, $s2, continue
		beq $t7, $s3, continue
		j invalid_arg
		continue:
			addi $t5, $t5, 1
			addi $t6, $t6, 1
			j loop
		
	done:
		li $s4, 32
		li $s5, 1
		blt $t6, $s5 invalid_arg
		bgt $t6, $s4, invalid_arg
		
		j conversionLoop
		
	conversionLoop:
		lw $t8, arg2_addr
		li $s7, 0
		li $s2, 0
		li $s3, 0
		loop2:
			lb $t9, 0($t8)
			beqz $t9, done2
			addi $s2, $t9, -48
			sll $s7, $s7, 1
			add $s7, $s7, $s2
			addi $t8, $t8, 1
			j loop2
			
		done2:
			li $v0, 1
			move $a0, $s7
			syscall
			
			li $v0, 10
			syscall

opcode:
	srl $t9, $t9, 26
	
	move $a0, $t9
	li $v0, 1
	syscall
	j terminate_prog
	
rsRegister:
	srl $t9, $t9, 21
	andi $t9, $t9, 31
	
	move $a0, $t9
	li $v0, 1
	syscall
	j terminate_prog

rtRegister:
	srl $t9, $t9, 16
	andi $t9, $t9, 31
	
	move $a0, $t9
	li $v0, 1
	syscall
	j terminate_prog
	
rdRegister:
	srl $t9, $t9, 11
	andi $t9, $t9, 31
	
	move $a0, $t9
	li $v0, 1
	syscall
	j terminate_prog
	
shamt:
	sll $t9, $t9, 21
	sra $t9, $t9, 27
	
	move $a0, $t9
	li $v0, 1
	syscall
	j terminate_prog
	
funct:
	sll $t9, $t9, 26
	srl $t9, $t9, 26
	
	move $a0, $t9
	li $v0, 1
	syscall
	j terminate_prog
	
convertHexadecimal:
	li $s1, '9'
	li $s2, 'A'
	li $s3, 'F'
	li $s4, 'a'
	li $s5, 'f'
	li $t2, '0'
	li $t3, 'x' 
	
	li $t5, 0
	li $s6, 0
	lw $t4, arg2_addr
	
	lb $t5, 0($t4)
	bne $t5, $t2, invalid_arg
	
	addi $t4, $t4, 1
	lb $s6, 0($t4)
	bne $s6, $t3, invalid_arg
	
	addi $t4, $t4, 1
	
	j afterPart4
	convertForPart4:
	li $s1, '9'
	li $s2, 'A'
	li $s3, 'F'
	li $s4, 'a'
	li $s5, 'f'
	li $t2, '0'
	li $t3, 'x'
	lw $t4, arg2_addr
	afterPart4:
	
	li $t6, 0
	li $t7, 0
	li $t8, 0
	li $t9, 0
	
	loop3:
		lb $t6, 0($t4)
		beqz $t6, done3
		addi $t7, $t7, 1
		
		blt $t6, $t2, invalid_arg
		bgt $t6, $s1, verifySmall
		
		addi $t8, $t6, -48
		sll $t9, $t9, 4
		add $t9, $t9, $t8
		addi $t4, $t4, 1
		j loop3
		
		verifySmall:
			bgt $t6, $s5, invalid_arg
			blt $t6, $s4, verifyBig
			
			addi $t8, $t6, -87
			sll $t9, $t9, 4
			add $t9, $t9, $t8
			addi $t4, $t4, 1
			j loop3
		
		verifyBig:
			blt $t6, $s2, invalid_arg
			bgt $t6, $s3, invalid_arg
			
			addi $t8, $t6, -55
			sll $t9, $t9, 4
			add $t9, $t9, $t8
			addi $t4, $t4, 1
			j loop3		
	done3:
		li $t1, 8
		bgt $t7, $t1, invalid_arg
		
		lw $t3, arg1_addr
		lb $s0, 0($t3)
		
		li $s1, 'O'
		beq $s0, $s1, opcode
		
		li $s1, 'S'
		beq $s0, $s1, rsRegister
		
		li $s1, 'T'
		beq $s0, $s1, rtRegister
		
		li $s1, 'E'
		beq $s0, $s1, rdRegister
		
		li $s1, 'H'
		beq $s0, $s1, shamt
		
		li $s1, 'U'
		beq $s0, $s1, funct
		
		li $s1, 'F'
		beq $s0, $s1, hexToFloatingPoint
		
hexToFloatingPoint:
		
	checkFloatingPoint:
		li $t0, 8
		blt $t7, $t1, invalid_arg
		li $t1, 0x00000000
		li $t2, 0x80000000
		li $t3, 0xFF800000
		li $t4, 0x7F800000
		li $t5, 0x7f800001
		li $t6, 0x7FFFFFFF 
		li $t7, 0xff800001 
		li $t8, 0xFFFFFFFF
		
		beq $t9, $t1, printZero
		beq $t9, $t2, printZero
		beq $t9, $t3, negInf
		beq $t9, $t4, posInf
		bge $t9, $t5, checkLessThan0x7FFFFFFF
		bge $t9, $t7, checkLessThan0xFFFFFFFF
		
		j floatingConversionStep
		checkLessThan0x7FFFFFFF:
			ble $t9, $t6, printNan
			j floatingConversionStep
		
		checkLessThan0xFFFFFFFF:
			ble $t9, $t8, printNan
			j floatingConversionStep
		
	floatingConversionStep:
		storeExponent:
			move $s5, $t9
			sll $s5, $t9, 1 
			srl $s5, $s5, 24
			addi $s5, $s5, -127
			
			move $a0, $s5
			
		storeMantissa:
			li $t0, '.'
			li $t2, '-'
			li $s0, 0 
			li $s1, 1 
			li $s2, 31 
			li $s3, 9 
			li $s4, '0'
			li $s5, '1'
			li $s6, 0
			srl, $s7, $t9, 31 
			la $t4, mantissa
			move $t1, $t9 
			
			beq $s7, $s0, setSignPositive
			beq $s7, $s1, setSignNegative
			
			setSignPositive:
				sb $s5, 0($t4)
				sb $t0, 1($t4)
				addi $t4, $t4, 2
				j loop4
				
			setSignNegative:
				sb $t2, 0($t4)
				sb $s5, 1($t4)
				sb $t0, 2($t4)
				addi $t4, $t4, 3
				j loop4
			
			loop4:
				li $a3, 23
				sllv $t1, $t9, $s3 
				addi $s3, $s3, 1
				srlv $t1, $t1, $s2 
				beq $s6, $a3, done4
				beq $t1, $s0, storeZero
				beq $t1, $s1, storeOne
				storeZero:
					sb $s4, 0($t4)
					addi $t4, $t4, 1
					addi $s6, $s6, 1 
					j loop4
				storeOne:
					sb $s5, 0($t4) 
					addi $t4, $t4, 1
					addi $s6, $s6, 1
					j loop4
			done4:
				la $a1, mantissa
				j terminate_prog
	
verifyHand:
	li $s1, '3'
	li $s2, '8'
	li $s3, '1'
	li $s4, '4'
	li $t3, 'M'
	li $t4, 'P'
	lw $t5, arg2_addr
	
	li $t7, 0
	li $t8, 0
	li $t9, 0
	
	loop5:
		lb $t6, 0($t5)
		addi $t7, $t7, 1
		beqz $t6, done5
		beq $t6, $t3, merchant
		beq $t6, $t4, pirate
		j invalid_hand
		
		merchant:
			addi $t5, $t5, 1
			lb $t6, 0($t5)
			addi $t7, $t7, 1
			blt $t6, $s1, invalid_hand
			bgt $t6, $s2, invalid_hand
			addi $t8, $t8, 1
			addi $t5, $t5, 1
			j loop5
		
		pirate:
			addi $t5, $t5, 1
			lb $t6, 0($t5)
			addi $t7, $t7, 1
			blt $t6, $s3, invalid_hand
			bgt $t6, $s4, invalid_hand
			addi $t9, $t9, 1
			addi $t5, $t5, 1
			j loop5
		
		done5:
			li $s6, 31
			sll $t8, $t8, 3
			or $t8, $t8, $t9
		
			bgt $t8, $s6, signExtend
		
			move $a0, $t8
			li $v0, 1
			syscall
			j terminate_prog
		
		signExtend:
			li $s7, 0xFFFFFFE0
			or $t8, $t8, $s7
			move $a0, $t8
			li $v0, 1
			syscall
			j terminate_prog

printZero:
	li $v0, 4
    la $a0, zero
    syscall
    
    li $v0, 10
    syscall
    
negInf:
	li $v0, 4
    la $a0, inf_neg
    syscall
    
    li $v0, 10
    syscall
    
posInf:
	li $v0, 4
    la $a0, inf_pos
    syscall
    
    li $v0, 10
    syscall

printNan:
	li $v0, 4
    la $a0, nan
    syscall
    
    li $v0, 10
    syscall

invalid_hand:
	li $v0, 4
    la $a0, invalid_hand_msg
    syscall
    
    li $v0, 10
    syscall
    
invalid_arg:
	li $v0, 4
    la $a0, invalid_arg_msg
    syscall
    
    li $v0, 10
    syscall
	
args_error:
	li $v0, 4
    la $a0, args_err_msg
    syscall
    
    li $v0, 10
    syscall
   
terminate_prog:
	li $v0, 10
    syscall