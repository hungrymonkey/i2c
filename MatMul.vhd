library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;


ENTITY MaxMul IS
	PORT(
		Enable	: IN STD_LOGIC;
		Loaded	: IN STD_LOGIC;
		DONE	: OUT STD_LOGIC;
		InM1 	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		InM2 	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		OutM3	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		Clk		: IN STD_LOGIC
	);
END ENTITY;

ARCHITECTURE max of MaxMul IS 

	TYPE states	is (IDLE,START,MULTIPLY,DONE);

	SIGNAL c_sta, n_sta : states :=IDLE;

BEGIN
	
FSM : PROCESS(Clk, Enable,Loaded)
BEGIN
	IF ( Enable = '0') THEN
		c_sta <= IDLE;
		n_sta <= IDLE;
		DONE <= '0';
	ELSIF( Loaded = '1') THEN
		n_stat <= start;
	ENDIF;


	IF( rising_edge(Clk)) THEN
		c_sta <= n_sta;
	ENDIF;

END PROCESS;	


LOGIC: PROCESS(c_state, Loaded, InM1, InM2  )
	VARIABLE count :natural range 0 to 1920;

BEGIN


END PROCESS;




END max;