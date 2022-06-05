Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register8 is
	port(clk : in std_logic ; 
		datain: in std_logic_vector(7 downto 0);
	     enout:  in std_logic;
	     writein: in std_logic;
	     dataout: out std_logic_vector(7 downto 0));
end entity register8;

architecture memmy of register8 is
	component bitstorage
		port(clk :in std_logic;
			bitin: in std_logic;
		 	 enout: in std_logic;
		 	 writein: in std_logic;
		 	 bitout: out std_logic);
	end component;
begin
	bit_1: bitstorage PORT MAP (clk,datain(0), enout, writein, dataout(0));
	bit_2: bitstorage PORT MAP (clk,datain(1), enout, writein, dataout(1));
	bit_3: bitstorage PORT MAP (clk,datain(2), enout, writein, dataout(2));
	bit_4: bitstorage PORT MAP (clk,datain(3), enout, writein, dataout(3));
	bit_5: bitstorage PORT MAP (clk,datain(4), enout, writein, dataout(4));
	bit_6: bitstorage PORT MAP (clk,datain(5), enout, writein, dataout(5));
	bit_7: bitstorage PORT MAP (clk,datain(6), enout, writein, dataout(6));
	bit_8: bitstorage PORT MAP (clk,datain(7), enout, writein, dataout(7));

end architecture memmy;