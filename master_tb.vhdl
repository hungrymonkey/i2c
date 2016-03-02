library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity master_tb is 
	end master_tb;

architecture bev of master_tb is 

	component master is
    Port ( sda   : inout STD_LOGIC;
           scl   : out STD_LOGIC
        );
	end component;


	signal Sda : std_logic := 'H';
	signal Scl : std_logic;

begin
	m : master port map ( sda=>Sda, scl=>Scl);

	start_process: process begin
		wait for 100 ns;
		Sda <= '0';
		wait for 100000 ns;
		Sda <= 'H';
		wait for 1000 ns; 
		Sda <= '0';

	end process;
end
