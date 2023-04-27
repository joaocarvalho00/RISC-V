`include "src/defines.v"

module instruction_decode(
    // Inputs
    input wire clk,
    input wire rst,
    input wire [31:0] in_data,

    // Outputs
    output reg [6:0] out_opcode,
    output reg [2:0] out_funct3,
    output reg [6:0] out_funct7,
    output reg [4:0] out_addr1,
    output reg [4:0] out_addr2,
    output reg [4:0] out_addr_dest,
    output reg [31:0] out_imm ,
    output reg alu_sel
    // output variável a dizer que estamos ou não a trabalhar com immediate
);


    // Decode and fetch instruction
    wire [6:0] opcode  = in_data[6:0];
    wire [2:0] funct3  = in_data[14:12];
    wire [6:0] funct7  = in_data[31:25];
    wire [4:0] rd      = in_data[11:7];
    wire [4:0] rs1     = in_data[19:15];
    wire [4:0] rs2     = in_data[24:20];
    wire [31:0] imm_i  = {{20{in_data[31]}}, in_data[31:20]};
    wire [31:0] imm_s  = {{20{in_data[31]}}, in_data[31:25], in_data[11:7]};
    wire [31:0] imm_b  = {{19{in_data[31]}}, in_data[31], in_data[7], in_data[30:25], in_data[11:8], 1'b0};
    wire [31:0] imm_u  = {in_data[31:12], 12'b0};
    wire [31:0] imm_j  = {{11{in_data[31]}}, in_data[31], in_data[19:12], in_data[20], in_data[30:21], 1'b0};
    //

    //
    always @ (posedge clk or posedge rst)
    begin
        if (rst) begin
                out_opcode       <= 7'b0;
                out_addr_dest    <= 5'b0;
                out_imm          <= 32'b0;
                out_funct3       <= 3'b0;
                out_funct7       <= 7'b0;
                out_addr1        <= 5'b0;
                out_addr2        <= 5'b0;
                alu_sel          <= 1'b0;
        end
        alu_sel <= 1'b0;
        case (opcode) 
            `OP_LUI:
            begin
                out_opcode       <= `OP_LUI;
                out_addr_dest    <= rd;
                out_imm          <= imm_u;
                out_funct3       <= 3'b0;
                out_funct7       <= 7'b0;
                out_addr1        <= 5'b0;
                out_addr2        <= 5'b0;
            end
            `OP_AUIPC:
            begin
                out_opcode       <= `OP_AUIPC;
                out_addr_dest    <= rd;
                out_imm          <= imm_u;
                out_funct3       <= 3'b0;
                out_funct7       <= 7'b0;
                out_addr1        <= 5'b0;
                out_addr2        <= 5'b0;
            end
            `OP_JAL:
            begin
                out_opcode       <= `OP_JAL;
                out_addr_dest    <= rd;
                out_imm          <= imm_j;
                out_funct3       <= 3'b0;
                out_funct7       <= 7'b0;
                out_addr1        <= 5'b0;
                out_addr2        <= 5'b0;
            end
            `OP_JALR:
            begin
                out_opcode       <= `OP_JALR;
                out_addr_dest    <= rd; 
                out_imm          <= imm_i;
                out_funct3       <= funct3;
                out_addr1        <= rs1;
                out_funct7       <= 7'b0;
                out_addr2        <= 5'b0;
            end
            `OP_LOAD:
            begin
                out_opcode       <= `OP_LOAD;
                out_addr_dest    <= rd;
                out_imm          <= imm_i;
                out_funct3       <= funct3;
                out_addr1        <= rs1;
                out_funct7       <= 7'b0;
                out_addr2        <= 5'b0;
            end
            `OP_STORE:
            begin
                out_opcode       <= `OP_STORE;
                out_addr1        <= rs1;
                out_addr2        <= rs2;
                out_imm          <= imm_s;
                out_addr_dest    <= 5'b0;
                out_funct3       <= 3'b0;
                out_funct7       <= 7'b0;
            end
            `OP_OP_IMM:
            begin
                out_opcode       <= `OP_OP_IMM;
                out_addr_dest    <= rd;
                out_imm          <= imm_i;
                out_funct3       <= funct3;
                out_addr1        <= rs1;
                out_funct7       <= 7'b0;
                out_addr2        <= 5'b0;
                alu_sel          <= 1'b1; // immediate operations in alu -> alu_sel = 1
            end                
            `OP_OP:
            begin
                out_opcode       <= `OP_OP;
                out_addr_dest    <= rd;
                out_funct3       <= funct3;
                out_funct7       <= funct7;
                out_addr1        <= rs1;
                out_addr2        <= rs2;
                out_imm          <= 32'b0;
                alu_sel          <= 1'b0; // non-immediate operations in alu -> alu_sel = 0
            end            
            `OP_BRANCH:
            begin
                out_opcode       <= `OP_BRANCH;
                out_imm          <= imm_b;
                out_funct3       <= funct3;
                out_addr1        <= rs1;
                out_addr2        <= rs2;
                out_addr_dest    <= 5'b0;
                out_funct7       <= 7'b0;
            end              
            //OP_SYSCALL:
        endcase
    end
endmodule