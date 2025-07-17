module frame(

        input rst,
        input [1:0]  parity_type,
        input [7:0]  data_in, 
	input        stop_bits, 		//low when using 1 stop bit, high when using two stop bits
	input        data_length, 	//low when using 7 data bits, high when using 8.
        input        parity_out,

        output reg [10:0] frame_out
);

// internal signals decleration
wire [2:0] control_signals; // to control the frame
wire parity_control; // high means no parity

// control signals
assign control_signals= {parity_control , data_length , stop_bits};
assign parity_control= (parity_type==2'b00 || parity_type==2'b11);

// frame block
always@(*)
begin
if (!rst)
frame_out= 11'b000_0000_0000;
else begin
case (control_signals) // {parity  , data_length, stop_bits} & frame=> {stop bits ,parit ,data , start}.
3'b100: frame_out= {1'b1 , data_in[6:0] , 1'b0};
3'b101: frame_out= {2'b11 , data_in[6:0] , 1'b0};
3'b110: frame_out= {1'b1 , data_in[7:0] , 1'b0};
3'b000: frame_out= {1'b1 , parity_out , data_in[6:0] , 1'b0};
3'b001: frame_out= {2'b11 , parity_out , data_in[6:0] , 1'b0};
3'b010: frame_out= {1'b1 , parity_out , data_in[7:0] , 1'b0};
endcase
end
end

endmodule