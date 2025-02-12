`include "params.v"

module ALUControle (
    input wire [1:0] alu_op,        // Sinal de controle ALU op (2 bits)
    input wire [2:0] funct3,        // Funct3 (3 bits) para especificar o tipo de operação
    input wire funct7_5,            // Funct7 bit 5 (1 bit) para controle adicional de operações
    output reg [3:0] alu_controle    // Resultado do controle da ALU (4 bits)
);

always @(*) begin
  case (alu_op)  // Verifica o valor de alu_op para determinar a operação
		2'b00: alu_controle = ALUADD; // Operação de ADD para instruções tipo LW e SW (alvo de 32 bits)
		
		2'b01: alu_controle = ALUSUB; // Operação de SUB para instruções BEQ (subtração para comparação)

		2'b10: begin  // Quando alu_op é 2'b10, temos várias operações dependendo do valor de funct3 e funct7_5
			 case (funct3) // Verifica os 3 bits do campo funct3
				  3'b000: 
						// Função de ADD ou SUB. Funct7_5 define se é ADD ou SUB.
						if (funct7_5) begin // gotta check this one bit to differentiate between addition and subtraction
						alu_controle <= ALUSUB; //SUB
					end
					else begin
						alu_controle <= ALUADD; //ADD
					end 
				  
				  3'b111: alu_controle = ALUAND; // AND
				  3'b110: alu_controle = ALUOR; // OR
				  3'b100: alu_controle = ALUXOR; // XOR
				  3'b010: alu_controle = ALUSLT; // SLT (Set on Less Than)
				  
				  default: alu_controle = 4'bXXXX; // Caso padrão (se não for nenhum dos anteriores)
			 endcase
		end

		default: alu_controle = 4'bXXXX; // Caso padrão para alu_op diferentes de 2'b00, 2'b01 ou 2'b10
  endcase
end
endmodule
