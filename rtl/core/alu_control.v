module alu_control (
    input wire [0:1] ALUOp ,
    input wire [31:0] instruction,

    output reg flag_err,
    output reg [3:0] alu_control_lines
) ;

    flag_err = 1'b0 ;

    always @(*) begin 
        
        case(ALUOp)  

            2'b 00 : begin //add
                alu_control_lines = 4'b 0010 ;
            end 

            2'b 01 :  begin //subtract
                alu_control_lines = 4'b 0110 ;

            end 

            2'b 10 : begin // we need to look at the instruction fields 
                if((instruction[30:25] == 6'b000000) && (instruction[14:12] == 3'b000)) begin 
                    alu_control_lines = 4'b0010 ;
                end 
                else if((instruction[30:25] == 6'b000000) && (instruction[14:12] == 3'b110)) begin 
                    alu_control_lines = 4'b0001 ;
                end 
                else if((instruction[30:25] == 6'b000000) && (instruction[14:12] == 3'b111)) begin 
                    alu_control_lines = 4'b0000 ;
                end 
                else if ((instruction[30:25] == 6'b100000) && (instruction[14:12] == 3'b000)) begin
                    alu_control_lines =4'b0110 ;
                end 

                else begin 
                    flag_err = 1'b1 ;
                end  
            end
        endcase

    end 

endmodule
