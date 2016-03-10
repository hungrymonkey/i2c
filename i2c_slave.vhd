library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;
--use work.ram.all;


ENTITY I2C_SLAVE IS
	GENERIC(bus_clk   : INTEGER := 1_000_000;
	        sys_clk   : INTEGER := 1000000000 ;
			slave_addr : std_logic_vector( 6 DOWNTO 0) := "0101010");
	PORT(
		CLK 	: IN STD_LOGIC;
		RESET	: IN STD_LOGIC;
--		RAM		:  inout ram_type;
		SDA 	: INOUT STD_LOGIC;
		SCL 	: IN STD_LOGIC
	);
END ENTITY;

ARCHITECTURE arch OF I2C_slave IS
	COMPONENT validate is
    PORT ( sdaIn   : in STD_LOGIC;
           sclIn   : in STD_LOGIC;
           sdaOut  : out STD_LOGIC;
           start   : out STD_LOGIC;
           stop    : out STD_LOGIC
        );
	END COMPONENT;
	CONSTANT delay	  : INTEGER := 5*bus_clk;
	CONSTANT divider  :  INTEGER := ((sys_clk/8)/bus_clk);
	SIGNAL data_out : STD_LOGIC_VECTOR( 7 DOWNTO 0 ) := "01100110";



	SIGNAL timer	: NATURAL RANGE 0 TO delay;
	SIGNAL i		: NATURAL RANGE 0 TO delay;

	type state_t is ( idle, ack0, ack1, ack2, dev_addr, reg_addr, rw, start, stop, reg_write, reg_read, error);
	SIGNAL st, st_n : state_t;
	
	SIGNAL scl_ena       : STD_LOGIC := '0';               --enables internal scl to output

	SIGNAL data_in : STD_LOGIC_VECTOR( 7 DOWNTO 0 ) := "00000000";
	SIGNAL data_clk, scl_clk     : STD_LOGIC;                      --data clock for sda
    SIGNAL data_clk_prev : STD_LOGIC;                      --data clock during previous system clock
	SIGNAL rw_signal : STD_LOGIC;

	SIGNAL sda_n : STD_LOGIC;
	
	SIGNAL aux_clk : STD_LOGIC := '0';
	SIGNAL wr_flag, rd_flag : STD_LOGIC;
	SIGNAL start_signal, stop_signal : STD_LOGIC := '0';
BEGIN
	PROCESS( clk, SCL ) 
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
					scl_clk <= '1';
			ELSIF( count = 3 ) THEN
					data_clk <= '0';
			END IF;
		END IF;
	END PROCESS;

	PROCESS ( data_clk, RESET ) 
	BEGIN
		IF( RESET = '1' ) THEN
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
			IF (st = idle) THEN
				
			END IF;
			IF ( st = reg_read OR st = dev_addr ) THEN
				data_in( 7 - i ) <= SDA;
			END IF;
			IF ( st = rw ) THEN
				rd_flag <= SDA;
			END IF;
		END IF;
	END PROCESS;
	PROCESS ( st, scl_clk, data_clk  )
	BEGIN
		CASE st IS
			WHEN idle => 
				SDA <= 'Z';
				
				IF( SDA = '0') THEN
					st_n <= start;
				ELSE
					st_n <= idle;
				END IF;
				timer <= 1;
			WHEN start => 
				SDA <= 'Z';
				timer <= 1;
				st_n <= dev_addr;
			WHEN dev_addr =>
				SDA <= 'Z';

				IF( slave_addr(6-i) = data_in(7-i) ) THEN
					st_n <= rw;
				ELSE
					st_n <= error;
				END IF;

				timer <= 7;
				
			WHEN rw =>
				SDA <= 'Z';
				timer <= 1;
				st_n <= ack0;
			WHEN ack0 =>
				SDA <= 'Z';
				timer <= 1;
				st_n <= reg_addr;
			WHEN reg_addr =>
				SDA <= 'Z';
				st_n <= ack1;
				timer <= 8;
				
			WHEN ack1 =>

				timer <= 1;
				IF( rd_flag = '1') THEN
					st_n <= reg_read;
				ELSE
					st_n <= reg_write;
				END IF;
				SDA <= 'Z';
			WHEN reg_write =>

				timer <= 8;
				st_n <= ack2;
				SDA <= 'Z';
			WHEN reg_read =>

				timer <= 8;
				st_n <= ack2;
				IF( data_out(7-i) = '1' ) THEN
					SDA <= 'Z';
				ELSE
					SDA <= '0';
				END IF;
			WHEN ack2 =>

				timer <= 1;
				
				IF( SDA = '1' ) THEN
					st_n <= stop;
				ELSE
					st_n <= ack0;
				END IF;
			WHEN stop =>

				st_n <= stop;
				timer <= delay;
			WHEN error =>
				st_n <= stop;
				timer <= delay;
		END CASE;
	END PROCESS;
	
END ARCHITECTURE arch;
