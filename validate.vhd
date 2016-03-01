library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity validate is
    Port ( sdaIn   : in STD_LOGIC;
           sclIn   : in STD_LOGIC;
           sdaOut  : out STD_LOGIC;
           start   : out STD_LOGIC;
           stop    : out STD_LOGIC
        );
end validate;
architecture lab3 of validate is begin
	process(sdaIn,sclIn) begin
		if( falling_edge(sdaIn)) and ( sclIn = '1') and ( not sclIn'EVENT) then
			start <= '1';
			stop <=  '0';
			sdaOut <= sdaIn;

		elsif ( rising_edge(sdaIn)) and ( sclIn = '1') and ( not sclIn'EVENT) then
			stop <= '1'; 
			start <= '0';
			sdaOut <= sdaIn;
		else
			stop <= '0';
			start <= '0';
			sdaOut <= sdaIn;

		end if;
	end process;
end lab3;

