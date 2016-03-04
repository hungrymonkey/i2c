library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;


ENTITY I2C_TB IS
END ENTITY;

ARCHITECTURE ITB OF I2C_TB IS

	COMPONENT I2C IS  	
	GENERIC(bus_clk   : INTEGER := 100_000;
	        sys_clk   : INTEGER := 50_000_000 );
	PORT(
		CLK 	: IN STD_LOGIC;
		RESET	: IN STD_LOGIC;
		SDA 	: INOUT STD_LOGIC;
		SCL 	: OUT STD_LOGIC
	);
	END COMPONENT;

	SIGNAL clk, reset : std_logic :='0';
	SIGNAL scl, sda : std_logic;

BEGIN
	i : I2C PORT MAP( CLK => clk , RESET=> reset , SDA => sda, SCL=> scl);

	C : process begin
		wait for 500 ns;
		clk <= not clk;
		end process;

	r : process begin
		reset <= '1';
		wait for 10000 ns;

		reset <= '0';

		end process; 


END ITB;
