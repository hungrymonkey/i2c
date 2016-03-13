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
		WCLK	: Out STD_LOGIC;
		DATA_R	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		DATA_W	: Out STD_LOGIC_VECTOR(7 DOWNTO 0);



		Write	: IN STD_LOGIC; -- tells loader to write out to RAM
		Loaded 	: OUT STD_LOGIC;
		Nex 	: IN STD_LOGIC; -- tells the loader to output next value
		LoadM1	: IN STD_LOGIC;
		LoadM2	: IN STD_LOGIC;
		Clk		: IN STD_LOGIC


	);
END Entity;


-- In this module we will be iterating over the RAM
-- Connected to the MatMul module which will idle until loaded is sent
-- This module will wait on the loade m1 & m2 bits to load from sram




ARCHITECTURE Load of LOADER is

Constant Matrix1_start :integer := 0; -- change
Constant Matrix2_start : integer := 3; -- change
Constant SIZE : integer	:= 2; -- but array of size +1  should be changed 
Constant P : integer := 2;

Type LOAD_type is (idle, waitM1, waitM2, loadingM1, loadingM2, Done);

Type OUTPUT_type is ( init, idleing , incre);


Type registers is array (0 to 2) of STD_LOGIC_VECTOR(7 DOWNTO 0);

Signal fin : STD_LOGIC := '0';
Signal cLoad, nLoad : LOAD_type := idle;
Signal cOut , nOut : OUTPUT_type := init;
Signal REGS : registers;


BEGIN

--  need process to load up all the variables, two different sets of 960

PROCESS ( Clk, Res)
BEGIN
	IF ( Res = '1') THEN
		cOut <= idleing;
		cLoad <= idle; -- default states;
	ELSIF ( rising_edge(Clk)) THEN
		cLoad <= nLoad;
		cOut <= nOut;
	END IF; 
END PROCESS;

LOAD: PROCESS (cLoad, LoadM1, LoadM2 )
	VARIABLE m1ADD : integer := Matrix1_start;
	VARIABLE m2ADD : integer := Matrix2_start;
	VARIABLE coM1 : natural range 0 to SIZE :=0;
	VARIABLE coM2 : natural range 0 to SIZE :=0;
	VARIABLE BOTH : natural range 0 to SIZE :=0;
BEGIN
	CASE cLoad IS
		WHEN idle =>
			Loaded <= '0';
			if (LoadM1 = '1') then
				coM1 := 0;
				nLoad <= loadingM1;
			elsif (LoadM2 = '1') then
				coM2 := 0;
				nLoad <= loadingM2;
			else
				nLoad <= idle;
			end if;

		WHEN loadingM1 =>
			Loaded <= '0';
			if (coM1 = SIZE) then-- line to change with different sized arrays
				m1ADD := m1ADD+size;
				coM1 := 0;
				BOTH := BOTH + 1;
				EN <= '0';
				nLoad <= waitM1;
			else
				Addr_R	<= m1ADD + coM1; -- make sureit is an int
				EN <= '1';
				RCLK <= '1';
				REGS(coM1) <= DATA_R;
				RCLK <= '0';
				coM1 :=  coM1 + 1;
				nLoad <= loadingM1;
			end if;
		WHEN loadingM2 =>
			Loaded <= '0';
			if (coM2 = SIZE) then-- line to change with different sized arrays
				m2ADD := m2ADD+1;
				coM2 := 0;
				BOTH := BOTH + 1;
				EN <= '0';
				nLoad <= waitM2;
			else
				Addr_R	<= m2ADD + (coM2 * SIZE); -- make sureit is an int
				EN <= '1';
				RCLK <= '1';
				REGS(coM2) <= DATA_R;
				RCLK <= '0';
				coM2 :=  coM2 + 1;
				nLoad <= loadingM2;
			end if;

		WHEN waitM1 =>
			Loaded <= '0';
			if ( BOTH = 2 ) then -- we are done
				nLoad <= Done;
			elsif (LoadM2 = '1') then  -- go to that load
				nLoad <= loadingM2;
			else
				nLoad <= waitM1;
			end if;
		WHEN waitM2 =>
			Loaded <= '0';
			if ( BOTH = 2 ) then -- we are done
				nLoad <= Done;
			elsif (LoadM1 = '1') then -- go to that load
				nLoad <= loadingM1;
			else
				nLoad <= waitM2;
			end if;

		WHEN Done =>
			Loaded <= '1';
			BOTH := 0;
			fin <= '1';
			if ( rising_edge(LoadM1)) then
				nLoad <= loadingM1;
			elsif ( rising_edge(LoadM2)) then
				nLoad <= loadingM2;
			else 
				nLoad <= Done;
			end if;
	END CASE;
END Process;

PROCESS (cOut, Nex, fin )
	VARIABLE index : natural range 0 to SIZE :=0;
BEGIN -- setOut , incre, idle 
	CASE cOUT IS
		WHEN init => 
			if ( rising_edge(fin)) THEN
				nOut <= idleing;
				index:=0;
			else
				nOut <= init;
			END IF;
		WHEN idleing =>
			if ( Nex = '1' ) then
				nOut <= incre;
			else
				nOut <= idleing; 
			end if;
		WHEN incre =>
			outM1 <= REGS(index);
			outM2 <= REGS(index);
			if ( index = SIZE) then
				nOut <= init; 
				index := 0; 
			else
				index := index + 1;
				nOut <= idleing;
			end if;

	END CASE;
END PROCESS;



WRITEOUT : PROCESS(Write)
	VARIABLE WRITE_ADD : INTEGER := 5760000 ; -- first free memory location
	
BEGIN

	DATA_W <= InM3(15 DOWNTO 8);
	Addr_W <= WRITE_ADD;
	WEN	<= '1';
	WCLK <= '1';	
	
	WRITE_ADD := WRITE_ADD + 1;
	WCLK <= '0';
	
	Addr_W <= WRITE_ADD;
	DATA_W <= InM3(7 DOWNTO 0);
	WCLK <= '1';

	WRITE_ADD:= WRITE_ADD +1;
	WCLK <= '0' ;
	WEN <= '0';

END PROCESS;


END LOAD;
