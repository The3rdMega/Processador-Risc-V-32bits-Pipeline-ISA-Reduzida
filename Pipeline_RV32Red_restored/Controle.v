`include "params.v"

module Controle(
	input [6:0] OPcode,
	
	output reg ALUSrc,
	output reg [1:0] Mem2Reg,
	output reg RegWrite,
	output reg MemRead,
	output reg MemWrite,
	output reg [1:0] Branch,
	output reg [1:0] ALUOp
 );
 
 always @(*) begin
		ALUSrc   <= 1'b0;
      Mem2Reg  <= REGALU;
      RegWrite <= 1'b0;
      MemRead  <= 1'b0;
      MemWrite <= 1'b0;
      Branch   <= BCN;
      ALUOp    <= 2'b11;
 
	case (OPcode)
    OPTIPOR: begin // Tipo R
      ALUSrc   <= 1'b0;
      Mem2Reg  <= REGALU;
      RegWrite <= 1'b1;
      MemRead  <= 1'b0;
      MemWrite <= 1'b0;
      Branch   <= BCN;
      ALUOp    <= 2'b10; //TIPOR
    end
    OPLOAD: begin // lw
      ALUSrc   <= 1'b1;
      Mem2Reg  <= REGMEM;
      RegWrite <= 1'b1;
      MemRead  <= 1'b1;
      MemWrite <= 1'b0;
      Branch   <= BCN;
      ALUOp    <= 2'b00; //ADD
    end
    OPSTORE: begin // sw
      ALUSrc   <= 1'b1;
      Mem2Reg  <= 1'bx; // Não utilizado
      RegWrite <= 1'b0;
      MemRead  <= 1'b0;
      MemWrite <= 1'b1;
      Branch   <= BCN;
      ALUOp    <= 2'b00; //ADD
    end
    OPBRANCH: begin // beq
      ALUSrc   <= 1'b0;
      Mem2Reg  <= 2'bxx; // Não utilizado
      RegWrite <= 1'b0;
      MemRead  <= 1'b0;
      MemWrite <= 1'b0;
      Branch   <= BCB;
      ALUOp    <= 2'bxx;	//Pois ele testa na mão
    end
	 OPIMEDIATO: begin // addi
      ALUSrc   <= 1'b1;
      Mem2Reg  <= REGALU; 
      RegWrite <= 1'b1;
      MemRead  <= 1'b0;
      MemWrite <= 1'b0;
      Branch   <= BCN;
      ALUOp    <= 2'b00; //ADD
    end
	 OPJALR: begin
		ALUSrc <= 1'b1;
		Mem2Reg <= RPC; 
		RegWrite <= 1'b1;
		MemRead  <= 1'b0;
		MemWrite <= 1'b0; 
		Branch <= BCJALR;
		ALUOp <= 2'b00;
		end
	 OPJAL: begin
		ALUSrc <= 1'bx;
		Mem2Reg <= RPC; 
		RegWrite <= 1'b1;
		MemRead  <= 1'b0;
		MemWrite <= 1'b0; 
		Branch <= BCJAL;
		ALUOp <= 2'bxx; 
		end
    default: begin // Caso padrão
      ALUSrc   <= 1'b0;
      Mem2Reg  <= REGALU;
      RegWrite <= 1'b0;
      MemRead  <= 1'b0;
      MemWrite <= 1'b0;
      Branch   <= BCN;
      ALUOp    <= 2'b11;
    end
  endcase
 end
 endmodule