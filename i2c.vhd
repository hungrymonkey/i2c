library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY I2C_MASTER IS
	GENERIC(bus_clk   : INTEGER := 1_000_000;
	        sys_clk   : INTEGER := 1000000000 );
	PORT(
		CLK 	: IN STD_LOGIC;
		RESET	: IN STD_LOGIC;
		SDA 	: INOUT STD_LOGIC;
		SCL 	: INOUT STD_LOGIC
	);
END ENTITY;

ARCHITECTURE BEV OF I2C_MASTER IS 
	CONSTANT delay	  : INTEGER := 5*bus_clk;
	CONSTANT divider  :  INTEGER := ((sys_clk/8)/bus_clk);
	CONSTANT slave_addr : std_logic_vector( 6 DOWNTO 0) := "0101010";
	CONSTANT dev_addr_write: STD_LOGIC_VECTOR( 7 DOWNTO 0) := "10100000";
	CONSTANT dev_addr_reg: STD_LOGIC_VECTOR( 7 DOWNTO 0) := "10100001";

	
	
	COMPONENT shiftReg 
		PORT(
		trigger : in STD_LOGIC;
			input  : in STD_LOGIC;
			output : out STD_LOGIC
		);
	END COMPONENT;
	
	COMPONENT validate is
    PORT ( sdaIn   : in STD_LOGIC;
           sclIn   : in STD_LOGIC;
           sdaOut  : out STD_LOGIC;
           start   : out STD_LOGIC;
           stop    : out STD_LOGIC
        );
	END COMPONENT;
	

	SIGNAL timer	: NATURAL RANGE 0 TO delay;
	SIGNAL i		: NATURAL RANGE 0 TO delay;

	type state_t is ( idle, ack0, ack1, ack2, dev_addr, reg_addr, rw, start, stop, reg_write, reg_read, error);
	SIGNAL st, st_n : state_t;
	
	SIGNAL scl_ena       : STD_LOGIC := '0';               --enables internal scl to output

	SIGNAL data_in : STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL data_clk, scl_clk     : STD_LOGIC;                      --data clock for sda
    SIGNAL data_clk_prev : STD_LOGIC;                      --data clock during previous system clock
	SIGNAL rw_signal : STD_LOGIC := '1';

	SIGNAL sda_n : STD_LOGIC;
	
	SIGNAL aux_clk : STD_LOGIC := '0';
	SIGNAL wr_flag, rd_flag : STD_LOGIC;
	SIGNAL ack_signal :STD_LOGIC := '0';
	SIGNAL stop_sent : STD_LOGIC := '0';
