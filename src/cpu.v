`include "src/defines.v"
`include "src/instruction_decode.v"
`include "src/regfile.v"

module cpu(
    input wire clk,
    input wire rst
);
    /*
        Controls the whole flow of data.
            1. Reads instruction from memory and decodes
            2. Generates control signals for the operations
            3. Execute operations
            4. Write values in memory if needed.
            5. Update program counter (PC)
    */
    reg [31:0] mem [0:31]; // Instruction memory
    initial $readmemh("test_mem.txt", mem);

    reg [31:0] instruction;

    // Decoding variables
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [4:0] addr1;
    wire [4:0] addr2;
    wire [4:0] addr_dest;
    wire [31:0] imm;
    wire alu_sel;

    instruction_decode u_instruction_decode_0(
                    .clk(clk),
                    .rst(rst),
                    .in_data(instruction),

                    .out_opcode(opcode),
                    .out_funct3(funct3),
                    .out_funct7(funct7),
                    .out_addr1(addr1),
                    .out_addr2(addr2),
                    .out_addr_dest(addr_dest),
                    .out_imm(imm),
                    .alu_sel(alu_sel)
                    );
    



    // Write to reg
    reg write_en;
    reg [31:0] write_data_reg;
    reg [4:0] addr_dest_reg;

    // Read from regs
    reg [31:0] read1_from_reg;
    reg [31:0] read2_from_reg;
    reg [4:0] addr1_reg;
    reg [4:0] addr2_reg;

    regfile u_regfile_0(
        .clk(clk),
        .rst(rst),
        .reg_addr1(addr1_reg),
        .reg_addr2(addr2_reg),
        .writereg_addr(addr_dest_reg),
        .write_en(write_en),
        .write_data(write_data_reg),
        .reg_read1(read1_from_reg),
        .reg_read2(read2_from_reg)
    );



    reg [4:0] pc; // Program counter 
    always @ (posedge clk or posedge rst)
    begin
        if(rst) 
        begin
            pc              <= 5'b0;
            instruction     <= 32'b0;
            write_en        <= 1'b0;
            write_data_reg  <= 32'b0;
        end
        else begin
            // Instruction fetch
            instruction <= mem[pc];
            write_en    <= 1'b0;
            // Execute instruction
            case (opcode)
                `OP_LUI:
                begin
                    write_en       <= 1'b1;
                    write_data_reg <= imm;
                    addr_dest_reg  <= addr_dest;
                end
                `OP_AUIPC:
                begin
                    write_en       <= 1'b1;
                    write_data_reg <= imm + pc;
                    addr_dest_reg  <= addr_dest;
                end
                //`OP_JAL:
                /*`OP_JALR:
                `OP_LOAD: // Não testei, não vai funcionar
                begin
                    addr1_reg      <= addr1;
                    read1_from_reg <= read1_from_reg;
                    write_en       <= 1'b1;
                    write_data_reg <= imm;
                    addr_dest_reg  <= addr_dest;        
                end
                `OP_STORE:
                `OP_OP:
                `OP_OP_IMM:
                `OP_BRANCH:*/
            endcase
            pc          <= pc + 1;
        end
    end

    
endmodule
