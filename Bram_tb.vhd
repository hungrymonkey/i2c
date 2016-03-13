library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;
entity BRAM_tb is 
	END BRAM_tb;

Architecture BRAMTB of BRAM_tb is 

	Component bram IS PORT(
		
		WEN_A	: IN STD_LOGIC;
		EN_A	: IN STD_LOGIC;
		CLK_A	: IN STD_LOGIC;
		ADDR_W_A 	: IN INTEGER;
		ADDR_R_A 	: IN INTEGER;
		DIN_A 	: IN STD_LOGIC_VECTOR( 7 DOWNTO 0);
		D_A 	: OUT STD_LOGIC_VECTOR( 7 DOWNTO 0);
		
		WEN_B	: IN STD_LOGIC;
		EN_B	: IN STD_LOGIC;
		CLK_B	: IN STD_LOGIC;
		ADDR_W_B 	: IN INTEGER;
		ADDR_R_B 	: IN INTEGER;
		DIN_B 	: IN STD_LOGIC_VECTOR( 7 DOWNTO 0);
		D_B 	: OUT STD_LOGIC_VECTOR( 7 DOWNTO 0)

	); 
	END Component;

	SIGNAL	WEN_A	:  STD_LOGIC;
	SIGNAL	EN_A	:  STD_LOGIC;
	SIGNAL	ADDR_W_A 	:  INTEGER := 0;
	SIGNAL	ADDR_R_A 	:  INTEGER := 0;
	SIGNAL	DIN_A 	:  STD_LOGIC_VECTOR( 7 DOWNTO 0);
	SIGNAL	D_A 	:  STD_LOGIC_VECTOR( 7 DOWNTO 0);
		
	SIGNAL	WEN_B	:  STD_LOGIC;
	SIGNAL	EN_B	:  STD_LOGIC;
	SIGNAL	ADDR_W_B 	:  INTEGER := 0;
	SIGNAL	ADDR_R_B 	:  INTEGER := 1;
	SIGNAL	DIN_B 	:  STD_LOGIC_VECTOR( 7 DOWNTO 0);
	SIGNAL	D_B 	:  STD_LOGIC_VECTOR( 7 DOWNTO 0);

	SIGNAL CLK_A, CLK_B : STD_LOGIC := '0';	
begin

	f : bram PORT MAP(
		
		WEN_A  => WEN_A,
		EN_A   => EN_A,
		CLK_A	=> CLK_A,
		ADDR_W_A 	=> ADDR_W_A,
		ADDR_R_A => ADDR_R_A,
		DIN_A 	=> DIN_A,
		D_A 	=> D_A,
		
		WEN_B	=> WEN_B,
		EN_B	=> EN_B,
		CLK_B	=> CLK_B,
		ADDR_W_B 	=> ADDR_W_B,
		ADDR_R_B 	=> ADDR_R_B,
		DIN_B 	=> DIN_B,
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
	WEN_A <= '0';
	EN_A <= '0';
	ADDR_W_A <= 0;
	ADDR_R_A <= 1;
	DIN_A <= X"08";
	WEN_B <= '0';
	EN_B <= '0';
	ADDR_W_B <= 0;
	ADDR_R_B <= 1;
	DIN_B <= X"08";
	wait for 300 ns;
	
	 DIN_A <= X"0A";
	 WEN_A <= '1';
	 ADDR_W_A <= 30;

	 wait for 300 ns;
	ADDR_R_A <= 30;

	 wait for 100 ns;


 END process;

 END;