BEGIN
	PROCESS( clk ) 
		VARIABLE count : INTEGER RANGE 0 TO divider;
	BEGIN
		IF( rising_edge( clk )) THEN 
			count := count + 1;
			IF( count = divider ) THEN
				aux_clk <= not aux_clk;
				count := 0;
			END IF;
		END IF;
	END PROCESS;
	PROCESS(aux_clk)
		VARIABLE count : INTEGER RANGE 0 TO 3;
	BEGIN
		IF( rising_edge( aux_clk ) ) THEN 
			count := (count + 1) mod 4;
			
			IF ( count = 0 ) THEN
					scl_clk <= '0';
			ELSIF( count = 1 ) THEN
					data_clk <= '1';
			ELSIF( count = 2 ) THEN
					scl_clk <= 'Z';
			ELSIF( count = 3 ) THEN
					data_clk <= '0';
			END IF;
		END IF;
	END PROCESS;
	PROCESS ( data_clk, RESET ) 
	BEGIN
		IF( RESET = '1' ) THEN
			stop_sent <= '0';
			st <= idle;
			i <= 0;
		ELSIF( rising_edge( data_clk )) THEN
			IF( i = timer - 1) THEN
				st <= st_n;
				i <= 0;
			ELSE
				i <= 1 + i;
			END IF;
		ELSIF( falling_edge(data_clk)) THEN
			IF(st = idle) THEN
				wr_flag <= '0';
				rd_flag <= '1';
			END IF;
			IF ( st = reg_read ) THEN
				IF( SDA = 'H') THEN
					data_in( 7 - i ) <= '1';
				ELSE
					data_in( 7 - i ) <= '0';
				END IF;			END IF;
			IF( st = ack0 OR st = ack1 OR st = ack2) THEN
				IF( SDA = 'H') THEN
					ack_signal <= '1';
				ELSE
					ack_signal <= '0';
				END IF;
			END IF;
		END IF;
	END PROCESS;
	PROCESS ( st, scl_clk, data_clk  )
	BEGIN
		CASE st IS
			WHEN idle => 
				SCL <= 'Z';
				SDA <= 'Z';
				
				IF( wr_flag = '1' OR rd_flag = '1') THEN
					timer <= 1;
					st_n <= start;
				ELSE
					st_n <= idle;
					timer <= delay;
				END IF;
			WHEN start => 
				SCL <= 'Z';
				IF( data_clk  = '1' ) THEN
					SDA <= 'Z';
				ELSE
					SDA <= '0';
				END IF;
				timer <= 1;
				st_n <= dev_addr;
			WHEN dev_addr =>
				IF( slave_addr(6-i) = '1' ) THEN
					SDA <= 'Z';
				ELSE
					SDA <= '0';
				END IF;
				SCL <= scl_clk;
				timer <= 7;
				st_n <= rw;
			WHEN rw =>
				IF( rw_signal = '1' ) THEN
					SDA <= 'Z';
				ELSE
					SDA <= '0';
				END IF;
				SCL <= scl_clk;

				timer <= 1;
				st_n <= ack0;
			WHEN ack0 =>
				IF( scl_clk = '1' ) THEN
					SCL <= 'Z';
				ELSE
					SCL <= '0';
				END IF;
				timer <= 1;
				
				IF( ack_signal = '1' ) THEN
					st_n <= reg_addr;
				ELSE
					st_n <= ack0;
				END IF;
			WHEN reg_addr =>

				IF( dev_addr_reg(7-i) = '1' ) THEN
					SDA <= 'Z';
				ELSE
					SDA <= '0';
				END IF;
				SCL <= scl_clk;
				timer <= 8;
				st_n <= ack1;
			WHEN ack1 =>
				SCL <= scl_clk;
				timer <= 1;
				
				IF( ack_signal = '1' ) THEN
					IF( wr_flag = '0') THEN
						st_n <= reg_write;
					ELSE
						st_n <= reg_read;
					END IF;
				ELSE
					st_n <= ack1;
				END IF;
			WHEN reg_write =>
				SCL <= scl_clk;
				timer <= 8;
				st_n <= ack2;
				IF( dev_addr_write(7-i) = '1' ) THEN
					SDA <= 'Z';
				ELSE
					SDA <= '0';
				END IF;
			WHEN reg_read =>
				SCL <= scl_clk;
				timer <= 8;
				st_n <= ack2;
			WHEN ack2 =>
				SCL <= scl_clk;
				timer <= 1;
				st_n <= stop;
			WHEN stop =>
				
				IF( stop_sent = '0') THEN
					SCL <= scl_clk;
					IF( not scl_clk'EVENT AND scl_clk = 'Z') THEN
						SDA <= 'Z';
						stop_sent <= '1';
					ELSE
						stop_sent <= '0';
						SDA <= '0';
					END IF;
				ELSE 
					SCL <= 'Z';
					SDA <= 'Z';
				END IF;
				st_n <= stop;
				timer <= delay;
			WHEN error =>
		END CASE;
	END PROCESS;
	--SDA <= '0' WHEN 
	--SCL <= '0' WHEN (scl_ena = '1' AND scl_clk = '0') ELSE 'Z';

END BEV;
