
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity Registers is
    Port(  ReadReg1:  in std_logic_vector(4 downto 0); 
         	ReadReg2:  in std_logic_vector(4 downto 0); 
         	WriteReg:  in std_logic_vector(4 downto 0);
				WriteData: in std_logic_vector(31 downto 0);
				WriteCmd:  in std_logic;
				ReadData1: out std_logic_vector(31 downto 0);
				ReadData2: out std_logic_vector(31 downto 0));
end entity Registers;


architecture Behavioral of Registers is

component register32 is
	port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
end component;


	signal mux_in_0: std_logic_vector(31 downto 0);
	signal mux_in_1: std_logic_vector(31 downto 0);
	signal mux_in_2: std_logic_vector(31 downto 0);
	signal mux_in_3: std_logic_vector(31 downto 0);
	signal mux_in_4: std_logic_vector(31 downto 0);
	signal mux_in_5: std_logic_vector(31 downto 0);
	signal mux_in_6: std_logic_vector(31 downto 0);
	signal mux_in_7: std_logic_vector(31 downto 0);
	signal mux_in_8: std_logic_vector(31 downto 0);
	signal writin: std_logic_vector(7 downto 0);

	
begin
----------------------- WRITE DECODER ---------------------------
process(WriteCmd,WriteReg)
	begin 
		if (WriteCmd='1') then
			case WriteReg is
				 when "01010" => 		writin <=  "00000001" ;
				 when "01011" =>		writin <= "00000010" ;
				 when "01100" =>		writin <= "00000100" ;
				 when "01101" => 		writin <=  "00001000" ;
				 when "01110" =>		writin <= "00010000" ;
				 when "01111" =>		writin <= "00100000" ;
				 when "10000" =>		writin <= "01000000" ; --A6
				 when "10001" =>		writin <= "10000000" ; -- A7
				 
				when others => 	writin  <= "00000000"  ;
			end case ;
		else
			writin <= "00000000" ; 
		end if ;
end process ; 

--------------------------------- OUT MUX -------------------------------
	ReadData1<= 		mux_in_1 when (ReadReg1="01010") else 
						mux_in_2 when (ReadReg1="01011") else 
						mux_in_3 when (ReadReg1="01100") else
						mux_in_4 when (ReadReg1="01101") else
						mux_in_5 when (ReadReg1="01110") else
						mux_in_6 when (ReadReg1="01111") else
						mux_in_7 when (ReadReg1="10000") else
						mux_in_8 when (ReadReg1="10001") else
						
						mux_in_0 when (ReadReg1="00000") else
						(others=>'X');
	
	ReadData2<= 		mux_in_1 when (ReadReg2="01010") else 
						mux_in_2 when (ReadReg2="01011") else 
						mux_in_3 when (ReadReg2="01100") else
						mux_in_4 when (ReadReg2="01101") else
						mux_in_5 when (ReadReg2="01110") else
						mux_in_6 when (ReadReg2="01111") else
						mux_in_7 when (ReadReg2="10000") else
						mux_in_8 when (ReadReg2="10001") else
						
						mux_in_0 when (ReadReg2="00000") else
						(others=>'X');
---------------------------------------------------------------------------						


	X0: register32 PORT MAP (WriteData,'0','1','1','0', '0', '0',mux_in_0); -- 32 output , write is disabled for X0
	
	A0: register32 PORT MAP (WriteData,'0','1','1',writin(0), '0', '0',mux_in_1);
	A1: register32 PORT MAP (WriteData,'0','1','1',writin(1), '0', '0',mux_in_2);
	A2: register32 PORT MAP (WriteData,'0','1','1',writin(2), '0', '0',mux_in_3);
	A3: register32 PORT MAP (WriteData,'0','1','1',writin(3), '0', '0',mux_in_4);	
	A4: register32 PORT MAP (WriteData,'0','1','1',writin(4), '0', '0',mux_in_5);
	A5: register32 PORT MAP (WriteData,'0','1','1',writin(5), '0', '0',mux_in_6);
	A6: register32 PORT MAP (WriteData,'0','1','1',writin(6), '0', '0',mux_in_7);
	A7: register32 PORT MAP (WriteData,'0','1','1',writin(7), '0', '0',mux_in_8);





end Behavioral;

