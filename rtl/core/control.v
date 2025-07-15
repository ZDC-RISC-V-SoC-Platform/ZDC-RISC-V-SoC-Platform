/*********************************************************
*              Module Name: control
* 
*   Control unit for a RISC-V core processor with ISA:
*           (ld,sw,add,and,or,sub,beq)
*
* 
*********************************************************/


module control (
    input OpCode,
    output reg Branch,
    output reg MemRead,
    output reg MemtoReg,
    output reg [1:0] ALUOp,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite
);


// concatinate related signal to one bus
reg ControlOutBus;
assign {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = ControlOutBus;

// defining Opcode encodings
localparam R_type = 7'b0110011;
localparam I_type = 7'b0000011;
localparam S_type = 7'b0100011;
localparam SB_type = 7'b1100111;


// logic part
always @(OpCode) begin
    case (OpCode)
        R_type: begin 
            ControlOutBus = 8'b00100010;
        end
        I_type: begin
            ControlOutBus = 8'b11110000;
        end
        S_type: begin
            ControlOutBus = 8'b1x001000;
        end
        SB_type: begin
            ControlOutBus = 8'b0x000101
        end
        default: ControlOutBus = 8'b00000010;
    endcase
end

    
endmodule