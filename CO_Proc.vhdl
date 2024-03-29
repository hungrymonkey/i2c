library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;
ENTITY CO_PROC IS
	GENERIC(bus_clk   : INTEGER := 1_000_000;
	        sys_clk   : INTEGER := 1000000000 ;
			slave_addr : std_logic_vector( 6 DOWNTO 0) := "0101010";
			N : INTEGER := 1920;
			P : INTEGER := 1920);

	PORT(
		CLK 	: IN STD_LOGIC;
		RESET	: IN STD_LOGIC;
--		RAM		:  inout ram_type;
		SDA 	: INOUT STD_LOGIC;
		SCL 	: IN STD_LOGIC;
		DONE	: OUT STD_LOGIC;
		D_OUT	: OUT STD_LOGIC_VECTOR( 7 DOWNTO 0);
		WEN	: OUT STD_LOGIC

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
		SDA 	: INOUT STD_LOGIC;
		SCL 	: IN STD_LOGIC;
		P		: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 )
	);
	END COMPONENT;
	COMPONENT BRAM_MAT2 IS
	GENERIC(size : INTEGER := 1920);

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
	GENERIC(size : INTEGER := 1920);

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
	SIGNAL p_num : STD_LOGIC_VECTOR( 15 DOWNTO 0 ) := X"FFFF";
	SIGNAL M1_ADDR_A, M1_ADDR_B : INTEGER := 1;
	SIGNAL M1_DA, M1_DB : STD_LOGIC_VECTOR( 7 DOWNTO 0 ) := X"00";

	SIGNAL M2_ADDR_A, M2_ADDR_B : INTEGER := 1;
	SIGNAL M2_DA, M2_DB : STD_LOGIC_VECTOR( 7 DOWNTO 0 ) := X"00";

BEGIN
	i2c: I2C_SLAVE GENERIC MAP( bus_clk => bus_clk, sys_clk => sys_clk , slave_addr=>slave_addr) PORT MAP( CLK => CLK , RESET=> reset , SDA => SDA, SCL=> SCL, P => p_num);
	
	mat1: BRAM_MAT1 GENERIC MAP(SIZE => N) PORT MAP( EN_A => '1', CLK_A => CLK, ADDR_R_A => M1_ADDR_A, D_A => M1_DA, EN_B => '1', CLK_B => CLK, ADDR_R_B => M1_ADDR_B, D_B => M1_DB );
	mat2: BRAM_MAT2 GENERIC MAP(SIZE => N) PORT MAP( EN_A => '1', CLK_A => CLK, ADDR_R_A => M2_ADDR_A, D_A => M2_DA, EN_B => '1', CLK_B => CLK, ADDR_R_B => M2_ADDR_B, D_B => M2_DB );
	multi: 
	PROCESS
	variable A, B, P, Sum   : INTEGER; 
	BEGIN
		for i IN 0 TO N-1 loop
			SUM := 0;
			for j IN 0 TO N-1 loop
				IF( j > P) THEN
					EXIT;
				ELSE
					wait until Clk = '1' and Clk'event;
					M1_ADDR_A <= i;
					M2_ADDR_A <= j;
					SUM := SUM + to_integer( unsigned( M1_DA )) * to_integer( unsigned(M2_DA ));
				END IF;
			end loop;
			D_OUT <= STD_LOGIC_VECTOR(to_unsigned(SUM,8));
		end loop;
	END PROCESS;
		
END ARCHITECTURE arch;
