Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity adder_subtracter is
	port(	datain_a: in std_logic_vector(31 downto 0);
		datain_b: in std_logic_vector(31 downto 0);
		add_sub: in std_logic;
		dataout: out std_logic_vector(31 downto 0);
		co: out std_logic);
end entity adder_subtracter;

architecture calc of adder_subtracter is
	component fulladder
		port (a : in std_logic;
        	  b : in std_logic;
        	  cin : in std_logic;
        	  sum : out std_logic;
        	  carry : out std_logic
	         );
	end component;
	
	signal tempB: std_logic_vector(31 downto 0);
	signal C: std_logic_vector(32 downto 0);

begin

	C(0) <= add_sub;
	co <= C(32);

	with add_sub select
		tempB <= datain_b when '0',
			not datain_b when others;

	adder0: fulladder PORT MAP (datain_a(0), tempB(0), C(0), dataout(0), C(1));
	genAdders: for i in 31 downto 1 generate
	adderi: fulladder PORT MAP (datain_a(i), tempB(i), C(i), dataout(i), C(i+1));
	end generate;

end architecture calc;
