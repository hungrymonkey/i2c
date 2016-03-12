library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

Entity LOADER IS
	Port (
		OutM1 	: OUT STD_LOGIC_VECTOR( 7 DOWNTO 0);
		OutM2	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		InM3	: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		--Ena		: In STD_LOGIC;
		Res		: In STD_LOGIC; -- reset


		Addr_W	: Out INTEGER;
		Addr_R	: Out INTEGER;
		WEN		: Out STD_LOGIC;
		EN   	: Out STD_LOGIC;
		RCLK 	: Out STD_LOGIC;
		DATA	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);



		Write	: IN STD_LOGIC; -- tells loader to write out to RAM
		Loaded 	: OUT STD_LOGIC;
		Next 	: IN STD_LOGIC; -- tells the loader to output next value
		LoadM1	: IN STD_LOGIC;
		LoadM2	: IN STD_LOGIC;
		Clk		: IN STD_LOGIC


	);
END Entity;


-- In this module we will be iterating over the RAM
-- Connected to the MatMul module which will idle until loaded is sent
-- This module will wait on the loade m1 & m2 bits to load from sram




ARCHITECTURE Load of LOADER is

Constant Matrix1_start := 0; -- change
Constant Matrix2_start := 15; -- change
Constant Size 	:= 3; -- should be changed 


Type LOAD_type is (idle, waitM1, waitM2, loadM1, loadM2, Done);

Type OUTPUT_type is ( idle, setOut, incre);


Type registers is array (0 to 2) of STD_LOGIC_VECTOR(7 DOWNTO 0);


Signal cLoad, nLoad : LOAD_type := idle;
Signal cOut , nOut : OUTPUT_type := idle;
Signal REGS : registers;




--  need process to load up all the variables, two different sets of 960

PROCESS ( Clk, Res)
BEGIN
	IF ( Res = '1') THEN
		cOut <= idle;
		cLoad <= idle; -- default states;
	ELSIF ( rising_edge(Clk)) THEN
		cLoad <= nLoad;
		cOut <= nOut;
	END IF; 
END PROCESS:

LOAD: PROCESS (cLoad, LoadM1, LoadM2 )
	VARIABLE m1ADD : integer := ;
	VARIABLE m2ADD : integer := 
	VARIABLE coM1 : natural range 0 to 2 :=0;
	VARIABLE coM2 : natural range 0 to 2 :=0;
	VARIABLE BOTH : natural range 0 to 2 :=0;
BEGIN
	CASE cLoad IS
		WHEN idle =>

			if (LoadM1 = 1) then
				coM1 := 0;
				nLoad <= loadM1;
			elsif (LoadM2 = 1) then
				coM2 := 0;
				nLoad <= loadM2;
			else
				nLoad <= idle;
			end if;


		WHEN loadM1 =>
			if (coM1 = 2) then-- line to change with different sized arrays
				
			else
		WHEN loadM2 =>

		WHEN waitM1 =>

		WHEN waitM2 =>

		WHEN Done =>



	END CASE;
END LOAD;

