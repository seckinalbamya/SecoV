library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;


entity tb_alu is
--  Port ( );
end tb_alu;

architecture DUT of tb_alu is

	component alu is
		port
		(
			a_i			: in std_logic_vector(31 downto 0) := (others => '0');
			b_i			: in std_logic_vector(31 downto 0) := (others => '0');
			select_i	: in std_logic_vector(3 downto 0);
			-- outputs
			data_o		: out std_logic_vector(31 downto 0) := (others => '0');
			comparison_o: out std_logic_vector(2 downto 0)--signed and unsigned comparison result
		);

	end component;
-------------------------------------------------Signals--------------------------------------------
	constant clock_period   : time := 20 ns;

	signal clk			: std_logic := '0';
	signal a_i			: std_logic_vector(31 downto 0);
	signal b_i			: std_logic_vector(31 downto 0);
	signal select_i		: std_logic_vector(3 downto 0);
	-- outputs        	
	signal data_o		: std_logic_vector(31 downto 0);
	signal comparison_o	: std_logic_vector(2 downto 0);
	
	type state_operation is  (add_operation, sub_operation, and_operation, xor_operation, 
							  or_operation, sll_operation,srl_operation, sra_operation, slt_operation, sltu_operation, problem_operation);		
    signal current_operation : state_operation := problem_operation; 

begin
-------------------------------------------------clock generator-----------------------------------
		clock_process: process
               begin
                    clk <= '0';
                    wait for clock_period/2;
                    clk <= '1';
                    wait for clock_period/2;
               end process;
