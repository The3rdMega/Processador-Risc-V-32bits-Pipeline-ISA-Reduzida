`include "params.v"

module GeradorImediato(
    input wire [31:0] instrucao,  // Instrução de 32 bits
    output wire [31:0] imediato     // Valor do imediato calculado
);

always @(*)
begin
	case (instrucao[6:0])
		// tipo I
		OPTIPOR,
		OPLOAD,
		OPJALR,
		OPIMEDIATO: imediato <= {{20{instrucao[31]}}, instrucao[31:20]} ;
		// tipo S
		OPSTORE: imediato <= {{20{instrucao[31]}}, instrucao[31:25], instrucao[11:7]} ;
		// tipo B
		OPBRANCH: imediato <= {{20{instrucao[31]}}, instrucao[7], instrucao[30:25], instrucao[11:8], 1'b0} ;
		// tipo J
		OPJAL: imediato <= {{12{instrucao[31]}}, instrucao[19:12], instrucao[20], instrucao[30:21], 1'b0} ;
		default: imediato <= 32'hxxxx_xxxx;
	endcase
end
endmodule