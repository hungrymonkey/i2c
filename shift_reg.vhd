library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY shiftReg IS
	PORT (
		trigger : in STD_LOGIC;
		input  : in STD_LOGIC;
		output : out STD_LOGIC
	);
END shiftReg;

architecture reg of shiftReg is 
	signal shift_reg : STD_LOGIC_VECTOR(0 TO 7);
begin

process (trigger)
begin 
	if ( trigger'event and trigger = '1') then	
		output <= shift_reg(7);
		shift_reg(7) <= shift_reg(6);
		shift_reg(6) <= shift_reg(5);	
		shift_reg(5) <= shift_reg(4);
		shift_reg(4) <= shift_reg(3);
		shift_reg(3) <= shift_reg(2);
		shift_reg(2) <= shift_reg(1);	
		shift_reg(1) <= shift_reg(0);
		shift_reg(0) <= input;
	END IF;
END PROCESS;

END reg;
