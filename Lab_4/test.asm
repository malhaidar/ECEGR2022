
.eqv	print_integer	1	# System call: print_int
.eqv	print_string	4	# System call: print_string
.eqv	exit		10	# Sysstem call: exit

	.data

result:	         .asciz "Result is :"
newline:	.asciz " \n"

	.text
addi t1,x0,100 , #t1=100 
addi t2,x0,250,  #t1=100

########### ADD ###############
la a0,result
li a7,print_string
ecall 

add a0,t1,t2 

li a7, print_integer, 
ecall 

la a0,newline
li a7,print_string
ecall

############# SUB ############
la a0,result
li a7,print_string
ecall 

sub a0,t1,t2 

li a7, print_integer, 
ecall 

la a0,newline
li a7,print_string
ecall
############ AND ##############

la a0,result
li a7,print_string
ecall 

and  a0,t1,t2 

li a7, print_integer, 
ecall 

la a0,newline
li a7,print_string
ecall
##############################
########### OR ###############
la a0,result
li a7,print_string
ecall 

or a0,t1,t2 

li a7, print_integer, 
ecall 

la a0,newline
li a7,print_string
ecall

############# SLL ############
la a0,result
li a7,print_string
ecall 

slli  a0,t1,5 

li a7, print_integer, 
ecall 

la a0,newline
li a7,print_string
ecall
############ SRL ##############

la a0,result
li a7,print_string
ecall 

srli  a0,t1,3

li a7, print_integer, 
ecall 

la a0,newline
li a7,print_string
ecall




