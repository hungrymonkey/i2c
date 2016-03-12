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
		SCL 	: IN STD_LOGIC;
		P		: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 )
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

	type state_t is ( idle, ack0, ack1, ack2, dev_addr, p0, p1, rw, stop, error);
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
	SIGNAL ack_signal: STD_LOGIC := '0';
	SIGNAL p_num : STD_LOGIC_VECTOR( 15 DOWNTO 0 ) := X"0000";
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

	PROCESS ( scl_clk, RESET, SDA ) 
	BEGIN
		IF( RESET = '1' ) THEN
			st <= idle;
			i <= 0;
		ELSIF( rising_edge( scl_clk )) THEN
			IF( i = timer - 1) THEN
				st <= st_n;
				i <= 0;
			ELSE
				i <= 1 + i;
			END IF;
		ELSIF( falling_edge(scl_clk)) THEN
			IF (st = idle) THEN
				rd_flag <= '0';
			END IF;
			IF ( st = p0 OR st = p1  OR st = rw) THEN
				IF( SDA = 'H') THEN
					data_in( 7 - i ) <= '1';
				ELSE
					data_in( 7 - i ) <= '0';
				END IF;
			END IF;
			IF( st = ack0 OR st = ack1 OR st = ack2) THEN
				ack_signal <= SDA;
			END IF;
			IF ( st = rw ) THEN
				rd_flag <= SDA;
			END IF;
		ELSIF ( scl_clk'STABLE ) THEN
			IF( SDA = 'H' )THEN
				stop_signal <= '1';					
			END IF;
		END IF;
	END PROCESS;
	PROCESS ( stop_signal, st, scl_clk, data_clk )
	BEGIN
		CASE st IS
			WHEN idle => 
				SDA <= 'Z';
				p_num <= X"0000";
				IF( SDA = '0') THEN
					st_n <= dev_addr;
				ELSE
					st_n <= idle;
				END IF;
				timer <= 1;
			WHEN dev_addr =>
				SDA <= 'Z';
				
				IF( slave_addr(6-i) = data_in(7-i) ) THEN
					st_n <= rw;
					timer <= 7;

				ELSE
					st_n <= error;
					timer <= 1;

				END IF;

				
			WHEN rw =>
				SDA <= 'Z';
				timer <= 1;
				st_n <= ack0;
			WHEN ack0 =>
				SDA <= 'Z';
				timer <= 1;
				st_n <= p0;
			WHEN p0 =>
				p_num( 15 - i ) <= data_in(7-i);
				SDA <= 'Z';
				st_n <= ack1;
				timer <= 8;
			WHEN ack1 =>
				timer <= 1;
				IF(  stop_signal = '1' ) THEN
					st_n <= p1;
				ELSE
					st_n <= ack1;
				END IF;
				SDA <= 'Z';
			WHEN p1 =>
				p_num( 7 - i ) <= data_in(7-i);
				timer <= 8;
				st_n <= ack2;
				SDA <= 'Z';
			WHEN ack2 =>
				timer <= 1;
				SDA <= 'Z';
				IF(  stop_signal = '1' ) THEN
					st_n <= stop;
				ELSE
					st_n <= ack0;
				END IF;
			WHEN stop =>
				SDA <= 'Z';
				st_n <= stop;
				timer <= delay;
			WHEN error =>
				st_n <= stop;
				timer <= delay;
		END CASE;
	END PROCESS;
	PROCESS( p_num ) BEGIN
		CASE st IS
			WHEN STOP =>
				P <= p_num;
			WHEN OTHERS =>
				P <= X"0000";
		END CASE;
	END PROCESS; 
END ARCHITECTURE arch;
