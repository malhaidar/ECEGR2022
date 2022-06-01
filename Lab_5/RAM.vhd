library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;


entity RAM is
Port(	
	Reset:	in std_logic;
	Clock:	in std_logic;
	OE:		in std_logic; -- Output enable 
	WE:		in std_logic; -- write enable
	Address:   in std_logic_vector(29 downto 0);
	DataIn:    in std_logic_vector(31 downto 0);
	DataOut:   out std_logic_vector(31 downto 0)
	);

end RAM;

architecture Behavioral of RAM is

type RAM_ARRAY is array (0 to 2**10 ) of std_logic_vector (31 downto 0);

signal RAM_data: RAM_ARRAY ;


	
begin
process(Clock,Reset)
	begin
		--if(falling_edge(Clock)) then
			if (rising_edge (Reset)) then --ASynchronous reset
				RAM_data <=(x"00000000",x"00000000",x"00000000",x"00000000",
								x"00000000",x"00000000",x"00000000",x"00000000",
								x"00000000",x"00000000",x"00000000",x"00000000",
								x"00000000",x"00000000",x"00000000",x"00000000",
								x"00000000",x"00000000",x"00000000",x"00000000",
								x"00000000",x"00000000",x"00000000",x"00000000",
								x"00000000",x"00000000",x"00000000",x"00000000",
								x"00000000",x"00000000",x"00000000",x"00000000",
								
								x"00000000",x"00000000",x"00000000",x"00000000",
								x"00000000",x"00000000",x"00000000",x"00000000",
								x"00000000",x"00000000",x"00000000",x"00000000",
								x"00000000",x"00000000",x"00000000",x"00000000",
								x"00000000",x"00000000",x"00000000",x"00000000",
								x"00000000",x"00000000",x"00000000",x"00000000",
								x"00000000",x"00000000",x"00000000",x"00000000",
								x"00000000",x"00000000",x"00000000",x"00000000",
								
								x"00000000",x"00000000",x"00000000",x"00000000",
								x"00000000",x"00000000",x"00000000",x"00000000",
								x"00000000",x"00000000",x"00000000",x"00000000",
								x"00000000",x"00000000",x"00000000",x"00000000",
								x"00000000",x"00000000",x"00000000",x"00000000",
								x"00000000",x"00000000",x"00000000",x"00000000",
								x"00000000",x"00000000",x"00000000",x"00000000",
								x"00000000",x"00000000",x"00000000",x"00000000",
								
								x"00000000",x"00000000",x"00000000",x"00000000",
								x"00000000",x"00000000",x"00000000",x"00000000",
								x"00000000",x"00000000",x"00000000",x"00000000",
								x"00000000",x"00000000",x"00000000",x"00000000",
								x"00000000",x"00000000",x"00000000",x"00000000",
								x"00000000",x"00000000",x"00000000",x"00000000",
								x"00000000",x"00000000",x"00000000",x"00000000",
								x"00000000",x"00000000",x"00000000",x"00000000",
								others => (others=>'X')
								); 
	
			else if(falling_edge(Clock)) then
				if(WE='1') then -- when write enable = 1, 
					RAM_data(to_integer(unsigned(Address))) <= DataIn;
				end if;
				
				
			end if;
		end if ;
	end process; 
process(Address,OE) --Asynch read
begin
	if (OE='0') then
			DataOut <= RAM_data(to_integer(unsigned(Address)));
	end if ; 

end process ;

	end Behavioral;

