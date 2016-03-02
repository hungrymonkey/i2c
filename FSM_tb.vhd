library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;
entity FSM_tb is 
	END FSM_tb;

Architecture behav of FSM_tb is 

	component FSM
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
	END Component;

	Component validate
		Port(
			sdaIn : in std_logic;
		sclIn : in std_logic;
		sdaOut : out std_logic ;
		start : out std_logic;
		stop : out std_logic
	);
	END component;

    signal Start    :  STD_LOGIC;
		Signal	Stop     :  STD_LOGIC;
		signal	Scl      :  STD_LOGIC;
		signal Sda		 :  STD_LOGIC;
		signal Ack0     :  STD_LOGIC;
		signal			Ack1     :  STD_LOGIC;
		signal			Ack2     :  STD_LOGIC;
		signal			Addr     :  STD_LOGIC;
		signal 			Reg     :  STD_LOGIC;
		signal 			Rw      :  STD_LOGIC;
		signal	Data 	:  STD_LOGIC;
		signal			Enclk    :  STD_LOGIC;
		signal	Number   :  UNSIGNED (2 downto 0);

		signal SDA : std_logic := 'H';
begin

	f : FSM PORT MAP(
		start => Start, stop=>Stop, scl => Scl, sda=> Sda,
		ack0=> Ack0, ack1 => Ack1, ack2=> Ack2, addr=> Addr,
		reg=> Reg, rw=> Rw, data=>Data, enclk=>Enclk, number=>Number
 );

v : validate Port map (
sdaIn => SDA, sclIn => Scl, sdaOut => Sda, start=>Start, stop => Stop ); 
 clck_proc: process begin
	 wait for 200 ns;
	 Scl <= not Scl;
 END process;

 stim_process: begin 
	 wait for 100 ns;
	
	 SDA <= '0';
	 wait for 100 ns;
	 SDA <= 'H';
	 wait for 100 ns;
	 SDA <= '0';
	 wait for 100 ns;


 END process;

 END;
