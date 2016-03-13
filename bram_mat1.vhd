library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;
use work.ram_mat.ALL;
use std.textio.all;
ENTITY BRAM_MAT1 IS

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
		
END ENTITY;

ARCHITECTURE r of BRAM_MAT1 is 
	impure function init_my_ram (file1, file2 : string) return ram_type is
		FILE f1, f2 : TEXT;
		variable m : ram_type;
		variable inline : line;
		variable  dataread1    : REAL;
		begin
		   file_open(f1, file1, read_mode);

		   for i in 0 to 3686399  loop
			  readline(f1, inline);
			  read( inline, dataread1 );
			  m(i) := STD_LOGIC_VECTOR(to_unsigned(INTEGER(dataread1),8));
		   end loop;

		   file_close(f1);

	   return m;
	end init_my_ram;

	
	SIGNAL ram_block : ram_type := init_my_ram( "./mat1.dat", "./mat2.dat");
BEGIN
	PROCESS( CLK_A ) BEGIN

		D_A <= ram_block( ADDR_R_A);
	END PROCESS;
	
	PROCESS(CLK_B ) BEGIN

		D_B <= ram_block( ADDR_R_B);

	END PROCESS;
END r;
