
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

ENTITY ALU_tb IS
END ALU_tb;
 
ARCHITECTURE behavior OF ALU_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         DataIn1 : IN  std_logic_vector(31 downto 0);
         DataIn2 : IN  std_logic_vector(31 downto 0);
         ALUCtrl : IN  std_logic_vector(4 downto 0);
         Zero : OUT  std_logic;
         ALUResult : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal DataIn1 : std_logic_vector(31 downto 0) := (others => '0');
   signal DataIn2 : std_logic_vector(31 downto 0) := (others => '0');
   signal ALUCtrl : std_logic_vector(4 downto 0) := (others => '0');

 	--Outputs
   signal Zero : std_logic;
   signal ALUResult : std_logic_vector(31 downto 0);
 
 
  
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          DataIn1 => DataIn1,
          DataIn2 => DataIn2,
          ALUCtrl => ALUCtrl,
          Zero => Zero,
          ALUResult => ALUResult
        );

  
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      

      -- input stimulus
			DataIn1 <= "00000000000000000000000000000111"; -- 7
			DataIn2 <= "00000000000000000000000000000010"; -- 2
   		
			wait for 10 ns;
		--	report "First operand. A \n = " & integer'image(to_integer(unsigned(DataIn1)));
		--	report "Second operand. B \n = " & integer'image(to_integer(unsigned(DataIn2)));

			ALUCtrl<="00000" ; --add  ALUresult = 9 and zeroflag=0
			wait for 10 ns;	
		
			ALUCtrl<="00001" ; --sub ALUresult = 5 and zero flag = 0  
			wait for 10 ns;

			
			ALUCtrl<="00010" ; --shift left result "00000000000000000000000000011100"  
			wait for 10 ns;
			
			ALUCtrl<="00100" ; --and  ALUresult = "00000000000000000000000000000010"  and zeroflag=0
			wait for 10 ns;	
			
			ALUCtrl<="00101" ; --or ALUresult = "000000000000000000000000000111"  and zero flag = 0  
			wait for 10 ns;

      wait;
   end process;

END;
