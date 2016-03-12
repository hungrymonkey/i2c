library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;


ENTITY I2C_top_TB IS
END ENTITY;

ARCHITECTURE ITOPTB OF I2C_top_TB IS

	COMPONENT I2C_MASTER IS  	
	GENERIC(bus_clk   : INTEGER := 1_000_000;
	        sys_clk   : INTEGER := 1000000000 );
	PORT(
		CLK 	: IN STD_LOGIC;
		RESET	: IN STD_LOGIC;
		P		: IN STD_LOGIC_VECTOR( 15 DOWNTO 0 );
		SDA 	: INOUT STD_LOGIC;
		SCL 	: INOUT STD_LOGIC
	);
	END COMPONENT;
	COMPONENT I2C_SLAVE IS 
	GENERIC(bus_clk   : INTEGER := 1_000_000;
	        sys_clk   : INTEGER := 1000000000 ;
			slave_addr : std_logic_vector( 6 DOWNTO 0) := "0101010");
	PORT(
		CLK 	: IN STD_LOGIC;
		RESET	: IN STD_LOGIC;
--		RAM		:  inout ram_type;
		SDA 	: INOUT STD_LOGIC;
		SCL 	: IN STD_LOGIC;
		P		: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 )

	);
	END COMPONENT;
	SIGNAL clk, reset : std_logic :='0';
	SIGNAL scl, sda : std_logic;
	SIGNAL p_num : STD_LOGIC_VECTOR( 15 DOWNTO 0 ) := X"0000";

BEGIN
	PULLUP_SDA: sda <= 'H';
	PULLUP_SCL: scl <= 'H';
	
	 CLOCK: process begin
		clk <= '0';
		wait for 0.5 ns;
		clk <= '1';
		wait for 0.5 ns;
	end process;
	
	i : I2C_MASTER GENERIC MAP( bus_clk => 1_000_000, sys_clk => 1000000000 ) PORT MAP( CLK => clk , RESET=> reset, P=> X"00FF", SDA => sda, SCL=> scl);

	s : I2C_SLAVE GENERIC MAP( bus_clk => 1_000_000, sys_clk => 1000000000 , slave_addr=>"0101010") PORT MAP( CLK => clk , RESET=> reset , SDA => sda, SCL=> scl, P => p_num);

	r : process begin
		reset <= '1';	
		scl <= 'H';
		sda <= 'H';
		wait for 10 ns;

		reset <= '0';		
		wait for 10000 ns;

		sda <= 'H';
		wait for 100000000 ns;

        wait;
		end process; 


END ITOPTB;
