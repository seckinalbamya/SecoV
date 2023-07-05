library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_registers  is

		
end tb_registers ;

architecture DUT of tb_registers is

	component registers is
		port
		(
			clk				: in std_logic;
			reset_i			: in std_logic;
			a_address_i		: in std_logic_vector(4 downto 0);
			b_address_i		: in std_logic_vector(4 downto 0);
			c_address_i		: in std_logic_vector(4 downto 0);
			wr_en_i        	: in std_logic;

			c_data_i		: in std_logic_vector(31 downto 0);
			-- outputs	
			a_data_o		: out std_logic_vector(31 downto 0);
			b_data_o		: out std_logic_vector(31 downto 0)
		);
	end component;

---------------------------------------------------------------------------------------------------
	signal clk				: std_logic;
	constant clock_period   : time := 20 ns;

	signal reset_i			: std_logic;
	signal wr_en_i			: std_logic;		

	signal a_address_i		: std_logic_vector(4 downto 0) := (others => '0');
	signal b_address_i		: std_logic_vector(4 downto 0) := (others => '0');
	signal c_address_i		: std_logic_vector(4 downto 0) := (others => '0');
	
	signal c_data_i			: std_logic_vector(31 downto 0) := (others => '0');
	signal a_data_o			: std_logic_vector(31 downto 0) := (others => '0');
	signal b_data_o			: std_logic_vector(31 downto 0) := (others => '0');
	
---------------------------------------------------------------------------------------------------
	begin
	
	registers_test : registers 
	port map
	(
		clk				=> clk,
		reset_i			=> reset_i,
		a_address_i		=> a_address_i,
		b_address_i		=> b_address_i,
		c_address_i		=> c_address_i,
		wr_en_i			=> wr_en_i,   
	
		c_data_i		=> c_data_i,
		a_data_o		=> a_data_o,
		b_data_o		=> b_data_o
	);
	
-------------------------------------------------clock generator-----------------------------------
	clock_process: process
		begin
			clk <= '0';
			wait for clock_period/2;
			clk <= '1';
			wait for clock_period/2;
		end process;
---------------------------------------------------------------------------------------------------
	
	process
	begin
		reset_i			<= '0';
		a_address_i		<= "00001";--1
		b_address_i		<= "00010";--2
		c_address_i		<= "00001";--1
		wr_en_i 		<= '1';  
		-- outputs      
		c_data_i		<= x"00000001";
		wait for clock_period;

		a_address_i		<= "00001";
		b_address_i		<= "00010";
		c_address_i		<= "00010";
		wr_en_i 		<= '1';    
		c_data_i		<= x"00000010";
		
		wait for clock_period;
		a_address_i		<= "11111";
		b_address_i		<= "00010";
		c_address_i		<= "11111";
		wr_en_i 		<= '0';  
		c_data_i		<= x"00000006";
		wait for clock_period;
		reset_i			<= '1';
		wait for clock_period;
		reset_i			<= '0';
		a_address_i		<= "00001";
		b_address_i		<= "00010";
		wait for clock_period;
		reset_i			<= '0';
		a_address_i		<= "00011";
		b_address_i		<= "00100";

		wait for clock_period;
		wr_en_i 		<= '1';    
		reset_i			<= '0';
		a_address_i		<= "00011";
		b_address_i		<= "00001";
		c_address_i		<= "01111";
		c_data_i		<= x"00000022";
		wait for clock_period;
		reset_i			<= '0';
		a_address_i		<= "00111";
		b_address_i		<= "00100";
		c_address_i		<= "00011";
		c_data_i		<= x"00000022";
		wait for clock_period;
		wr_en_i 		<= '0';    
		reset_i			<= '0';
		a_address_i		<= "00011";
		b_address_i		<= "00001";
		c_data_i		<= x"00000022";
		wait for clock_period;
		reset_i			<= '0';
		a_address_i		<= "00111";
		b_address_i		<= "00100";
		c_data_i		<= x"00000022";
		wait for clock_period;
		wait;
	end process;
	--asdasdsad
end DUT;
