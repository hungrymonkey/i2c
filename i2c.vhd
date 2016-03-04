library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY I2C_MASTER IS
	GENERIC(bus_clk   : INTEGER := 1;
	        sys_clk   : INTEGER := 50 );
	PORT(
		CLK 	: IN STD_LOGIC;
		RESET	: IN STD_LOGIC;
		SDA 	: INOUT STD_LOGIC;
		SCL 	: OUT STD_LOGIC
	);
END ENTITY;

ARCHITECTURE BEV OF I2C_MASTER IS 
	CONSTANT divider  :  INTEGER := (sys_clk/bus_clk)/4;
	COMPONENT shiftReg 
		PORT(
		trigger : in STD_LOGIC;
			input  : in STD_LOGIC;
			output : out STD_LOGIC
		);
	END COMPONENT;

	TYPE state IS (inactive, start, ack, wr_add, stop);
	SIGNAL pstate, nstate: state;
	SIGNAL inR, Tri : STD_LOGIC;


BEGIN
	S : shiftReg PORT map( trigger => Tri, input => inR, output => SDA);
	
	Process(CLK)
		VARIABLE count  :  INTEGER RANGE 0 TO divider*4;
		BEGIN
			IF( RESET = '1') THEN
				count :=0;
				SDA <= 'H';
				SCL <= 'H';
			ELSE
				IF( count = divider*4 -1) THEN
					count := 0;
					SCL <= NOT CLK;
				ELSE
					count := count + 1;

				END IF;

			END IF;
		END PROCESS;
END BEV;
