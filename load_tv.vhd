library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

Entity load_tb is 
end entity; 

Architecture tb of load_tb is


	Component LOADER IS
	Port (
		OutM1 	: OUT STD_LOGIC_VECTOR( 7 DOWNTO 0);
		OutM2	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		InM3	: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		--Ena		: In STD_LOGIC;
		Res		: In STD_LOGIC; -- reset


		Addr_W	: Out INTEGER;
		Addr_R	: Out INTEGER;
		WEN		: Out STD_LOGIC;
		EN   	: Out STD_LOGIC;
		RCLK 	: Out STD_LOGIC;
		WCLK	: Out STD_LOGIC;
		DATA_R	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		DATA_W	: Out STD_LOGIC_VECTOR(7 DOWNTO 0);



		Write	: IN STD_LOGIC; -- tells loader to write out to RAM
		Loaded 	: OUT STD_LOGIC;
		Nex 	: IN STD_LOGIC; -- tells the loader to output next value
		LoadM1	: IN STD_LOGIC;
		LoadM2	: IN STD_LOGIC;
		Clk		: IN STD_LOGIC
	);
END component;


signal oM1, oM2 : std_logic_vector( 7 downto 0); 
signal im3 	: std_logic_vector(15 downto 0) := "1010_1010_1010_1010";
signal res, write, nex, lm1, lm2, clk : std_logic := '0';
signal dR : std_logic_vector(7 downto 0) <= "110011_00";
signal dW : std_logic_vector( 7 downto 0);
signal adW, adR : integer;
signal wen, en, rclk, wclk, loaded : std_logic;

BEGIN

		l : LOADER port map( Res=>res, Write=>write,Nex=> nex, LoadM1=>lm1, LoadM2=>lm2,Clk=> clk, 
		DATA_R => dR, DATA_W => dW, WEN=> wen, EN => en, RCLK=> rclk, WCLK=> wclk, Loaded => loaded,
		Addr_W=>adW, Addr_R=> adR, InM3=> im3. OutM1=> oM1, OutM2=> oM2 );
	



clock : process begin
		clk<= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
	end process;

	tes:process begin
	
		res <= '1'; 
		wait for 100 ns;
		res <= '0';

		LoadM1<= '1';
		Wait for 10 ns;
		LoadM1<= '0';

		wait for 20 ns;

		LoadM2 <= '1';
		wait for 10 ns;
		LoadM2 <= '0';
	wait for 20 ns;

	write <= '1';
	wait for 10 ns;
	write <= '0';
	
	wait; 


		end process;


END tb;

