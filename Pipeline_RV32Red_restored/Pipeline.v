`include "params.v"

module Pipeline (
	input logic clockCPU, clockMem,
	input logic reset,
	output logic [31:0] PC,
	output logic [31:0] Instr,
	input  logic [4:0] regin,
	output logic [31:0] regout,
	output logic [3:0] estado
	);
	

	
	initial
		begin
			PC<=32'h0040_0000;
			Instrucao<=32'b0;
			regout<=32'b0;
		end
//******************************************
// Aqui vão os fios/regs do seu processador		

	///PIPELINE
	reg [63:0] IF_ID;	
		//IF_ID[63:32] -> PC
		//IF_ID[31:0] -> Instr[31:0]
	reg [144:0] ID_EX;
		//ID_EX[144:113] -> PC 		//> IF_ID[63:32]
		//ID_EX[112] -> ALUSrc
		//ID_EX[111:110] -> Mem2Reg
		//ID_EX[109] -> RegWrite
		//ID_EX[108] -> MemRead
		//ID_EX[107] -> MemWrite
		//ID_EX[106:105] -> ALUOp
		//ID_EX[104:73] -> Leitura1
		//ID_EX[72:41] -> Leitura2
		//ID_EX[40:9] -> Imediato[31:0],
		//ID_EX[8] -> Instr[30](Funct7_5)
		//ID_EX[7:5] -> Instr[14:12](Funct3)
		//ID_EX[4:0] -> Instr[11:7](Rd)
	reg [105:0] EX_MEM;
		//EX_MEM[105:74] ->PC 				//> ID_EX[144:113]
		//EX_MEM[73:72] -> Mem2Reg		///////
		//EX_MEM[71] -> RegWrite			 ///
		//EX_MEM[70] -> MemRead				 //////> ID_EX[111:107]
		//EX_MEM[69] -> MemWrite		///////
		//EX_MEM[68:37] -> SaidaULA[31:0]
		//EX_MEM[36:5] -> Leitura2									//LAMAR//EX_MEM[36:5] -> B[31:0](entrada da ula B)
		//EX_MEM[4:0] -> Instr[11:7](Rd)	 //////> ID_EX[4:0]
	reg [103:0] MEM_WB;
		//MEM_WB[103:72] -> PC	//> EX_MEM[105:74]
		//MEM_WB[71:70] -> Mem2Reg		////\> EX_MEM[73:71]
		//MEM_WB[69] -> RegWrite	/////
		//MEM_WB[68:37] -> MemData[31:0]
		//MEM_WB[36:5] -> SaidaULA[31:0]
		//MEM_WB[4:0] -> Instr[11:7](Rd)
	
	
	
	
	
	
//*******************
// Instruction Fetch
	
	///PC
	wire [1:0] PCSource;
	
	
	
//*******************
// Instruction Decode
	
	///CONTROLE
	wire ALUSrc;
	wire [1:0] Mem2Reg;
	wire RegWrite;
	wire MemRead;
	wire MemWrite;
	wire [1:0] Branch;
	wire [1:0] ALUOp;
	
	wire BranchValidated;
	
	//BANCO DE REGISTRADORES
	wire [31:0] WriteData;
	
	///GERADOR DE IMEDIATOS
	wire [31:0] Imediato, Instrucao;
	
	
//*******************
// Execution
	
	///ULA
	wire [31:0] SaidaULA, Leitura1, Leitura2,B;
	
	//ULA CONTROLE
	wire [3:0] ALUCONTROL;
	
	
	
	
//*******************
// Memory Stage
	
	///MEMORIA
	wire [31:0] wIouD, MemData;

	
	
	
//******************************************
// Aqui vai o seu código do seu processador


always @(posedge clockCPU  or posedge reset)
	if(reset)
		begin
			PC <= 32'h0040_0000;
			IF_ID <= 64'b0;
			ID_EX <= 145'b0;
			EX_MEM <= 106'b0;
			MEM_WB <= 104'b0;
		end
	else
	begin
		//Atualiza Registradores De Pipeline
		IF_ID <= {PC[31:0],Instrucao[31:0]};
		ID_EX <= {IF_ID[63:32],ALUSrc,Mem2Reg[1:0],RegWrite,MemRead,MemWrite,ALUOp[1:0],Leitura1[31:0],Leitura2[31:0],Imediato[31:0],IF_ID[30],IF_ID[14:12],IF_ID[11:7]};
		EX_MEM <= {ID_EX[144:113],ID_EX[111:107],SaidaULA[31:0],ID_EX[72:41],ID_EX[4:0]};	//ID_EX[72:41] talvez tenha que trocar para B
		MEM_WB <= {EX_MEM[105:74],EX_MEM[73:71],MemData[31:0],EX_MEM[68:37],EX_MEM[4:0]};
		//Atualiza PC
		case(PCSource)
			2'b00: PC <= PC+4;
			2'b01:	PC <= (IF_ID[63:32] + Imediato)&(~1);
			2'b10: PC <= (Leitura1 + Imediato)&(~1); //SE BUGAR, TALVEZ SEJA PORQUE O RESIGTRADOR NÃO ESCREVEU AINDA EM LEITURA1
			default: PC <= PC+4;
		endcase
		
	end
		

		/// Instruction Fetch Components (PC is above)
			//Cuidando da Origem do PC PCSource
			always @(*)
			begin
				if(BranchValidated && (Branch == BCB)) PCSource <= 2'b01;
				else if (Branch == BCJAL) PCSource <= 2'b01;
				else if (Branch == BCJALR) PCSource <= 2'b10;
				else PCSource <= 2'b00;
			end
		
		ramI MemC (.address(PC[11:2]), .clock(clockMem), .data(), .wren(1'b0), .q(Instrucao));
		
		
		/// Instruction Decode Components
		always @(*)
			begin
				if(Leitura1 == Leitura2) BranchValidated <= 1'b1;
				else BranchValidated <= 1'b0;
			end
		
		
		Controle BlocoDeControle(
			.OPcode(IF_ID[6:0]),
			
			.ALUSrc(ALUSrc),
			.Mem2Reg(Mem2Reg),
			.RegWrite(RegWrite),
			.MemRead(MemRead),
			.MemWrite(MemWrite),
			.Branch(Branch),
			.ALUOp(ALUOp)
		);
		
		Registradores BancoDeRegistradores(
			.clk(clockCPU), 
			.reset(reset), 
			.RegWrite(MEM_WB[69]),
			.Rs1(IF_ID[19:15]),
			.Rs2(IF_ID[24:20]),
			.Rd(MEM_WB[4:0]), 
			.disp(regin),
			.Write_Data(WriteData),

			.read_data1(Leitura1),
			.read_data2(Leitura2), 
			.read_data3(regout) //regout
		);
		
		//assign regout = EX_MEM[105:74];
		
		GeradorImediato GeradorDeImediatos(
			.instrucao(IF_ID[31:0]),  // Instrução de 32 bits
			.imediato(Imediato)     // Valor do imediato calculado
		);
		
		
		/// Instruction Decode Components
		//ALUSrc
		always@(*)
		begin
			if(ID_EX[112]) B <= ID_EX[40:9];	//Recebe Imediato
			else B <= ID_EX[72:41];	//Recebe Leitura2
		end
		
		
		
		ALU UnidadeLogicoAritmetica(
			.inputA(ID_EX[104:73]),  // Primeiro valor (32 bits)
			.inputB(B),  // Segundo valor (32 bits)
			.alu_controle(ALUCONTROL), // Sinal de controle da ALU (4 bits)
			.resultado(SaidaULA), // Resultado da operação (32 bits)
			.zero() // Indica se o resultado da ALU é zero
		);
		
		ALUControle ControleDaULA(
			.alu_op(ID_EX[106:105]),        // Sinal de controle ALU op (2 bits)
			.funct3(ID_EX[7:5]),        // Funct3 (3 bits) para especificar o tipo de operação
			.funct7_5(ID_EX[8]),            // Funct7 bit 5 (1 bit) para controle adicional de operações
			.alu_controle(ALUCONTROL)    // Resultado do controle da ALU (4 bits)
		);
		
		
		/// Memory Stage Components
		
		////////////////////////////// AJEITAR ENDEREÇO DESCOBRIR COMO FUNCIONA //////////////////////////////
		ramD MemD (.address(EX_MEM[48:39]), .clock(clockMem), .data(EX_MEM[36:5]), .wren(EX_MEM[69]), .q(MemData));
		//EX_MEM[68:37] -> SaidaULA[31:0]; EX_MEM[48:39] -> SaidaULA[11:2]	-->ANTES ESTAVA PC[11:2] ???
		////////////////////////////// AJEITAR ENDEREÇO DESCOBRIR COMO FUNCIONA //////////////////////////////
		
		
		
		
		/// Write Back Components
		always @(*)
		begin
			case(MEM_WB[71:70])
				REGALU: WriteData <= MEM_WB[36:5];	// tá sempre recebendo daqui por algum motivo
				REGMEM: WriteData <= MEM_WB[68:37];
				RPC: WriteData <= (MEM_WB[103:72]+(32'd4));
			endcase
		
		
		
			//if(MEM_WB[70]) WriteData <= MEM_WB[36:5];
			//else WriteData <= MEM_WB[68:37];
		end
		
		
		
		
assign Instr = Instrucao;
//LAMAR//assign MemWrite = 1'b0;

//*****************************************
	
			
endmodule
