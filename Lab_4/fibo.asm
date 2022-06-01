

.eqv	n	10	# Largest n



	.data
string_print:	.asciz " fibonacci number is  "
newline:	.asciz "\n"

	.text
	li a0, 0		
	li s0, 0		
	li s1, n	
	
main:
	bgt s0, s1, exit_code 	
	
	mv a0, s0		 
	jal FIB		
	mv s2, a0		
	
	mv a0, s0		# n 
	li a7, 1
	ecall
	
	la a0, string_print 	
	li a7, 4
	ecall
	
	mv a0, s2		
	li a7, 1
	ecall
	
	la a0, newline	
	li a7, 4
	ecall

	addi s0, s0, 1		
	j main
	
exit_code:			
	li a7, 10
	ecall
	
FIB:

	beqz a0, n_zero	
	addi t0, a0, -1 	
	beqz t0, n_one		# if (n=1)
	
	

	addi sp, sp, -16	
	sw a0, 0(sp)		
	sw ra, 8(sp)		
	
	addi a0, a0, -1		
	jal FIB		
	
	lw t0, 0(sp)		
	sw a0, 0(sp)		
	addi a0, t0, -2		
	jal FIB		
	
	lw t0, 0(sp)		
	add a0, a0, t0		
	
	lw ra, 8(sp)		
	addi sp, sp, 16		 
	
	
	
n_zero:
	ret
######################################################################
n_one:
	ret