--------------------------------------------------------------------------------
--
-- LAB #6 - Processor 
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL; 
use ieee.numeric_std.all;

entity Processor is
    Port ( reset : in  std_logic;
	   clock : in  std_logic);
end Processor;

architecture holistic of Processor is
	component Control
   	     Port( clk : in  STD_LOGIC;
               opcode : in  STD_LOGIC_VECTOR (6 downto 0);
               funct3  : in  STD_LOGIC_VECTOR (2 downto 0);
               funct7  : in  STD_LOGIC_VECTOR (6 downto 0);
               Branch : out  STD_LOGIC_VECTOR(1 downto 0);
               MemRead : out  STD_LOGIC;
               MemtoReg : out  STD_LOGIC;
               ALUCtrl : out  STD_LOGIC_VECTOR(4 downto 0);
               MemWrite : out  STD_LOGIC;
               ALUSrc : out  STD_LOGIC;
               RegWrite : out  STD_LOGIC;
               ImmGen : out STD_LOGIC_VECTOR(1 downto 0));
	end component;

	component ALU
		Port(DataIn1: in std_logic_vector(31 downto 0);
		     DataIn2: in std_logic_vector(31 downto 0);
		     ALUCtrl: in std_logic_vector(4 downto 0);
		     Zero: out std_logic;
		     ALUResult: out std_logic_vector(31 downto 0) );
	end component;
	
	component Registers
	    Port(clk: in std_logic;
		ReadReg1: in std_logic_vector(4 downto 0); 
                 ReadReg2: in std_logic_vector(4 downto 0); 
                 WriteReg: in std_logic_vector(4 downto 0);
		 WriteData: in std_logic_vector(31 downto 0);
		 WriteCmd: in std_logic;
		 ReadData1: out std_logic_vector(31 downto 0);
		 ReadData2: out std_logic_vector(31 downto 0));
	end component;

	component InstructionRAM
    	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;

	component RAM 
	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;	 
		 OE:      in std_logic;
		 WE:      in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataIn:  in std_logic_vector(31 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;
	
	component BusMux2to1
		Port(selector: in std_logic;
		     In0, In1: in std_logic_vector(31 downto 0);
		     Result: out std_logic_vector(31 downto 0) );
	end component;
	
	component ProgramCounter
	    Port(Reset: in std_logic;
		 Clock: in std_logic;
		 PCin: in std_logic_vector(31 downto 0);
		 PCout: out std_logic_vector(31 downto 0));
	end component;

	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;
	
	--- Signals	
	-- program counter adder Instance 
	signal pcplus4,jump_addr : std_logic_vector (31 downto 0) ;
	-- RAM 
	signal ram_out : std_logic_vector (31 downto 0) ; 
	-- PC 
	signal	PCout: std_logic_vector(31 downto 0);
	-- instruction memory 
	signal instruction: std_logic_vector(31 downto 0);
	-- Controller 
	signal MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite: std_logic;
	signal Branch : STD_LOGIC_VECTOR(1 downto 0);
	signal ALUCtrl: STD_LOGIC_VECTOR(4 downto 0);
	signal ImmGen : STD_LOGIC_VECTOR(1 downto 0);
	
	-- ALU mux 
	signal aluOperand_two: std_logic_vector (31 downto 0) ;
	-- reg file mux 
	signal write_data :std_logic_vector (31 downto 0) ;
	-- ALU
	signal Zero:  std_logic;
	signal ALUResult:  std_logic_vector(31 downto 0) ;
	-- REG file 
	signal ReadData1:  std_logic_vector(31 downto 0);
	signal ReadData2:  std_logic_vector(31 downto 0);
	
	-- imm gen 
	signal gen_imm:  std_logic_vector(31 downto 0);
	signal PCin:  std_logic_vector(31 downto 0);
	signal pc_select : std_logic:='0' ; 
begin

--------------------------------------------
--Branch			||		FUNC		||
--------------------||	----------------||


--		01			||		bne			||
--------------------||------------------||
--		10			||		bneq		||
--------------------||------------------||
------------------------------------------

with Branch & Zero select
		pc_select <= 	'1' when "011", -- bne and zero flag is one 
						'1' when "100", -- bnq and zero flag isn't one
						'0' when others;
--- imm gen 
gen_imm <=	std_logic_vector(resize(signed( instruction(31 downto 25)&instruction(11 downto 7) ), 32)) when (ImmGen="00") else -- s type  
			std_logic_vector(resize(signed( instruction(31 downto 20)                          ), 32)) when (ImmGen="01") else
			std_logic_vector(resize(signed( instruction(31)&instruction(7)&instruction(30 downto 25)&instruction(11 downto 8)&'0' ), 32)) when (ImmGen="10") else
			instruction(31 downto 12)&"000000000000" ;
----------------------- write data mux Instance --------------------
	 write_data_mux:BusMux2to1 PORT MAP (pc_select,pcplus4,jump_addr,PCin);
------------------------------------------------------------------------
----------------------- ProgramCounter mux Instance --------------------
	 pc_mux:BusMux2to1 PORT MAP (MemtoReg,ALUResult,ram_out,write_data);
------------------------------------------------------------------------
----------------------- ALU source Instance --------------------
	 alusrc_mux:BusMux2to1 PORT MAP (ALUSrc,ReadData2,gen_imm,aluOperand_two);
------------------------------------------------------------------------
------------------------------- ProgramCounter Instance ---------------------------
	 ProgramCounter_inst:ProgramCounter PORT MAP (reset,clock,
	 PCin,PCout);
------------------------------------------------------------------------		 
------------------------------- ALU Instance ---------------------------
	 alu_inst:ALU PORT MAP (
	 ReadData1,aluOperand_two,ALUCtrl,Zero,ALUResult);
	 
------------------------------------------------------------------------
------------------------------- instr  memory Instance ---------------------------
	 InstructionRAM_inst:InstructionRAM PORT MAP
	 (reset,clock,PCout(31 downto 2),instruction);
------------------------------------------------------------------------
--------------------- register bank Instance ---------------------------
	 Registers_inst:Registers PORT MAP (clock,
	 instruction(19 downto 15), --- rs1  
     instruction(24 downto 20), --- rs2
	 instruction(11 downto 7), --- rd
	 write_data,
	 RegWrite, ReadData1, ReadData2);
------------------------------------------------------------------------
------------------------------- controller Instance ---------------------------
	 Control_inst:Control PORT MAP ( 
	 clock, instruction (6 downto 0) ,
	 instruction (14 downto 12 ),
	 instruction (31 downto 25 ),
	 Branch ,MemRead ,MemtoReg,ALUCtrl,
     MemWrite ,ALUSrc,RegWrite,ImmGen) ;
------------------------------------------------------------------------
------------------------------- RAM Instance ---------------------------
	 RAM_inst:RAM PORT MAP ( reset,clock,MemRead,MemWrite,
	 ALUResult(31 downto 2),ReadData2,ram_out);
------------------------------------------------------------------------
-------------------------- program counter adder Instance ---------------
	 pc_adder1:adder_subtracter PORT MAP ( 
	 PCout,"00000000000000000000000000000100",
	 '0',pcplus4 ) ;
	 --skip cout-- 
------------------------------------------------------------------------
------------------------------- imm jump adder -----------------------
	 pc_adder2:adder_subtracter PORT MAP ( 
	 PCout,gen_imm,
	 '0',jump_addr ) ;
	 --skip cout-- 
------------------------------------------------------------------------


end holistic;

