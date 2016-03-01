library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM is
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
END FSM;
architecture lab3 OF FSM IS 
	TYPE state_type IS (start_st, addr0, addr1, addr2,addr3,addr4,addr5,addr6, rw_st, ack_st0, regN, reg0, ack_st1, dataN,data0, ack_st2, stop_st);
	SIGNAL curr_state: state_type := stop_st;
	SIGNAL bit_cnt   :  UNSIGNED (2 downto 0) := "111";
BEGIN	
	PROCESS( scl, sda, stop, start ) BEGIN
		IF( scl = '0' ) AND (not scl'EVENT) THEN
			CASE curr_state IS
				WHEN start_st =>
					curr_state <= addr6;
					enclk <= '1';
				WHEN addr6 =>
					curr_state <= addr5;
					enclk <= '1';
				WHEN addr5 =>
					curr_state <= addr4;
					enclk <= '1';
				WHEN addr4 =>
					curr_state <= addr3;
					enclk <= '1';
				WHEN addr3 =>
					curr_state <= addr2;
					enclk <= '1';
				WHEN addr2 =>
					curr_state <= addr1;
					enclk <= '1';
				WHEN addr1 =>
					curr_state <= addr0;
					enclk <= '1';
				WHEN addr0 =>
					curr_state <= rw_st;
					enclk <= '1';
				WHEN rw_st =>
					curr_state <= ack_st0;
					enclk <= '1';
				WHEN ack_st0 =>
					IF( sda = '0' ) THEN
						curr_state <= ack_st0;
						enclk <= '0';
					ELSE
						enclk <= '1';
						curr_state <= reg0;
						bit_cnt <= "111";
					END IF;
				WHEN regN =>
					IF( bit_cnt = 0 ) THEN
						curr_state <= reg0;
						enclk <= '1';
					ELSE
						curr_state <= regN;
						enclk <= '1';
						bit_cnt <= bit_cnt - 1;
					END IF;
				WHEN reg0 =>
					curr_state <= ack_st1;
					enclk <= '1';
				WHEN ack_st1 => 
					IF( sda = '0' ) THEN
						curr_state <= ack_st1;
						enclk <= '0';
					ELSE
						enclk <= '1';
						curr_state <= data0;
						bit_cnt <= "111";
					END IF;
				WHEN dataN =>
					IF( bit_cnt = 0 ) THEN
						curr_state <= data0;
						enclk <= '1';
					ELSE
						curr_state <= dataN;
						enclk <= '1';
						bit_cnt <= bit_cnt - 1;
					END IF;
				WHEN data0 =>
					curr_state <= ack_st2;
					enclk <= '1';
				WHEN ack_st2 =>
					IF( sda = '0' ) THEN
						curr_state <= ack_st2;
						enclk <= '0';
					ELSE
						enclk <= '1';
						curr_state <= dataN;
						bit_cnt <= "111";
					END IF;
				WHEN stop_st =>
						curr_state <= stop_st;
						enclk <= '0';
			END CASE;
		ELSIF ( stop = '1' ) THEN
			curr_state <= stop_st;
			enclk <= '0';
		ELSIF ( start = '1' ) THEN
			curr_state <= start_st;
			enclk <= '1';
		END IF;
	END PROCESS;
	PROCESS(curr_state) BEGIN
		CASE curr_state IS
			WHEN start_st => 
				bit_cnt <= "111";
				number <= "000";
				addr <= '0';
				ack0 <= '0';
				ack1 <= '0';
				ack2 <= '0';
				rw <= '0';
				data <= '0';
				reg <= '0';
			WHEN addr6 =>
				number <= "110";
				addr <= '1';
				ack0 <= '0';
				ack1 <= '0';
				ack2 <= '0';
				rw <= '0';
				data <= '0';
				reg <= '0';
			WHEN addr5 =>
				number <= "101";
				addr <= '1';
				ack0 <= '0';
				ack1 <= '0';
				ack2 <= '0';
				rw <= '0';
				data <= '0';
				reg <= '0';
			WHEN addr4 =>
				number <= "100";
				addr <= '1';
				ack0 <= '0';
				ack1 <= '0';
				ack2 <= '0';
				rw <= '0';
				data <= '0';
				reg <= '0';
			WHEN addr3 =>
				number <= "011";
				addr <= '1';
				ack0 <= '0';
				ack1 <= '0';
				ack2 <= '0';
				rw <= '0';
				data <= '0';
				reg <= '0';
			WHEN addr2 =>
				number <= "010";
				addr <= '1';
				ack0 <= '0';
				ack1 <= '0';
				ack2 <= '0';
				rw <= '0';
				data <= '0';
				reg <= '0';
			WHEN addr1 =>
				number <= "001";
				addr <= '1';
				ack0 <= '0';
				ack1 <= '0';
				ack2 <= '0';
				rw <= '0';
				data <= '0';
				reg <= '0';
			WHEN addr0 =>
				number <= "000";
				addr <= '1';
				ack0 <= '0';
				ack1 <= '0';
				ack2 <= '0';
				rw <= '0';
				data <= '0';
				reg <= '0';
			WHEN rw_st =>
				number <= "111";
				addr <= '1';
				ack0 <= '1';
				ack1 <= '0';
				ack2 <= '0';
				rw <= sda;
				data <= '0';
				reg <= '0';
			WHEN ack_st0 =>
				number <= "000";
				addr <= '0';
				ack0 <= '1';
				ack1 <= '0';
				ack2 <= '0';
				rw <= '0';
				data <= '0';
				reg <= '0';
			WHEN regN =>
				number <= bit_cnt;
				addr <= '0';
				ack0 <= '0';
				ack1 <= '0';
				ack2 <= '0';
				rw <= '0';
				data <= '0';
				reg <= '1';
			WHEN reg0 =>
				number <= bit_cnt;
				addr <= '0';
				ack0 <= '0';
				ack1 <= '0';
				ack2 <= '0';
				rw <= '0';
				data <= '0';
				reg <= '1';
			WHEN ack_st1 =>
				number <= "111";
				addr <= '0';
				ack0 <= '0';
				ack1 <= '1';
				ack2 <= '0';
				rw <= '0';
				data <= '0';
				reg <= '0';
			WHEN dataN =>
				number <= bit_cnt;
				addr <= '0';
				ack0 <= '0';
				ack1 <= '0';
				ack2 <= '0';
				rw <= '0';
				data <= '1';
				reg <= '0';
			WHEN data0 =>
				number <= bit_cnt;
				addr <= '0';
				ack0 <= '0';
				ack1 <= '0';
				ack2 <= '0';
				rw <= '0';
				data <= '1';
				reg <= '0';
			WHEN ack_st2 =>
				number <= "111";
				addr <= '0';
				ack0 <= '0';
				ack1 <= '0';
				ack2 <= '1';
				rw <= '0';
				data <= '0';
				reg <= '0';
			WHEN stop_st =>
				number <= "000";
				addr <= '0';
				ack0 <= '0';
				ack1 <= '0';
				ack2 <= '0';
				rw <= '0';
				data <= '0';
				reg <= '0';
		END CASE;
	END PROCESS;
END lab3;

