library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY coProc is 
	GENERIC ();
	PORT(
		Enable 	: IN STD_LOGIC; -- to start calulating
		Reset	: IN STD_LOGIC; -- clear all regs
		Clk 	: IN STD_LOGIC;	-- clock of operation
		Size	: IN STD_LOGIC_VECTOR(15 DOWN TO 0);
		Inte	: OUT STD_LOGIC -- raising the interrupt
		); 	
END ENTITY;


FSM:Process ( Clk )
		Variable count : INTEGER range 0 to 3;
	BEGIN
	


	End PROCESS;