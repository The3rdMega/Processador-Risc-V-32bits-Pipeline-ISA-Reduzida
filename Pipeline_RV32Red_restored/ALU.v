`include "params.v"

module ALU (
    input wire [31:0] inputA,  // Primeiro valor (32 bits)
    input wire [31:0] inputB,  // Segundo valor (32 bits)
    input wire [3:0] alu_controle, // Sinal de controle da ALU (4 bits)
    output reg [31:0] resultado, // Resultado da operação (32 bits)
    output reg zero // Indica se o resultado da ALU é zero
);

always @(*) begin
  // O case a seguir determina qual operação será realizada com base no alu_controle
  case (alu_controle)
		ALUADD: resultado <= inputA + inputB;    // Adiciona A e B
		ALUSUB: resultado <= inputA - inputB;   // Subtrai B de A
		ALUAND: resultado <= inputA & inputB;   // Realiza AND entre A e B
		ALUOR: resultado <= inputA | inputB;   // Realiza OR entre A e B
		ALUXOR: resultado <= inputA ^ inputB;   // Realiza XOR entre A e B
		ALUSLT: resultado <= (inputA < inputB) ? (32'h0000_0001) : (32'h0000_0000); // (SLT) Se A for menor que B, o resultado é 1, caso contrário, 0
		default: resultado <= 32'hxxxx_xxxx;  // Caso por padrão: resultado igual a 0
  endcase
  // Define o sinal zero: será 1 se o resultado for 0, caso contrário, 0
  zero <= (inputA == inputB) ? (1'b1) : (1'b0);
  
 end
 endmodule
