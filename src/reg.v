

module registersFile (
    input clk,
    input rst,
    input [4:0] reg_addr1, reg_addr2, //address of the registers
    input [4:0] writereg_addr, //write register address
    input write_en,
    input [31:0] write_data,
    output reg [31:0] reg_read1, reg_read2 //output from registers
);

reg [31:0] registers [31:0]; //32 registers de 32 bits

integer i;
initial
begin
    for (i=0; i<32; i=i+1) begin
        registers[i] = 0;
    end
end

//READ1
always @(posedge clk or posedge rst) begin

    if(rst) begin
        reg_read1 = 32'b0;
        reg_read2 = 32'b0;
    end
  
    reg_read1 <= registers[reg_addr1]; //Se for immediate só lê um registo rs rt rd
    //$display("reg_read1 do reg.v = %d", reg_read1);

end

//READ2
always @(posedge clk) begin


    reg_read2 <= registers[reg_addr2];
    //$display("reg_read2 reg.v = %d", reg_read2);

end

//WRITE
always @(posedge clk) begin

    if(write_en) begin
        registers[writereg_addr] <= write_data; //Se for immediate pôr o if para nao ler dois registos
    end 

end



    
    
endmodule