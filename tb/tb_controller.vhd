library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_controller is
--  Port ( );
end tb_controller;

architecture DUT of tb_controller is

	component controller is
		port
		(
			clk							: in std_logic;
			--reset_i					: in std_logic;
			instruction_i 				: in std_logic_vector(31 downto 0):= (others=> '0');
			alu_comparison_i			: in std_logic_vector(2 downto 0);
			
			--reset_o					: out std_logic;
			register_wr_en_o			: out std_logic;
			alu_select_o				: out std_logic_vector(3 downto 0);
			alu_a_mux_o					: out std_logic;
			alu_b_mux_o					: out std_logic;
			register_c_mux_o			: out std_logic_vector(1 downto 0);
			data_memory_i_mux_o			: out std_logic_vector(1 downto 0);
			data_memory_wr_en_o			: out std_logic;
			pc_alu_a_mux_o				: out std_logic;
			pc_alu_b_mux_o				: out std_logic;
			expander_imm_select_o		: out std_logic_vector(2 downto 0);
			expander_load_select_o		: out std_logic_vector(2 downto 0);
			
			rs1_instruction_o			: out std_logic_vector(4 downto 0);
			rs2_instruction_o			: out std_logic_vector(4 downto 0);
			rd_instruction_o			: out std_logic_vector(4 downto 0)
		);
	end component;
	
-------------------------------------------------Signals--------------------------------------------
	constant clock_period   : time := 20 ns;

	signal clk				: std_logic := '0';
	signal instruction_i	: std_logic_vector(31 downto 0);
	signal alu_comparison_i : std_logic_vector(2 downto 0);

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
	controller_test : controller 
	port map
	(
		clk							=> clk,
		--reset_i					=>
		instruction_i 				=> instruction_i,
		alu_comparison_i			=> alu_comparison_i
	);

	process
	begin
		--LUI test
		instruction_i 		<= x"00108093"; --addi x1, x1, 1
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--AUIPC test
		instruction_i 		<= x"00001097"; --auipc x1, 1
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--JAL test
		instruction_i 		<= x"fe9ff2ef"; --jal x5, -24	
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--JALR test
		instruction_i 		<= x"004080e7"; --jalr x1, x1, 4
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--BEQ test
		instruction_i 		<= x"00208563"; --beq  x1, x2, 10
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--BNE test
		instruction_i 		<= x"fe209ee3"; --bne x1, x2, -4
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--BLT test
		instruction_i 		<= x"fe20cee3"; --blt x1, x2, -4
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--BGE test
		instruction_i 		<= x"fe20dce3"; --bge x1, x2, -8
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--BLTU test
		instruction_i 		<= x"0020e463"; -- bltu x1, x2, 8
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--BGEU test
		instruction_i 		<= x"fe20fee3"; --bgeu x1, x2, -4
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--LB test
		instruction_i 		<= x"00000283"; --lb x5, 0(x0)
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--LH test
		instruction_i 		<= x"00001183"; -- lh x3, 0(x0)	
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--LW test
		instruction_i 		<= x"00002103"; --lw x2, 0(x0)
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--LBU test
		instruction_i 		<= x"00004303"; --lbu x6, 0(x0)	
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--LHU test
		instruction_i 		<= x"00005203"; --lhu x4, 0(x0)
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--SB test
		instruction_i 		<= x"00108023"; --sb x1, 0(x1)
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--SH test
		instruction_i 		<= x"00109023"; --sh x1, 0(x1)
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--SW test
		instruction_i 		<= x"0010a223"; --sw x1, 4(x1)
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--ADDI test
		instruction_i 		<= x"fff08093"; --addi x1, x1, -1
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--SLTI test
		instruction_i 		<= x"00412093"; --slti x1, x2, 4
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--SLTIU test
		instruction_i 		<= x"0010b393"; --SLTIU x7, x1, 1
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--XORI test
		instruction_i 		<= x"fff1c193"; --xori x3, x3, -1
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--ORI test
		instruction_i 		<= x"06416093"; --ori x1, x2, 100
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--ANDI test
		instruction_i 		<= x"06417093"; --andi x1, x2, 100
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--SLLI test
		instruction_i 		<= x"06411093"; --slli x1, x2, 100 
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--SRLI test
		instruction_i 		<= x"06415093"; --srli x1, x2, 100
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--SRAI test
		instruction_i 		<= x"46415093"; --srai x1, x2, 100 
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--ADD test
		instruction_i 		<= x"002081B3"; --add x3, x1, x2
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--SUB test
		instruction_i 		<= x"402081B3"; --sub x3, x1, x2
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--SLL test
		instruction_i 		<= x"002091b3"; --sll x3, x1, x2
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--SLT test
		instruction_i 		<= x"003120b3"; --slt x1, x2, x3 
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--SLTU test
		instruction_i 		<= x"003130b3"; --sltu x1, x2, x3
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--XOR test
		instruction_i 		<= x"0020C1B3"; --xor x4, x1, x2
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--SRL test
		instruction_i 		<= x"0020d1b3"; --srl x3, x1, x2
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--SRA test
		instruction_i 		<= x"4020d1b3"; --sra x3, x1, x2
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--OR test
		instruction_i 		<= x"003160b3"; --or x1, x2, x3
		alu_comparison_i 	<= "000";
		wait for clock_period;
		--AND test
		instruction_i 		<= x"0000f0b3"; --and x1, x1, x0
		alu_comparison_i 	<= "000";
		wait for clock_period;	
		wait;

	end process;
	
end DUT;
