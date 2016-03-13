library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;
entity BRAM_mat1_tb is 
	END BRAM_mat1_tb;

Architecture BRAMTB of BRAM_mat1_tb is 

	Component bram_mat1 IS PORT(
		
		EN_A	: IN STD_LOGIC;
		CLK_A	: IN STD_LOGIC;
		ADDR_R_A 	: IN INTEGER;
		D_A 	: OUT STD_LOGIC_VECTOR( 7 DOWNTO 0);
		
		EN_B	: IN STD_LOGIC;
		CLK_B	: IN STD_LOGIC;
		ADDR_R_B 	: IN INTEGER;
		D_B 	: OUT STD_LOGIC_VECTOR( 7 DOWNTO 0)

	); 
	END Component;

	SIGNAL	WEN_A	:  STD_LOGIC;
	SIGNAL	EN_A	:  STD_LOGIC;
	SIGNAL	ADDR_R_A 	:  INTEGER := 0;
	SIGNAL	DIN_A 	:  STD_LOGIC_VECTOR( 7 DOWNTO 0);
	SIGNAL	D_A 	:  STD_LOGIC_VECTOR( 7 DOWNTO 0);
		
	SIGNAL	WEN_B	:  STD_LOGIC;
	SIGNAL	EN_B	:  STD_LOGIC;
	SIGNAL	ADDR_R_B 	:  INTEGER := 1;
	SIGNAL	DIN_B 	:  STD_LOGIC_VECTOR( 7 DOWNTO 0);
	SIGNAL	D_B 	:  STD_LOGIC_VECTOR( 7 DOWNTO 0);

	SIGNAL CLK_A, CLK_B : STD_LOGIC := '0';	
begin

	f : bram_mat1 PORT MAP(
		
		EN_A   => EN_A,
		CLK_A	=> CLK_A,
		ADDR_R_A => ADDR_R_A,
		D_A 	=> D_A,
		
		EN_B	=> EN_B,
		CLK_B	=> CLK_B,
		ADDR_R_B 	=> ADDR_R_B,
		D_B 	=> D_B

	); 



 clck_proc: process begin
	 wait for 200 ns;
	 CLK_A <= not CLK_A;
 END process;
 clck_proc2: process begin
	 wait for 250 ns;
	 CLK_B <= not CLK_B;
 END process;
 stim_process: process begin 
	EN_A <= '0';
	ADDR_R_A <= 1;
	EN_B <= '0';
	ADDR_R_B <= 1;
	wait for 300 ns;
	

	 wait for 300 ns;
	ADDR_R_A <= 30;

	 wait for 100 ns;


 END process;

 END;
