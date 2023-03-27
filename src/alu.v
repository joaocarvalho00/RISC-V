`include "src/defines.v"

module alu(
    input wire clk,
    input wire rst,
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    input wire [31:0] x,
    input wire [31:0] y, // Immediate is stored in y
    input wire alu_sel,
    output reg [31:0] out
);

always @ (posedge clk or posedge rst)
begin
    if (rst)
        out <= 32'b0;
    else begin
        if (alu_sel) // Operations with immediate, alu_sel = 1
        begin
            case (funct3) // Updated, talvez faltem algumas ops, ver melhor durante os testes
                `FUNCT3_ADDI:
                    out <= x + y;
                `FUNCT3_SLTI:
                    out <= (x < y) ? 32'd1 : 32'd0;
                `FUNCT3_XORI:
                    out <= x ^ y;
                `FUNCT3_ORI:
                    out <= x | y;
                `FUNCT3_ANDI:
                    out <= x & y;
                `FUNCT3_SLLI:
                    out <= x << y;
                `FUNCT3_SLTIU:
                    out <= (x < y) ? 1'b1 : 1'b0;
                `FUNCT3_SRLI_SRAI:
                    case(funct7)
                    begin
                        `FUNCT7_SRLI:
                            out <= x >> y;
                        `FUNCT7_SRAI:
                            out <= x >>> y;
                    end
                default:
                    out <= 32'b0;
            endcase
        end
        else // Operations without immediate, alu_sel = 0
        begin
            case (funct3) // SLL não funciona, faltam ops
                `FUNCT3_ADD_SUB:
                    case(funct7)
                        `FUNCT7_ADD: 
                            out <= x + y;
                        `FUNCT7_SUB:
                            out <= x - y;
                    endcase
                `FUNCT3_SLL: // Não funciona
                    out <= x << y;
                `FUNCT3_SLT:
                    out <= ($signed(x) < $signed(y)) ? 32'd1 : 32'd0;
                `FUNCT3_SLTU:
                    out <= (x < y) ? 1'b1 : 1'b0;
                `FUNCT3_XOR:
                    out <= x ^ y;
                `FUNCT3_OR:
                    out <= x | y;
                `FUNCT3_AND:
                    out <= x & y;
            endcase
        end
    end
end

endmodule