---------------------------------------------------------------------------------------------------
	alu_test : alu 
	port map
		(
			a_i				=> a_i,
			b_i				=> b_i,
			select_i		=> select_i,
			-- outputs  
			data_o			=> data_o,
			comparison_o	=> comparison_o
		);

	current_operation <= 	add_operation 	when select_i = "0000" else--add
							sub_operation 	when select_i = "0001" else--sub
							sll_operation 	when select_i = "0010" else--sll
							slt_operation 	when select_i = "0011" else--slt
							sltu_operation 	when select_i = "0100" else--sltu
							xor_operation 	when select_i = "0101" else--xor
							srl_operation 	when select_i = "0110" else--srl
							sra_operation 	when select_i = "0111" else--sra
							or_operation 	when select_i = "1000" else--or
							and_operation 	when select_i = "1001" else--and
							problem_operation;

	process
	begin
		--add------------------------------------
		--0+0
		a_i 		<= x"00000000";
		b_i 		<= x"00000000";
		select_i	<= "0000";
		wait for clock_period;
		--2+1
		a_i 		<= x"00000002";
		b_i 		<= x"00000001";
		select_i	<= "0000";
		wait for clock_period;
		--(-2)+1
		a_i 		<= "11111111111111111111111111111110";
		b_i 		<= x"00000001";
		select_i	<= "0000";
		wait for clock_period;
		--FFFFFFFF + 1
		a_i 		<= x"FFFFFFFF";
		b_i 		<= x"00000001";
		select_i	<= "0000";
		wait for clock_period;
		--1 + FFFFFFFF
		a_i 		<= x"00000001";
		b_i 		<= x"FFFFFFFF";
		select_i	<= "0000";
		wait for clock_period;
		--sub------------------------------------
		--0-0
		a_i 		<= x"00000000";
		b_i 		<= x"00000000";
		select_i	<= "0001";
		wait for clock_period;
		--2-1
		a_i 		<= x"00000002";
		b_i 		<= x"00000001";
		select_i	<= "0001";
		wait for clock_period;
		--1-2
		a_i 		<= x"00000001";
		b_i 		<= x"00000002";
		select_i	<= "0001";
		wait for clock_period;
		--1-(-2)
		a_i 		<= x"00000001";
		b_i 		<= "11111111111111111111111111111110";
		select_i	<= "0001";
		--FFFFFFFF - 1
		a_i 		<= x"FFFFFFFF";
		b_i 		<= x"00000001";
		select_i	<= "0001";
		wait for clock_period;
		--1 - FFFFFFFF
		a_i 		<= x"00000001";
		b_i 		<= x"FFFFFFFF";
		select_i	<= "0001";
		wait for clock_period;
		--0 - FFFFFFFF
		a_i 		<= x"00000000";
		b_i 		<= x"FFFFFFFF";
		select_i	<= "0001";
		wait for clock_period;
		--and------------------------------------
		--0 and 0
		a_i 		<= x"00000000";
		b_i 		<= x"00000000";
		select_i	<= "1001";
		wait for clock_period;
		a_i 		<= x"00000abc";
		b_i 		<= x"00000abc";
		select_i	<= "1001";
		wait for clock_period;
		a_i 		<= x"00000abc";
		b_i 		<= x"abc00000";
		select_i	<= "1001";
		wait for clock_period;
		--xor------------------------------------
		--0 xor 0
		a_i 		<= x"00000000";
		b_i 		<= x"00000000";
		select_i	<= "0101";
		wait for clock_period;
		--00000abc xor 00000abc
		a_i 		<= x"00000abc";
		b_i 		<= x"00000abc";
		select_i	<= "0101";
		wait for clock_period;
		--abc00000 xor 00000abc
		a_i 		<= x"00000abc";
		b_i 		<= x"abc00000";
		select_i	<= "0101";
		wait for clock_period;
		--00000abc xor abc00abc
		a_i 		<= x"00000abc";
		b_i 		<= x"abc00abc";
		select_i	<= "0101";
		wait for clock_period;
		--or------------------------------------
		--0 or 0
		a_i 		<= x"00000000";
		b_i 		<= x"00000000";
		select_i	<= "1000";
		wait for clock_period;
		--00000abc or 00000abc
		a_i 		<= x"00000abc";
		b_i 		<= x"00000abc";
		select_i	<= "1000";
		wait for clock_period;
		--abc00000 or 00000abc
		a_i 		<= x"00000abc";
		b_i 		<= x"abc00000";
		select_i	<= "1000";
		wait for clock_period;
		--sll------------------------------------
		-- 0 sll 1
		a_i 		<= "00000000000000000000000000000000";
		b_i 		<= x"00000001";
		select_i	<= "0010";
		wait for clock_period;
		-- 1 sll 1
		a_i 		<= "00000000000000000000000000000001";
		b_i 		<= x"00000001";
		select_i	<= "0010";
		wait for clock_period;
		--- 1 sll 5
		a_i 		<= "00000000000000000000000000000001";
		b_i 		<= x"00000005";
		select_i	<= "0010";
		wait for clock_period;
		--- sll extrem
		a_i 		<= "10000000000000000000000000000001";
		b_i 		<= x"00000005";
		select_i	<= "0010";
		wait for clock_period;
		--- sll extrem
		a_i 		<= "10000000000000000000000000000001";
		b_i 		<= x"F0000005";
		select_i	<= "0010";
		wait for clock_period;
		--srl------------------------------------
		-- 0 srl 1
		a_i 		<= "00000000000000000000000000000000";
		b_i 		<= x"00000001";
		select_i	<= "0110";
		wait for clock_period;
		-- 1 srl 1
		a_i 		<= "00000000000000000000000000000001";
		b_i 		<= x"00000001";
		select_i	<= "0110";
		wait for clock_period;
		--- 1 srl 5
		a_i 		<= "00000000000000000000000000000001";
		b_i 		<= x"00000005";
		select_i	<= "0110";
		wait for clock_period;
		--- srl extrem
		a_i 		<= "10000000000000000000000000000001";
		b_i 		<= x"00000005";
		select_i	<= "0110";
		wait for clock_period;
		--- srl extrem
		a_i 		<= "10000000000000000000000000000001";
		b_i 		<= x"F0000005";
		select_i	<= "0110";
		wait for clock_period;
		--sra------------------------------------
		-- 0 srl 1
		a_i 		<= "00000000000000000000000000000000";
		b_i 		<= x"00000001";
		select_i	<= "0111";
		wait for clock_period;
		-- 1 srl 1
		a_i 		<= "10000000000000000000000000000001";
		b_i 		<= x"00000001";
		select_i	<= "0111";
		wait for clock_period;
		--- 1 srl 5
		a_i 		<= "10000000000000000000000000000001";
		b_i 		<= x"00000005";
		select_i	<= "0111";
		wait for clock_period;
		--- srl extrem
		a_i 		<= "10000000000000000000000000000001";
		b_i 		<= x"00000005";
		select_i	<= "0111";
		wait for clock_period;
		--- srl extrem
		a_i 		<= "10000000000000000000000000000001";
		b_i 		<= x"F0000005";
		select_i	<= "0111";
		wait for clock_period;
		--slt------------------------------------
		a_i 		<= "11111111111111111111111111111111";
		b_i 		<= x"00000000";
		select_i	<= "0011";
		wait for clock_period;
		a_i 		<= x"00000000";
		b_i 		<= "11111111111111111111111111111111";
		select_i	<= "0011";
		wait for clock_period;
		a_i 		<= "11111111111111111111111111111111";
		b_i 		<= x"00000000";
		select_i	<= "0011";
		wait for clock_period;
		a_i 		<= x"00000000";
		b_i 		<= x"00000000";
		select_i	<= "0011";
		wait for clock_period;
		--sltu
		a_i 		<= "11111111111111111111111111111111";
		b_i 		<= x"00000000";
		select_i	<= "0100";
		wait for clock_period;
		a_i 		<= x"00000000";
		b_i 		<= "11111111111111111111111111111111";
		select_i	<= "0100";
		wait for clock_period;
		a_i 		<= "11111111111111111111111111111111";
		b_i 		<= x"00000000";
		select_i	<= "0100";
		wait for clock_period;
		a_i 		<= x"00000000";
		b_i 		<= x"00000000";
		select_i	<= "0100";
		wait for clock_period;
		wait;

	end process;
	
end DUT;
