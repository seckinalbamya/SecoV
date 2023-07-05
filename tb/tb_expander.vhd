library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_expander is

		
end tb_expander;

architecture DUT of tb_expander is

	component expander is
		port
		(
			clk					: in std_logic;
			instruction_i		: in std_logic_vector(31 downto 0);
			immediate_select_i	: in std_logic_vector(2 downto 0);
			-- output
			data_o				: out std_logic_vector(31 downto 0)
		);

	end component;

---------------------------------------------------------------------------------------------------
	signal clk					: std_logic := '0';
	constant clock_period  		: time 		:= 20 ns;
 
	signal instruction_i		: std_logic_vector(31 downto 0);
	signal immediate_select_i	: std_logic_vector(2 downto 0);
	-- outputs              
	signal data_o				: std_logic_vector(31 downto 0);
		
		
---------------------------------------------------------------------------------------------------
	begin

		-- ROM:
		expander_test: expander 
		port map
		(
			clk					=> clk,		
			instruction_i		=> instruction_i,
			immediate_select_i => immediate_select_i,
			-- outputs
			data_o	 			=> data_o
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
		instruction_i 		<= x"00508093";-- addi x1, x1, 5	
		immediate_select_i 	<= "000";
		wait for clock_period;
		instruction_i 		<= x"000020b7";-- lui x1, 2				
		immediate_select_i 	<= "001";
		wait for clock_period;
		instruction_i 		<= x"0010a223";-- sw x1, 4(x1)			
		immediate_select_i 	<= "010";
		wait for clock_period;
		instruction_i 		<= x"fe2080e3";-- beq x1, x2, -32
		immediate_select_i 	<= "011";
		wait for clock_period;
		instruction_i 		<= x"fe1ff36f";-- jal x6, -32			
		immediate_select_i 	<= "100";
		wait for clock_period;
		wait;

	end process;
end DUT;
