library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity master is
    Port ( sda   : inout STD_LOGIC;
           scl   : out STD_LOGIC
        );
end master;
architecture lab3 of master is
	COMPONENT validate is
    PORT ( sdaIn   : in STD_LOGIC;
           sclIn   : in STD_LOGIC;
           sdaOut  : out STD_LOGIC;
           start   : out STD_LOGIC;
           stop    : out STD_LOGIC
        );
	END COMPONENT validate;

	COMPONENT FSM is
    Port (	start    : in STD_LOGIC;
			stop     : in STD_LOGIC;
			scl      : in STD_LOGIC;
			sda		 : in STD_LOGIC;
			ack0     : out STD_LOGIC;
			ack1     : out STD_LOGIC;
			ack2     : out STD_LOGIC;
			addr     : out STD_LOGIC;
			reg     : out STD_LOGIC;
			rw      : out STD_LOGIC;
			data 	: out STD_LOGIC;
			enclk    : out STD_LOGIC;
			number   : out UNSIGNED (2 downto 0)
        );
	END COMPONENT FSM;
	SIGNAL clk: STD_LOGIC ;
	SIGNAL s_clk: STD_LOGIC ;
	SIGNAL sdaValid: STD_LOGIC;
	SIGNAL stop_signal: STD_LOGIC;
	SIGNAL start_signal: STD_LOGIC;
	
	
	SIGNAL ack0_signal: STD_LOGIC := '0';
	SIGNAL ack1_signal: STD_LOGIC := '0';
	SIGNAL ack2_signal: STD_LOGIC := '0';
	SIGNAL addr: STD_LOGIC := '0';
	SIGNAL rw: STD_LOGIC := '0';
	SIGNAL reg: STD_LOGIC := '0';
	SIGNAL data: STD_LOGIC := '0';
	SIGNAL enclk: STD_LOGIC := '0';
	SIGNAL address: UNSIGNED (2 downto 0):= "000";


begin
	 VALIDATE_MODULE: validate PORT MAP(
										sdaIn => sda,
										sclIn => s_clk,
										sdaOut    => sdaValid,
										start  => start_signal,
										stop => stop_signal
										);
										
	FSM_MODULE: fsm PORT MAP(	start    => start_signal,
								stop     => stop_signal,
								scl      => s_clk,
								sda		 => sdaValid,
								ack0     => ack0_signal,
								ack1     => ack1_signal,
								ack2     => ack2_signal,
								addr     => addr,
								reg      => reg,
								rw       => rw,
								data 	=> data,
								enclk    => enclk,
								number   => address
							);
							
	PROCESS( clk ) BEGIN
		--wait for 10000 ns;
		CLK <= NOT clk;
		s_clk <= CLK AND enclk;
	END PROCESS;
	scl <= s_clk;
end lab3;

