--NOT verified;
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity cpu is
	port
	(
		clk_100			: in std_logic;
		--reset_i		: in std_logic;
		--peripherals
		peripheral_i	: in std_logic_vector(15 downto 0);
		peripheral_o	: out std_logic_vector(15 downto 0)
	);
end cpu;

architecture arch of cpu is
-------------------------------------------------Components----------------------------------------
	component alu is
		port
		(
			a_i			: in std_logic_vector(31 downto 0) := (others => '0');
			b_i			: in std_logic_vector(31 downto 0) := (others => '0');
			select_i	: in std_logic_vector(3 downto 0);
			-- outputs
			data_o		: out std_logic_vector(31 downto 0) := (others => '0');
			comparison_o: out std_logic_vector(2 downto 0)--isequal and signed and unsigned comparison result
		);
	end component;
	
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
    
	component data_memory is
		generic
		(
			memory_size		: in std_logic_vector(31 downto 0)
		);
		port
		(
			clk			: in std_logic;
			wr_en_i		: in std_logic;
			address_i	: in std_logic_vector(31 downto 0);
			data_i		: in std_logic_vector(31 downto 0);
			-- outputs
			data_o		: out std_logic_vector(31 downto 0);
			--peripherals
			peripheral_i: in std_logic_vector(15 downto 0);
			peripheral_o: out std_logic_vector(15 downto 0)
		);
	end component;
	
	component program_memory is
		generic
		(
			memory_size		: in std_logic_vector(31 downto 0)
		);
		port
		(
			clk				: in std_logic;
			address_i		: in std_logic_vector(31 downto 0);
			-- outputs
			instruction_o	: out std_logic_vector(31 downto 0)
		);
	end component;

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
	
	component expander_load is
		port
		(
			clk			: in std_logic;
			data_i		: in std_logic_vector(31 downto 0);
			select_i	: in std_logic_vector(2 downto 0);
			-- output
			data_o		: out std_logic_vector(31 downto 0)
		);
	end component;
	
	component controller is
		port
		(
			clk							: in std_logic;
			--reset_i					: in std_logic;
			instruction_i 				: in std_logic_vector(31 downto 0):= (others=> '0');
			alu_comparison_i			: in std_logic_vector(2 downto 0);
			
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
	
	component pc_register is
		port
		(
			clk				: in std_logic;
			reset_i			: in std_logic;
			data_i			: in std_logic_vector(31 downto 0) := (others => '0');
			-- output(s)
			data_o		: out std_logic_vector(31 downto 0):= (others => '0')
		);
	end component;
	
	component pc_adder is
		port
		(	
			a_i				: in std_logic_vector(31 downto 0) := (others => '0');
			b_i				: in std_logic_vector(31 downto 0) := (others => '0');
			-- outputs
			data_o			: out std_logic_vector(31 downto 0) := (others => '0')
		);
    end component;
	
	component clk_divider_ip
		port
		(
			clk_50		: out std_logic;
			clk_100     : in std_logic
		);
	end component;

-------------------------------------------------Signals-------------------------------------------
	--clk signal
	signal clk 							:std_logic;
	--ALU signals
	signal alu_a						: std_logic_vector(31 downto 0);
	signal alu_b						: std_logic_vector(31 downto 0);
	signal alu_o						: std_logic_vector(31 downto 0);
	signal alu_select					: std_logic_vector(3 downto 0);
	signal alu_comparison				: std_logic_vector(2 downto 0);
	signal alu_a_mux					: std_logic;
	signal alu_b_mux					: std_logic;
	--Register signals	        		
	signal register_a_data				: std_logic_vector(31 downto 0);
	signal register_b_data				: std_logic_vector(31 downto 0);
	signal register_c_data				: std_logic_vector(31 downto 0);
	signal register_wr_en				: std_logic;
	signal register_c_mux				: std_logic_vector(1 downto 0);
	signal rs1_instruction 				: std_logic_vector(4 downto 0);
	signal rs2_instruction 				: std_logic_vector(4 downto 0);
	signal rd_instruction 				: std_logic_vector(4 downto 0);
	--Data memory signals       		
	signal data_memory_wr_en			: std_logic;
	signal data_memory_i				: std_logic_vector(31 downto 0);
	signal data_memory_o				: std_logic_vector(31 downto 0);
	signal data_memory_i_mux			: std_logic_vector(1 downto 0);
	--Expanders signals          		
	signal expander_data				: std_logic_vector(31 downto 0);
	signal expander_imm_select			: std_logic_vector(2 downto 0);
	signal expander_load_select			: std_logic_vector(2 downto 0);
	signal expander_load_data			: std_logic_vector(31 downto 0);
	--PC signals                		
	signal pc_alu_a_mux					: std_logic;
	signal pc_alu_b_mux					: std_logic;
	signal pc_alu_a_i					: std_logic_vector(31 downto 0);
	signal pc_alu_b_i					: std_logic_vector(31 downto 0);
	signal pc_alu_o						: std_logic_vector(31 downto 0) := (others => '0');
	signal pc							: std_logic_vector(31 downto 0) := (others => '0');
	signal pc_plus_four					: std_logic_vector(31 downto 0);
	signal instruction					: std_logic_vector(31 downto 0);
	--temporary signal(s)
	signal temp 						: std_logic;
    signal reset_i 						: std_logic := '0';
	
begin

	--register_c_data MUX design
	register_c_data		<= 	alu_o				when register_c_mux = "00" else
							expander_load_data	when register_c_mux = "01" else
							pc_plus_four		when register_c_mux = "10" else
							expander_data		when register_c_mux = "11" else
							x"00000000";
	--alu_a MUX design
	alu_a 				<=  register_a_data 	when alu_a_mux = '0' else
							pc_alu_o			when alu_a_mux = '1' else
							x"00000000";
	--alu_b MUX design
	alu_b 				<=  register_b_data 	when alu_b_mux = '0' else
							expander_data		when alu_b_mux = '1' else
							x"00000000";
	--pc_alu_a_i MUX design
	pc_alu_a_i			<=  x"00000004"			when pc_alu_a_mux = '0' else --4(32bit)
							expander_data		when pc_alu_a_mux = '1' else
							x"00000000";
	--pc_alu_b_i MUX design
	pc_alu_b_i			<=  pc					when pc_alu_b_mux = '0' else
							register_a_data 	when pc_alu_b_mux = '1' else
							x"00000000";
	--data_memory_i MUX design
	data_memory_i		<= 	register_b_data(7) & register_b_data(7) & register_b_data(7) & register_b_data(7) &
							register_b_data(7) & register_b_data(7) & register_b_data(7) & register_b_data(7) &
							register_b_data(7) & register_b_data(7) & register_b_data(7) & register_b_data(7) &
							register_b_data(7) & register_b_data(7) & register_b_data(7) & register_b_data(7) &
							register_b_data(7) & register_b_data(7) & register_b_data(7) & register_b_data(7) &
							register_b_data(7) & register_b_data(7) & register_b_data(7) & register_b_data(7) &
							register_b_data(7 downto 0)  when data_memory_i_mux = "10" else
							register_b_data(15) & register_b_data(15) & register_b_data(15) & register_b_data(15) &
							register_b_data(15) & register_b_data(15) & register_b_data(15) & register_b_data(15) &
							register_b_data(15) & register_b_data(15) & register_b_data(15) & register_b_data(15) &
							register_b_data(15) & register_b_data(15) & register_b_data(15) & register_b_data(15) &
							register_b_data(15 downto 0) when data_memory_i_mux = "01" else
							register_b_data				 when data_memory_i_mux = "00" else							
							x"00000000";

-------------------------------------------------Port and generic map defines----------------------							
		
	main_alu : alu 
	port map
	(
		a_i				=> alu_a,
		b_i				=> alu_b,
		select_i		=> alu_select,
		-- outputs  	
		data_o			=> alu_o,
		comparison_o	=> alu_comparison
	);
	
	main_registers : registers 
	port map
	(
		clk				=> clk,
		reset_i			=> reset_i,
		a_address_i		=> rs1_instruction,
		b_address_i		=> rs2_instruction,
		c_address_i		=> rd_instruction,
		wr_en_i			=> register_wr_en,
		
		c_data_i		=> register_c_data,
		a_data_o		=> register_a_data,
		b_data_o		=> register_b_data
	);
	
	main_data_memory : data_memory
	generic map
	(
		memory_size => x"000001FF"
	)
	port map
	(
		clk			=> clk,
		address_i	=> alu_o,	
		wr_en_i		=> data_memory_wr_en,
		data_i		=> data_memory_i,
		-- outputs
		data_o		=> data_memory_o,
		--peripherals
		peripheral_i=> peripheral_i,
		peripheral_o=> peripheral_o
	);
	
	main_program_memory : program_memory
	generic map
	(
		memory_size 	=> x"0000003F"
	)
	port map
	(
		clk				=> clk,
		address_i		=> pc,
		-- outputs
		instruction_o	=> instruction
	);
	
	main_expander : expander
	port map
	(
		clk					=> clk,
		instruction_i		=> instruction,
		immediate_select_i	=> expander_imm_select,
		-- output   
		data_o				=> expander_data
	);

	main_expander_load : expander_load
		port map
		(
			clk			=> clk,
			data_i		=> data_memory_o,
			select_i 	=> expander_load_select,
			-- output
			data_o		=> expander_load_data
		);
	
	main_controller : controller
	port map
	(
	   clk						=> clk,
	   instruction_i 			=> instruction,
	   alu_comparison_i			=> alu_comparison,
								
	   register_wr_en_o			=> register_wr_en,
	   alu_select_o				=> alu_select,
	   alu_a_mux_o				=> alu_a_mux,
	   alu_b_mux_o				=> alu_b_mux,
	   register_c_mux_o			=> register_c_mux,
	   data_memory_i_mux_o		=> data_memory_i_mux,
	   data_memory_wr_en_o		=> data_memory_wr_en,	
	   pc_alu_a_mux_o    		=> pc_alu_a_mux,		
	   pc_alu_b_mux_o    		=> pc_alu_b_mux,		
	   expander_imm_select_o	=> expander_imm_select,
	   expander_load_select_o	=> expander_load_select,
							       			
	   rs1_instruction_o	    => rs1_instruction,
	   rs2_instruction_o	    => rs2_instruction,    
	   rd_instruction_o		    => rd_instruction		    
	);
	
	main_pc : pc_register
		port map
		(
			clk			=> clk,
			reset_i		=> '0',
			data_i		=> (pc_alu_o(31 downto 1) & '0'),--ignore the least significant bit
			data_o		=> pc
		);
	
	main_pc_adder : pc_adder
	port map
	(
		a_i			=> pc_alu_a_i,
		b_i			=> pc_alu_b_i,
		-- outputs  
		data_o		=> pc_alu_o
	);	
	
	main_pc_plus_four : pc_adder 
	port map
	(
		a_i			=> x"00000004",
		b_i			=> pc,
		-- outputs  
		data_o		=> pc_plus_four
	);

	main_clk_divider : clk_divider_ip
		port map
		( 
			clk_50 => clk,
			clk_100 => clk_100
		);

end architecture;