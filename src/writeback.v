`include "src/alu.v"
`include "src/regfile.v"

module writeback(
    input wire clk,
    input wire rst,
    input wire [4:0] rd, // Destination register
    input wire [31:0] alu_result, // Value to write
    input wire regwrite_en,
    output reg [31:0] write_data // Data to write
    
);
    regfile u_regfile_0(
        .reg_addr1(x)
        .reg_addr2(y)
    );

    alu u_alu_0(
        .clk(clk),
        .rst(rst),
        .funct3(3'b000),
        .funct7(7'b0000000),      
        .alu_sel(alu_sel),
        .out(write_data),
        .x(mem_data),
        .y(alu_result),

    );

    always @(posedge clk)
    begin
        if(rst)
        begin
            regwrite_data <= 32'd0;
        end else if (regwrite_en)
        begin
            regwrite_data <= value;

        end

    end

