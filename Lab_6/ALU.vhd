
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--------------------------------------------
--ALU CONTROL[2:0]	||		FUNC		||
--------------------||	----------------||
--		000			||		ADD			||
--------------------||------------------||
--		001			||		SUB			||
--------------------||------------------||
--		010			||		Shift left	||
--------------------||------------------||
--		011			||		Shift right	||
--------------------||------------------||
--		100			||		AND			||
--------------------||------------------||
--		101			||		OR			||
--------------------||------------------||
--		110			||		pass 		||
----------------------------------------||


entity ALU is
    Port ( DataIn1 : in  STD_LOGIC_VECTOR (31 downto 0);
           DataIn2 : in  STD_LOGIC_VECTOR (31 downto 0);
           ALUCtrl : in  STD_LOGIC_VECTOR (4 downto 0);
           Zero : out  STD_LOGIC;
           ALUResult : out  STD_LOGIC_VECTOR (31 downto 0));
end entity ALU;

architecture calc of ALU is

	component adder_subtracter is
		port(	
			datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic
			);
	end component;
	
	component shift_register is
		port(	
			datain: in std_logic_vector(31 downto 0);
			dir: in std_logic; --shift left (0)
			shamt:	in std_logic_vector(4 downto 0);
			dataout: out std_logic_vector(31 downto 0)
			);
	end component;
	
	
	signal mux_in_0: std_logic_vector(31 downto 0);
	signal mux_in_1: std_logic_vector(31 downto 0);
	signal mux_in_2: std_logic_vector(31 downto 0);
	signal mux_in_3: std_logic_vector(31 downto 0);
	
	signal result: std_logic_vector(31 downto 0);
	

begin

------------------------------------------------------------------------------	
   adder_subtracter_inst:adder_subtracter PORT MAP (	
		DataIn1,
		DataIn2,
		ALUCtrl(0),
		mux_in_0
		
		);
-------------------------------------------------------------------------------		

	shift_register_inst: shift_register PORT MAP (	
		DataIn1,
		ALUCtrl(0),
		DataIn2(4 downto 0),
		mux_in_1
	);

	mux_in_2 <= DataIn1 AND DataIn2 ;
-------------------------------------------------------------------------------		
	mux_in_3 <= DataIn1 OR DataIn2 ;
-------------------------------------------------------------------------------			

----------------------------- 8 to 1 MUX -----------------------------------
	result<= mux_in_0 when (ALUCtrl(2 downto 0)="000") else --ADDITION
					mux_in_0 when (ALUCtrl(2 downto 0)="001")  else --SUB
					mux_in_1 when (ALUCtrl(2 downto 0)="010") else
					mux_in_1 when (ALUCtrl(2 downto 0)="011") else
					mux_in_2 when (ALUCtrl(2 downto 0)="100") else
					mux_in_3 when (ALUCtrl(2 downto 0)="101") else
					DataIn2	when  (ALUCtrl(2 downto 0)="110") else 
					"11111111111111111111111111111111";
-------------------------OUTPUTS ----------------------------------------
ALUResult <= result ; 
Zero <= 	'1' when ( result="00000000000000000000000000000000" ) else
			'0';

end architecture calc;


