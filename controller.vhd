--verified
library ieee;
use ieee.std_logic_1164.all;


entity controller is
    port
    (
		clk							: in std_logic;
		--reset_i					: in std_logic;
		instruction_i 				: in std_logic_vector(31 downto 0):= (others=> '0');
		alu_comparison_i			: in std_logic_vector(2 downto 0);
		
		--reset_o						: out std_logic;
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
end controller;

architecture arch of controller is
	
	type state_instruction_type is  (r_type, i_load_type, i_type, s_type, b_type, u_type, u_jump_type, i_jump_type, system_type, problem_type);		
    signal current_type : state_instruction_type := problem_type; 
	
	type state_instruction is  (lui_instruction, auipc_instruction, jal_instruction, jalr_instruction, beq_instruction, bne_instruction, blt_instruction,
								bge_instruction, bltu_instruction, bgeu_instruction, lb_instruction, lh_instruction, lw_instruction, 
								lbu_instruction, lhu_instruction, sb_instruction, sh_instruction, sw_instruction, addi_instruction,
								slti_instruction, sltiu_instruction, xori_instruction, ori_instruction, andi_instruction, slli_instruction,
								srli_instruction, srai_instruction, add_instruction, sub_instruction, sll_instruction, slt_instruction,  
								sltu_instruction, xor_instruction, srl_instruction, sra_instruction, or_instruction, and_instruction, 							
								fence_instruction, fencei_instruction, ecall_instruction, ebreak_instruction, csrrw_instruction,
								csrrs_instruction, csrrc_instruction, csrrwi_instruction, csrrsi_instruction, csrrci_instruction, 
								problem_instruction);	
    signal current_instruction : state_instruction := problem_instruction;
    
	signal opcode : std_logic_vector(6 downto 0);
    signal funct3 : std_logic_vector(2 downto 0);
    signal funct7 : std_logic_vector(6 downto 0);
    
	begin
	
		funct3 <= instruction_i(14 downto 12);
		funct7 <= instruction_i(31 downto 25);
		opcode <= instruction_i(6 downto 0);
		
	process(opcode)--decoding type
	begin

		if		opcode = "0110011" then--R type
			current_type		<= r_type;
		elsif	opcode = "0000011" then--I load type
			current_type		<= i_load_type;
		elsif	opcode = "0010011" then--I type
			current_type		<= i_type;
		elsif	opcode = "0100011" then--S type
			current_type		<= s_type;
		elsif 	opcode = "1100011" then--B type
			current_type		<= b_type;
		elsif	opcode = "0110111" or opcode = "0010111" then--U type
			current_type		<= u_type;
		elsif 	opcode = "1101111" then--U jump type
			current_type		<= u_jump_type;
		elsif	opcode = "1100111" then--I jump type
			current_type		<= i_jump_type;
		elsif	opcode = "1110011" then--SYSTEM type
			current_type		<= system_type;
		else
			current_type		<= problem_type;
	    end if;
	end process;
		
	process(current_type, funct3, funct7, opcode)--decoding instruction
	begin
		
		if 	current_type = u_type and opcode = "0110111" then--U type lui
			current_instruction <= lui_instruction;
		elsif 	current_type = u_type and opcode = "0010111" then--U type auipc
			current_instruction <= auipc_instruction;
		elsif	current_type = u_jump_type then-- uj type jal
			current_instruction <= jal_instruction;
		elsif	current_type = i_jump_type then-- ij type jalr
			current_instruction <= jalr_instruction;
		elsif 	current_type = b_type and funct3 = "000" then--B type beq
			current_instruction <= beq_instruction;
		elsif 	current_type = b_type and funct3 = "001" then--B type bne
			current_instruction <= bne_instruction;
		elsif 	current_type = b_type and funct3 = "100" then--B type blt
			current_instruction <= blt_instruction;
		elsif 	current_type = b_type and funct3 = "101" then--B type bge
			current_instruction <= bge_instruction;
		elsif 	current_type = b_type and funct3 = "110" then--B type bltu
			current_instruction <= bltu_instruction;
		elsif 	current_type = b_type and funct3 = "111" then--B type bgeu
			current_instruction <= bgeu_instruction;
		elsif	current_type = i_load_type and funct3 = "000" then--I load type and lb
			current_instruction <= lb_instruction;
		elsif	current_type = i_load_type and funct3 = "001" then--I load type and lh
			current_instruction <= lh_instruction;
		elsif	current_type = i_load_type and funct3 = "010" then--I load type and lw
			current_instruction <= lw_instruction;
		elsif	current_type = i_load_type and funct3 = "100" then--I load type and lbu
			current_instruction <= lbu_instruction;
		elsif	current_type = i_load_type and funct3 = "101" then--I load type and lhu
			current_instruction <= lhu_instruction;
		elsif	current_type = s_type and	funct3 = "000" then--S type sb
			current_instruction <= sb_instruction;
		elsif	current_type = s_type and	funct3 = "001" then--S type sh
			current_instruction <= sh_instruction;
		elsif	current_type = s_type and	funct3 = "010" then--S type sw
			current_instruction <= sw_instruction;
		elsif	current_type = i_type and funct3 = "000" then--I type and addi
			current_instruction <= addi_instruction;
		elsif	current_type = i_type and funct3 = "010" then--I type and slti
			current_instruction <= slti_instruction;
		elsif	current_type = i_type and funct3 = "011" then--I type and sltiu
			current_instruction <= sltiu_instruction;
		elsif	current_type = i_type and funct3 = "100" then--I type and xori
			current_instruction <= xori_instruction;
		elsif	current_type = i_type and funct3 = "110" then--I type and ori
			current_instruction <= ori_instruction;
		elsif	current_type = i_type and funct3 = "111" then--I type and andi
			current_instruction <= andi_instruction;
		elsif	current_type = i_type and funct3 = "001" then--I type and slli
			current_instruction <= slli_instruction;
		elsif	current_type = i_type and funct7 = "0000000" and funct3 = "101" then--I type and srli
			current_instruction <= srli_instruction;
		elsif	current_type = i_type and funct7 = "0100000" and funct3 = "101" then--I type and srai
			current_instruction <= srai_instruction;
		elsif	current_type = r_type and funct7 = "0000000" and funct3 = "000" then--R type add
			current_instruction <= add_instruction;
		elsif	current_type = r_type and funct7 = "0100000" and funct3 = "000" then--R type sub
			current_instruction <= sub_instruction;
		elsif	current_type = r_type and funct7 = "0000000" and funct3 = "001" then--R type sll
			current_instruction <= sll_instruction;
		elsif	current_type = r_type and funct7 = "0000000" and funct3 = "010" then--R type slt
			current_instruction <= slt_instruction;
		elsif	current_type = r_type and funct7 = "0000000" and funct3 = "011" then--R type sltu
			current_instruction <= sltu_instruction;
		elsif	current_type = r_type and funct7 = "0000000" and funct3 = "100" then--R type xor
			current_instruction <= xor_instruction;
		elsif	current_type = r_type and funct7 = "0000000" and funct3 = "101" then--R type srl
			current_instruction <= srl_instruction;
		elsif	current_type = r_type and funct7 = "0100000" and funct3 = "101" then--R type sra
			current_instruction <= sra_instruction;
		elsif	current_type = r_type and funct7 = "0000000" and funct3 = "110" then--R type or
			current_instruction <= or_instruction;
		elsif	current_type = r_type and funct7 = "0000000" and funct3 = "111" then--R type and
			current_instruction <= and_instruction;
		elsif	current_type = system_type and funct3 = "000" and instruction_i(20) = '0' then--SYSTEM type ecall
			current_instruction <= ecall_instruction;
		elsif	current_type = system_type and funct3 = "000" and instruction_i(20) = '1' then--SYSTEM type ebreak
			current_instruction <= ebreak_instruction;
		elsif	current_type = system_type and funct3 = "001" then--SYSTEM type csrrw
			current_instruction <= csrrw_instruction;
		elsif	current_type = system_type and funct3 = "010" then--SYSTEM type csrrs
			current_instruction <= csrrs_instruction;
		elsif	current_type = system_type and funct3 = "011" then--SYSTEM type csrrc
			current_instruction <= csrrc_instruction;
		elsif	current_type = system_type and funct3 = "101" then--SYSTEM type csrrwi
			current_instruction <= csrrwi_instruction;                                
		elsif	current_type = system_type and funct3 = "110" then--SYSTEM type csrrsi
			current_instruction <= csrrsi_instruction;                                
		elsif	current_type = system_type and funct3 = "111" then--SYSTEM type csrrci
			current_instruction <= csrrci_instruction;
		else
			current_instruction <= problem_instruction;
	    end if;
	end process;
	
	
	process(current_type,current_instruction,alu_comparison_i,instruction_i)
	begin
	--instantiation values
		rs1_instruction_o			<= "00000";
		rs2_instruction_o			<= "00000";
		rd_instruction_o			<= "00000";
		register_wr_en_o   			<= '0';
		alu_a_mux_o		   			<= '0';
		alu_b_mux_o		   			<= '0';
		alu_select_o	   			<= "0000";
		register_c_mux_o   			<= "00";
		data_memory_i_mux_o			<= "00";
		data_memory_wr_en_o			<= '0';
		pc_alu_a_mux_o		   		<= '0';
		pc_alu_b_mux_o		   		<= '0';
		expander_imm_select_o		<= "000";
		expander_load_select_o		<= "000";

		case current_type is -- OPCODE operations
			when r_type => --R Type-----------------------------------------------------------------
				rs1_instruction_o		<= instruction_i(19 downto 15);
				rs2_instruction_o		<= instruction_i(24 downto 20);
				rd_instruction_o		<= instruction_i(11 downto 7);
				register_wr_en_o  		<= '1';
				alu_a_mux_o		  		<= '0';
				alu_b_mux_o		  		<= '0';
				register_c_mux_o  		<= "00";
				data_memory_wr_en_o		<= '0';
				pc_alu_a_mux_o		  	<= '0';
				pc_alu_b_mux_o		  	<= '0';
				
				if 	  current_instruction = add_instruction then
					alu_select_o <= "0000";                      
				elsif current_instruction = sub_instruction then
					alu_select_o <= "0001";                     
				elsif current_instruction = sll_instruction then
					alu_select_o <= "0010" ;       
				elsif current_instruction = slt_instruction then
					alu_select_o <= "0011" ;   					
				elsif current_instruction = sltu_instruction then
					alu_select_o <= "0100";                     
				elsif current_instruction = xor_instruction then
					alu_select_o <= "0101";                     
				elsif current_instruction = srl_instruction then
					alu_select_o <=  "0110";                    
				elsif current_instruction = sra_instruction then
					alu_select_o <= "0111";
				elsif current_instruction = or_instruction then
					alu_select_o <= "1000";
				elsif current_instruction = and_instruction then
					alu_select_o <= "1001";
				else
					alu_select_o <= "1111";
				end if;

			when i_load_type => --I Load Type------------------------------------------------------------
				rs1_instruction_o		<= instruction_i(19 downto 15);
				rd_instruction_o		<= instruction_i(11 downto 7);
				register_wr_en_o   		<= '1';
				alu_a_mux_o		   		<= '0';
				alu_b_mux_o		   		<= '1';
				alu_select_o	   		<= "0000";
				register_c_mux_o   		<= "01";
				data_memory_wr_en_o		<= '0';
				pc_alu_a_mux_o		   	<= '0';
				pc_alu_b_mux_o		   	<= '0';
				expander_imm_select_o	<= "000";
				
				if 	  current_instruction = lb_instruction then
					expander_load_select_o	<= "000";	                     
				elsif current_instruction = lh_instruction then
					expander_load_select_o	<= "001";						
				elsif current_instruction = lw_instruction then
					expander_load_select_o	<= "010";    
				elsif current_instruction = lbu_instruction then
					expander_load_select_o	<= "011";  					
				elsif current_instruction = lhu_instruction then
					expander_load_select_o	<= "100";                     
				else
				
				end if;

			when i_type  => --I Type-----------------------------------------------------------------
				rs1_instruction_o		<= instruction_i(19 downto 15);
				rd_instruction_o		<= instruction_i(11 downto 7);
				register_wr_en_o   		<= '1';
				alu_a_mux_o		   		<= '0';
				alu_b_mux_o		   		<= '1';
				register_c_mux_o   		<= "00";
				data_memory_wr_en_o		<= '0';
				pc_alu_a_mux_o		   	<= '0';
				pc_alu_b_mux_o		   	<= '0';
				expander_imm_select_o	<= "000";
				
				if 	  current_instruction = addi_instruction then
					alu_select_o <= "0000";                      
				elsif current_instruction = slti_instruction then
					alu_select_o <= "0011";                     
				elsif current_instruction = sltiu_instruction then
					alu_select_o <= "0100" ;       
				elsif current_instruction = xori_instruction then
					alu_select_o <= "0101" ;   					
				elsif current_instruction = ori_instruction then
					alu_select_o <= "1000";                     
				elsif current_instruction = andi_instruction then
					alu_select_o <= "1001";                     
				elsif current_instruction = slli_instruction then
					alu_select_o <=  "0010";                    
				elsif current_instruction = srli_instruction then
					alu_select_o <= "0110";
				elsif current_instruction = srai_instruction then
					alu_select_o <= "0111";
				else
					alu_select_o <= "1111";
				end if;
				
				
			when s_type => --S Type-----------------------------------------------------------------
				rs1_instruction_o		<= instruction_i(19 downto 15);
				rs2_instruction_o		<= instruction_i(24 downto 20);
				register_wr_en_o   		<= '0';
				alu_a_mux_o		   		<= '0';
				alu_b_mux_o		   		<= '1';
				alu_select_o	   		<= "0000";
				data_memory_wr_en_o		<= '1';
				pc_alu_a_mux_o		   	<= '0';
				pc_alu_b_mux_o		   	<= '0';
				expander_imm_select_o	<= "010";
				
				if current_instruction = sb_instruction then
					data_memory_i_mux_o	<= "00";
				elsif current_instruction = sh_instruction then
					data_memory_i_mux_o	<= "01";					
				elsif current_instruction = sw_instruction then
					data_memory_i_mux_o	<= "10";
				else	
					data_memory_i_mux_o	<= "00";
				end if;
					
			when b_type => --B Type-----------------------------------------------------------------
				rs1_instruction_o		<= instruction_i(19 downto 15);
				rs2_instruction_o		<= instruction_i(24 downto 20);
				register_wr_en_o   		<= '0';
				alu_a_mux_o		   		<= '0';
				alu_b_mux_o		   		<= '0';
				alu_select_o	   		<= "0001";--subtract
				data_memory_wr_en_o		<= '0';		
				pc_alu_b_mux_o			<= '0';
				expander_imm_select_o	<= "011";
			
				if current_instruction = beq_instruction then
					pc_alu_a_mux_o	<=  alu_comparison_i(2);--if rs1 and rs2 are equals, go to pc + imm
				elsif current_instruction = bne_instruction then
					pc_alu_a_mux_o	<=  not alu_comparison_i(2);--if rs1 and rs2 are not equals, go to pc + imm					
				elsif current_instruction = blt_instruction then
					pc_alu_a_mux_o	<=  alu_comparison_i(1);--if signed(rs1) < signed(rs2) , go to pc + imm
				elsif current_instruction = bge_instruction then
					pc_alu_a_mux_o	<=  not alu_comparison_i(1);--if signed(rs1) >= signed(rs2) , go to pc + imm
				elsif current_instruction = bltu_instruction then
					pc_alu_a_mux_o	<=  alu_comparison_i(0);--if unsigned(rs1) < unsigned(rs2) , go to pc + imm
				elsif current_instruction = bgeu_instruction then	
					pc_alu_a_mux_o	<=  not alu_comparison_i(0);--if unsigned(rs1) >= unsigned(rs2) , go to pc + imm
				else
					pc_alu_a_mux_o	<= '0';
				end if;
				
			when u_type => --U Type-----------------------------------------------------------------
				rd_instruction_o		<= instruction_i(11 downto 7);
				register_wr_en_o		<= '1';
				alu_b_mux_o				<= '1';
				data_memory_wr_en_o		<= '0';
				pc_alu_a_mux_o 			<= '0';
				pc_alu_b_mux_o 			<= '0';
				expander_imm_select_o	<= "001";
				
				if current_instruction = lui_instruction then
					alu_a_mux_o		<= '0';
					register_c_mux_o<= "11";
				elsif current_instruction = auipc_instruction then
					alu_a_mux_o		<= '1';
					register_c_mux_o<= "00";
				else
					alu_a_mux_o		<= '0';
					register_c_mux_o<= "00";
				end if;
				
			when u_jump_type => --U Jump Type------------------------------------------------------------
				rd_instruction_o			<= instruction_i(11 downto 7);
				register_wr_en_o   			<= '1';
				register_c_mux_o   			<= "10";
				data_memory_wr_en_o			<= '0';
				pc_alu_a_mux_o				<= '1';
				pc_alu_b_mux_o				<= '0';
				expander_imm_select_o		<= "100";
				
			when i_jump_type => --I Jump Type------------------------------------------------------------
				rs1_instruction_o		<= instruction_i(19 downto 15);
				rd_instruction_o		<= instruction_i(11 downto 7);
				register_wr_en_o   		<= '1';
				register_c_mux_o   		<= "10";
				data_memory_wr_en_o		<= '0';
				pc_alu_a_mux_o		   	<= '1';
				pc_alu_b_mux_o		   	<= '1';
				expander_imm_select_o	<= "000";

								
			when others =>-------------------------------------------------------------------------
				rs1_instruction_o			<= "00000";
				rs2_instruction_o			<= "00000";
				rd_instruction_o			<= "00000";
				register_wr_en_o   			<= '0';
				alu_a_mux_o		   			<= '0';
				alu_b_mux_o		   			<= '0';
				alu_select_o	   			<= "0000";
				register_c_mux_o   			<= "00";
				data_memory_wr_en_o			<= '0';
				pc_alu_a_mux_o		   		<= '0';
				pc_alu_b_mux_o		   		<= '0';
				expander_imm_select_o		<= "000";
				expander_load_select_o		<= "000";
	    end case;
	end process;
	
	
				
end architecture;