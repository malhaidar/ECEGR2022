--------------------------------------------------------------------------------
--
-- LAB #6 - Processor Elements
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BusMux2to1 is
	Port(	selector: in std_logic;
			In0, In1: in std_logic_vector(31 downto 0);
			Result: out std_logic_vector(31 downto 0) );
end entity BusMux2to1;

architecture selection of BusMux2to1 is
begin
	Result <= 	In0	when (selector='0')	else  
				In1 ; 
end architecture selection;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Control is
      Port(clk : in  STD_LOGIC;
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
end Control;

architecture Boss of Control is
begin
-- Add your code here
	process (opcode,funct3,funct7,clk) --  combinitional 
		begin
			case opcode is
				 when "0110011" => -- R TYPE
					case funct3 is 
						when "000" => -- ADD or SUB 
							if (funct7 ="0000000") then -- ADD
								Branch <=  "00" ; -- no branch
								MemRead <= '1' ; -- don't read 
								MemtoReg <= '0' ;  -- mem to register bank
								ALUCtrl <= "00000" ; -- add
								MemWrite <='0'; -- don't write to mem
								ALUSrc <= '0'; --register bank 
								RegWrite <= '1' ;
								ImmGen <= "00" ; -- no imm generation 
							else
								Branch <=  "00" ;
								MemRead <= '1' ; 
								MemtoReg <= '0' ; 
								ALUCtrl <= "00001" ;
								MemWrite <='0';
								ALUSrc <= '0';
								RegWrite <= '1' ;
								ImmGen <= "00" ;
							end if ;
						when "001" => --sll
								Branch <=  "00" ;
								MemRead <= '1' ; 
								MemtoReg <= '0' ; 
								ALUCtrl <= "00010" ;
								MemWrite <='0';
								ALUSrc <= '0';
								RegWrite <= '1' ;
								ImmGen <= "00" ;
						when "101" => --srl
								Branch <=  "01" ;
								MemRead <= '1' ; 
								MemtoReg <= '0' ; 
								ALUCtrl <= "00011" ;
								MemWrite <='0';
								ALUSrc <= '0';
								RegWrite <= '1' ;
								ImmGen <= "00" ;
						when "110" => -- or
								Branch <=  "01" ;
								MemRead <= '1' ; 
								MemtoReg <= '0' ; 
								ALUCtrl <= "00101" ;
								MemWrite <='0';
								ALUSrc <= '0';
								RegWrite <= '1' ;
								ImmGen <= "00" ;
						when "111" => --AND
								Branch <=  "01" ;
								MemRead <= '1' ; 
								MemtoReg <= '0' ; 
								ALUCtrl <= "00100" ;
								MemWrite <='0';
								ALUSrc <= '0';
								RegWrite <= '1' ;
								ImmGen <= "00" ;
						when others => 
								Branch <=  "00" ;
								MemRead <= '1' ; 
								MemtoReg <= '0' ; 
								ALUCtrl <= "00000" ;
								MemWrite <='0';
								ALUSrc <= '0';
								RegWrite <= '0' ;
								ImmGen <= "00" ;
					end case ;	
						 
				 when "0010011" =>	 -- I TYPE arithmetics 
					case funct3 is 
						when "000" => -- ADDI 
							
								Branch <=  "00" ; -- no branch 
								MemRead <= '1' ; 
								MemtoReg <= '0' ; 
								ALUCtrl <= "00000" ;
								MemWrite <='0';
								ALUSrc <= '1'; -- immedite 
								RegWrite <= '1' ;
								ImmGen <= "01" ; -- I type imm gen {20{0}, imm}
							
						when "001" => --slli
								Branch <=  "00" ;
								MemRead <= '1' ; 
								MemtoReg <= '0' ; 
								ALUCtrl <= "00010" ;
								MemWrite <='0';
								ALUSrc <= '1';
								RegWrite <= '1' ;
								ImmGen <= "01" ;
						when "101" => --srli
								Branch <=  "00" ;
								MemRead <= '0' ; 
								MemtoReg <= '0' ; 
								ALUCtrl <= "00011" ;
								MemWrite <='0';
								ALUSrc <= '1';
								RegWrite <= '1' ;
								ImmGen <= "01" ;
						when "110" => -- ori
								Branch <=  "00" ;
								MemRead <= '0' ; 
								MemtoReg <= '0' ; 
								ALUCtrl <= "00101" ;
								MemWrite <='0';
								ALUSrc <= '1';
								RegWrite <= '1' ;
								ImmGen <= "01" ;
						when "111" => --ANDi
								Branch <=  "00" ;
								MemRead <= '0' ; 
								MemtoReg <= '0' ; 
								ALUCtrl <= "00100" ;
								MemWrite <='0';
								ALUSrc <= '1';
								RegWrite <= '1' ;
								ImmGen <= "01" ;
						when others => 
								Branch <=  "00" ;
								MemRead <= '0' ; 
								MemtoReg <= '0' ; 
								ALUCtrl <= "00000" ;
								MemWrite <='0';
								ALUSrc <= '0';
								RegWrite <= '0' ;
								ImmGen <= "00" ;
					end case ;	
						 
				 when "0000011" => -- I type load instruction
				case funct3 is 
						when "010" => --lw
								Branch <=  "00" ;
								MemRead <= '0' ; -- active low read
								MemtoReg <= '1' ; -- 
								ALUCtrl <= "00000" ; -- add 
								MemWrite <='0';
								ALUSrc <= '1';
								RegWrite <= '1' ;
								ImmGen <= "01" ; -- 12 to 32
						when others => 
								Branch <=  "00" ;
								MemRead <= '0' ; 
								MemtoReg <= '0' ; 
								ALUCtrl <= "00000" ;
								MemWrite <='0';
								ALUSrc <= '0';
								RegWrite <= '0' ;
								ImmGen <= "00" ;
				end case ;			
					
				 when "1100011" =>  -- B type 
					case funct3 is 
						when "000" => -- beq
								Branch <=  "01" ; -- branch if equal
									-- if Branch = 01 and zero flag=0 .... branch 
								MemRead <= '1' ; 
								MemtoReg <= '0' ; 
								ALUCtrl <= "00001" ; -- sub 
								MemWrite <='0';
								ALUSrc <= '0';
								RegWrite <= '0' ;
								ImmGen <= "10" ; --branch immediate 
						when "001" => -- bne
								Branch <=  "10" ; -- branch if not equal
									-- if branch = 10 and zero flag=0
								MemRead <= '1' ; 
								MemtoReg <= '0' ; 
								ALUCtrl <= "00001" ;
								MemWrite <='0';
								ALUSrc <= '0';
								RegWrite <= '0' ;
								ImmGen <= "10" ;
						
						when others => 
								Branch <=  "00" ;
								MemRead <= '0' ; 
								MemtoReg <= '0' ; 
								ALUCtrl <= "00000" ;
								MemWrite <='0';
								ALUSrc <= '0';
								RegWrite <= '0' ;
								ImmGen <= "00" ;
					end case ; 
								
				 when "0110111" => -- U type (lui)
					Branch <=  "00" ;
					MemRead <= '1' ; 
					MemtoReg <= '0' ; 
					ALUCtrl <= "00110"; --pass second operand 
					MemWrite <='0';
					ALUSrc <= '1';
					RegWrite <= '1' ;
					ImmGen <= "11" ; -- [imm + 12*0]
				 when "0100011" => -- S type 
					case funct3 is 
						when "010" => -- sw
							Branch <=  "00" ;
							MemRead <= '1' ; 
							MemtoReg <= '0' ; 
							ALUCtrl <= "00000" ;
							MemWrite <='1';
							ALUSrc <= '1';
							RegWrite <= '0' ;
							ImmGen <= "00" ; 
						when others => 
							Branch <=  "00" ;
							MemRead <= '0' ; 
							MemtoReg <= '0' ; 
							ALUCtrl <= "00000" ;
							MemWrite <='0';
							ALUSrc <= '0';
							RegWrite <= '0' ;
							ImmGen <= "00" ;
				 	end case ; 
				 when others => 
					Branch <=  "00" ;
					MemRead <= '0' ; 
					MemtoReg <= '0' ; 
					ALUCtrl <= "00000" ;
					MemWrite <='0';
					ALUSrc <= '0';
					RegWrite <= '0' ;
					ImmGen <= "00" ;
					
			end case ;
		end process ;
end Boss;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ProgramCounter is
    Port(Reset: in std_logic;
	 Clock: in std_logic;
	 PCin: in std_logic_vector(31 downto 0);
	 PCout: out std_logic_vector(31 downto 0));
end entity ProgramCounter;

architecture executive of ProgramCounter is
begin
process(Clock,Reset)
	begin	
		if Reset='1' then -- asynch at posedge reset 
					
			PCout <="00000000010000000000000000000000"; -- 0x 00400000
		else if (rising_edge (Clock)) then 
			PCout <= PCin ; 
		end if ;
		end if ;
	end process;

end executive;
--------------------------------------------------------------------------------
