module baudgen (
    input clk,        
    input rst,       
    input [1:0] baud_rate, 
    output reg baud_tick  
);

    // information
    // CLK_FREQ = 50MHz.
    // used equation => [ (clock freq)/(req freq * 16) ] - 1.
    
    //hold the counter value
    reg [$clog2(1302)-1:0] current_counter, next_counter;

    
always @(posedge clk, negedge rst)
begin
if (!rst)
current_counter<= 11'd0;
else
current_counter<= next_counter;
end


always @(*)
begin
next_counter= current_counter;
baud_tick= 1'b0;
case (baud_rate)
2'b00:begin
         if (current_counter== 11'd1302)
            begin
               next_counter= 11'd0;
               baud_tick= 1'b1;
            end
         else
            next_counter= current_counter+1 ;
      end

2'b01:begin
         if (current_counter== 11'd651)
            begin
               next_counter= 11'd0;
               baud_tick= 1'b1;
            end
         else
            next_counter= current_counter+1 ;
      end

2'b10:begin
         if (current_counter== 11'd325)
            begin
               next_counter= 11'd0;
               baud_tick= 1'b1;
            end
         else
            next_counter= current_counter+1 ;
      end

2'b11:begin
         if (current_counter== 11'd162)
            begin
               next_counter= 11'd0;
               baud_tick= 1'b1;
            end
         else
            next_counter= current_counter+1 ;
      end
default: next_counter= current_counter;
endcase
end

endmodule