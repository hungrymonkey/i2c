library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;
use work.ram.ALL;
use std.textio.all;
ENTITY BRAM IS

	PORT(
		
		WEN_A	: IN STD_LOGIC;
		EN_A	: IN STD_LOGIC;
		CLK_A	: IN STD_LOGIC;
		ADDR_W_A 	: IN STD_LOGIC_VECTOR( 7 DOWNTO 0);
		ADDR_R_A 	: IN STD_LOGIC_VECTOR( 7 DOWNTO 0);
		DIN_A 	: IN STD_LOGIC_VECTOR( 7 DOWNTO 0);
		D_A 	: OUT STD_LOGIC_VECTOR( 7 DOWNTO 0);
		
		WEN_B	: IN STD_LOGIC;
		EN_B	: IN STD_LOGIC;
		CLK_B	: IN STD_LOGIC;
		ADDR_W_B 	: IN STD_LOGIC_VECTOR( 7 DOWNTO 0);
		ADDR_R_B 	: IN STD_LOGIC_VECTOR( 7 DOWNTO 0);
		DIN_B 	: IN STD_LOGIC_VECTOR( 7 DOWNTO 0);
		D_B 	: OUT STD_LOGIC_VECTOR( 7 DOWNTO 0)

	);
		
END ENTITY;

ARCHITECTURE r of BRAM is 
	impure function init_my_ram (file1, file2 : string) return ram_type is
		FILE f1, f2 : TEXT;
		variable m : ram_type;
		variable inline : line;
		variable  dataread1    : BIT_VECTOR( 7 DOWNTO 0);
		begin
		   file_open(f1, file1, read_mode);
		   file_open(f2, file2, read_mode);

		   for i in 0 to 3686399  loop
			  readline(f1, inline);
			  read( inline, dataread1 );
			  m(i) := To_StdLogicVector(dataread1);
		   end loop;
		   for i in 3686400 to 7372799  loop
			  readline(f2, inline);
			  read( inline, dataread1 );
			  m(i) := To_StdLogicVector(dataread1);
		   end loop;
		   file_close(f1);
		   file_close(f2);

	   return m;
	end init_my_ram;

	
	SIGNAL ram_block : ram_type := init_my_ram( "./mat1.dat", "./mat2.dat");
BEGIN
END r;

