Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity shift_register is
	port(	datain: in std_logic_vector(31 downto 0);
	   	dir: in std_logic;
		shamt:	in std_logic_vector(4 downto 0);
		dataout: out std_logic_vector(31 downto 0));
end entity shift_register;

architecture shifter of shift_register is
	
begin

	with dir & shamt (1 downto 0) select
		dataout <= datain(30 downto 0) & '0' when "001",
			'0' & datain(31 downto 1) when "101",
			datain(29 downto 0) & "00" when "010",
			"00" & datain(31 downto 2) when "110",
			datain(28 downto 0) & "000" when "011",
			"000" & datain(31 downto 3) when "111",
			datain when others;

end architecture shifter;