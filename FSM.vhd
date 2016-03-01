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
	TYPE state_type IS (start_st, addr0, ack_st0, reg0, ack_st1, data0, ack_st2, stop_st);
	SIGNAL curr_state: state_type := stop_st;
BEGIN	
	PROCESS( scl, sda, stop, start ) BEGIN
		IF( scl = '0' ) AND (not scl'EVENT) THEN
			CASE curr_state IS
				WHEN start_st =>
					curr_state <= addr0;
					enclk <= '1';
				WHEN addr0 =>
					curr_state <= ack_st0;
					enclk <= '1';
				WHEN ack_st0 =>
					IF( sda = '0' ) THEN
						curr_state <= ack_st0;
						enclk <= '0';
					ELSE
						enclk <= '1';
						curr_state <= reg0;
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
						curr_state <= data0;
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
				number <= "000";
				addr <= '0';
				ack0 <= '0';
				ack1 <= '0';
				ack2 <= '0';
				rw <= '0';
				data <= '0';
				reg <= '0';
			WHEN addr0 =>
				number <= "111";
				addr <= '1';
				ack0 <= '0';
				ack1 <= '0';
				ack2 <= '0';
				rw <= '0';
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
			WHEN reg0 =>
				number <= "111";
				addr <= '0';
				ack0 <= '0';
				ack1 <= '0';
				ack2 <= '0';
				rw <= '0';
				data <= '0';
				reg <= '1';
			WHEN ack_st1 =>
				number <= "000";
				addr <= '0';
				ack0 <= '0';
				ack1 <= '1';
				ack2 <= '0';
				rw <= '0';
				data <= '0';
				reg <= '0';
			WHEN data0 =>
				number <= "111";
				addr <= '0';
				ack0 <= '0';
				ack1 <= '0';
				ack2 <= '0';
				rw <= '0';
				data <= '1';
				reg <= '0';
			WHEN ack_st2 =>
				number <= "000";
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

