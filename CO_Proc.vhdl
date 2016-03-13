library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;
ENTITY CO_PROC IS
	GENERIC(bus_clk   : INTEGER := 1_000_000;
	        sys_clk   : INTEGER := 1000000000 ;
			slave_addr : std_logic_vector( 6 DOWNTO 0) := "0101010");
	PORT(
		CLK 	: IN STD_LOGIC;
		RESET	: IN STD_LOGIC;
--		RAM		:  inout ram_type;
		SDA 	: INOUT STD_LOGIC;
		SCL 	: IN STD_LOGIC
--		P		: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 )
	);
END ENTITY;
ARCHITECTURE arch OF CO_PROC IS
	COMPONENT I2C_SLAVE IS
	GENERIC(bus_clk   : INTEGER;
	        sys_clk   : INTEGER;
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
	COMPONENT BRAM_MAT2 IS

	PORT(
		
		EN_A	: IN STD_LOGIC;
		CLK_A	: IN STD_LOGIC;
		ADDR_R_A 	: IN INTEGER;
		D_A 	: OUT STD_LOGIC_VECTOR( 7 DOWNTO 0);
		
		EN_B	: IN STD_LOGIC;
		CLK_B	: IN STD_LOGIC;
		ADDR_R_B 	: IN INTEGER;
		D_B 	: OUT STD_LOGIC_VECTOR( 7 DOWNTO 0)

	);
		
	END COMPONENT;
	COMPONENT BRAM_MAT1 IS

	PORT(
		
		EN_A	: IN STD_LOGIC;
		CLK_A	: IN STD_LOGIC;
		ADDR_R_A 	: IN INTEGER;
		D_A 	: OUT STD_LOGIC_VECTOR( 7 DOWNTO 0);
		
		EN_B	: IN STD_LOGIC;
		CLK_B	: IN STD_LOGIC;
		ADDR_R_B 	: IN INTEGER;
		D_B 	: OUT STD_LOGIC_VECTOR( 7 DOWNTO 0)

	);
	END COMPONENT;
	SIGNAL p_num : STD_LOGIC_VECTOR( 15 DOWNTO 0 ) := X"0000";

BEGIN
	i2c: I2C_SLAVE GENERIC MAP( bus_clk => bus_clk, sys_clk => sys_clk , slave_addr=>slave_addr) PORT MAP( CLK => CLK , RESET=> reset , SDA => SDA, SCL=> SCL, P => p_num);
END ARCHITECTURE arch;
