Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register32 is
	port(clk :in std_logic ; 
		datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
end entity register32;

architecture biggermem of register32 is
	-- hint: you'll want to put register8 as a component here 
	component register8
		port(clk :in std_logic ;
		datain: in std_logic_vector(7 downto 0);
			enout:  in std_logic;
	     		writein: in std_logic;
	     		dataout: out std_logic_vector(7 downto 0));
	end component;
	
	signal enableout: std_logic_vector(2 downto 0);
	signal writin: std_logic_vector(2 downto 0);
	signal enablingout: std_logic_vector(3 downto 0);
	signal writingin: std_logic_vector(3 downto 0);
	
begin

	enableout <= enout32 & enout16 & enout8;
	writin <= writein32 & writein16 & writein8;

	with enableout select
-- note for out enable set the required bit (0 not 1)
		enablingout <= "1110" when "110",
				"1100" when "101",
				"0000" when "011",
				"1111" when others;
	with writin select
		
		writingin <= "0001" when "001",
				"0011" when "010",
				"1111" when "100",
				"0000" when others;

	reg1: register8 PORT MAP (clk,datain(31 downto 24), enablingout(3), writingin(3), dataout(31 downto 24));
	reg2: register8 PORT MAP (clk,datain(23 downto 16), enablingout(2), writingin(2), dataout(23 downto 16));
	reg3: register8 PORT MAP (clk,datain(15 downto 8), enablingout(1), writingin(1), dataout(15 downto 8));
	reg4: register8 PORT MAP (clk,datain(7 downto 0), enablingout(0), writingin(0), dataout(7 downto 0));

end architecture biggermem;
