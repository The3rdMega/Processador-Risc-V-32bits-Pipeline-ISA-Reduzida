module Registradores(
input wire  clk, reset, RegWrite,
input wire [4:0] Rs1,Rs2,Rd, disp,
input wire [31:0] Write_Data,

output wire [31:0] read_data1,
output wire [31:0] read_data2, 
output wire [23:0] read_data3
);


	reg [31:0] Registradores [31:0]; // 32 registradores de 32 bits
	
	
	 //parameter SPR = 5'd29;  // Índice para SP (registrador 29)
    //parameter GPR = 5'd28;  // Índice para GP (registrador 28)


initial begin
	
	integer i;
	for (i = 0; i < 32; i = i + 1) 
		begin
			Registradores[i] = 32'h0000_0000;
		end
			Registradores[2] = 32'h1001_03FC;   // Endereço para SP
			Registradores[3] = 32'h1001_0000;    // Endereço para GP 
end




// Reset e Escrita
always @(posedge clk or posedge reset) 
begin
    if(reset) begin
        integer k;
        for(k = 0; k < 32; k = k+1) begin
            Registradores[k] <= 32'h0000_0000;
        end
        Registradores[2] <= 32'h1001_03FC;
        Registradores[3] <= 32'h1001_0000;
    end 
	 else if (RegWrite && (Rd != 5'd00000)) begin		/// (RegWrite && Rd != 5'd0)
        Registradores[Rd] <= Write_Data;
    end
end

always @(*)
begin
	read_data1 <= Registradores[Rs1];
	read_data2 <= Registradores[Rs2];
	read_data3 <= Registradores[disp][23:0];
end

endmodule