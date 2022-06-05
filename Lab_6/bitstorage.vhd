Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity bitstorage is
	port(clk  :in std_logic ; 
		 bitin: in std_logic;
		 enout: in std_logic;
		 writein: in std_logic;
		 bitout: out std_logic);
end entity bitstorage;

architecture memlike of bitstorage is
	signal q: std_logic := '0';
begin
	process(clk,writein,bitin) is
	begin
		if (rising_edge(clk)) then
		if (writein='1') then 
			q <= bitin;
		end if;
		end if ; 
	end process;
	
	bitout <= q when enout = '0' else 'Z';
end architecture memlike;