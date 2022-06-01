


.data 
.string "Please enter temperature in Fahrenheit \n"
.string "Degree in celsius \n" #0x100100029
.string "Degree in kelvin \n" #0x10010003d
.string "\n" #0x10010004e

.text 

main:

######### ASK user for temperature #########
li a0,0x10010000 # ADDRESS of string 
li a7,4
ecall
############################################
########### READ user input ################

li a7,6 #read float number at fa0
ecall
fmv.s f11,f10 , # to save user input 
############################################

jal conv_to_celsius

jal conv_to_kelvin 


li a7,10
ecall #exit with code 0 for sucess


conv_to_celsius : # fa0= user input 
	
	li t1,0x3F0E38E4,
	fmv.w.x x1,f6 , # move f1 <--- t1 (f1=5/9)
	
	li t1,0x418e38e4,
	fmv.w.x x2,f6 , # move f2 <--- t1 (f1=32*5/9)
	
	# f10= f10*(32*5/9)-(5/9) 
	fmsub.s f10,f11,f1,f2 
	
	## print the result 
	li a0,0x10010029 # ADDRESS of string 
	li a7,4
	ecall
	
	li a7,2 #read float number at fa0
	ecall
	
	## new line print
	li a0,0x1001004e# ADDRESS of string 
	li a7,4
	ecall
	
	ret 
	

conv_to_kelvin :

	li t1,0x43889333,
	fmv.w.x x1,f6 , # move f1 <--- t1 (f1=273.15)
	
	
	
	# f10= f10+2733.15 
	fadd.s f10,f10,f1, 
	
	## print the result 
	li a0,0x1001003d# ADDRESS of string 
	li a7,4
	ecall
	
	li a7,2 #read float number at fa0
	ecall
	
	## new line print
	li a0,0x1001004e# ADDRESS of string 
	li a7,4
	ecall
	
	ret 
	
