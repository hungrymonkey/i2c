--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:09:02 01/23/2016
-- Design Name:   
-- Module Name:   H:/cs143/proj1/CarryAdder4b_tb.vhd
-- Project Name:  proj1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CarryAdder4b
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY validate_tb IS
END validate_tb;
 
ARCHITECTURE behavior OF validate_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT validate
    Port ( sdaIn   : in STD_LOGIC;
           sclIn   : in STD_LOGIC;
           sdaOut  : out STD_LOGIC;
           start   : out STD_LOGIC;
           stop    : out STD_LOGIC
        );
    END COMPONENT;
    

   --Inputs
   signal sda : std_logic := 'H';
   signal clk : std_logic := 'H';
   signal start_clk : std_logic := '0';
   signal data : std_logic := '0';
   signal start_signal : std_logic := '0';
   signal stop_signal : std_logic := '0';



 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: validate PORT MAP (
          sdaIn => sda,
          sclIn => clk,
          sdaOut => data,
          start => start_signal,
          stop => stop_signal 
        );

    CLOCK_PROC:
    PROCESS BEGIN
        wait for 100 ns;
        clk <= not (clk and start_clk);
    END PROCESS;

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
      start_clk <= '1';
      
      -- insert stimulus here
      sda <= '0';
	wait for 200 ns;
	sda<='1';
	wait for 200 ns;
		

      wait;
   end process;

END;
