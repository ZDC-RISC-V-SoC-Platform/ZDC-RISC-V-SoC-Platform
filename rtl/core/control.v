/*********************************************************
*              Module Name: control
* 
*   Control unit for a RISC-V core processor with ISA:
*           (ld, sw, add, and, or, sub, beq)
*
*   Inputs:
*       OpCode[6:0] - 7-bit RISC-V instruction opcode
*
*   Outputs:
*       Branch      - 1: Branch instruction, 0: No branch
*       MemRead     - 1: Read from memory, 0: No memory read
*       MemtoReg    - 1: Write memory data to register, 0: Write ALU result
*       ALUOp[1:0]  - ALU operation control (00: add, 01: sub, 10: R-type)
*       MemWrite    - 1: Write to memory, 0: No memory write
*       ALUSrc      - 1: Use immediate, 0: Use register
*       RegWrite    - 1: Write to register file, 0: No write
*
*   Control Signal Encoding (ControlOutBus):
*   Bit 7: ALUSrc, Bit 6: MemtoReg, Bit 5: RegWrite, Bit 4: MemRead
*   Bit 3: MemWrite, Bit 2: Branch, Bit 1-0: ALUOp[1:0]
*
*********************************************************/


module control (
    input [6:0] OpCode, // change it to be 'instruction' rather than OpCode, then assign to the internal signal OpCode
    output reg Branch,
    output reg MemRead,
    output reg MemtoReg,
    output reg [1:0] ALUOp,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite
);
    // reg[6:0] OpCode ;
    // assign OpCode = instruction[6:0] ; 
    
// concatinate related signal to one bus
reg [7:0] ControlOutBus;
assign {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = ControlOutBus;

// defining Opcode encodings
localparam R_type = 7'b0110011;
localparam I_type = 7'b0000011;
localparam S_type = 7'b0100011;
localparam SB_type = 7'b1100111;


// logic part
always @(*) begin
    case (OpCode)
        R_type: begin 
            ControlOutBus = 8'b00100010;
        end
        I_type: begin
            ControlOutBus = 8'b11110000;
        end
        S_type: begin
            ControlOutBus = 8'b10001000;
        end
        SB_type: begin
            ControlOutBus = 8'b00000101;
        end
        default: ControlOutBus = 8'b00000010;
    endcase
end

    
endmodule
