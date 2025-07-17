module piso(	
	input        rst, send,
        input [1:0]  parity_type,
	input        stop_bits, 		//low when using 1 stop bit, high when using two stop bits
	input        data_length, 	//low when using 7 data bits, high when using 8.
        input        baud_out,
        input [10:0] frame_out,
	
	output reg    data_out, 		//Serial data_out
	output reg    p_parity_out, 	//parallel odd parity output, low when using the frame parity.
	output reg    tx_active, 		//high when Tx is transmitting, low when idle.
	output reg    tx_done 		//high when transmission is done, low when not.
);

// states
localparam [2:0] idle=3'b000, start_bit=3'b001, data=3'b010, parity=3'b011, stop_bit=3'b100, done=3'b101;

// internal signals decleration
reg [2:0] current_state, next_state;
reg [3:0] current_counter, next_counter;
reg [1:0] current_stop_bit_counter, next_stop_bit_counter;
reg [3:0] current_data_bit_counter, next_data_bit_counter;


// current states logic
always@ (posedge baud_out, negedge rst)
begin
if (!rst)
begin
current_state<= idle;
current_counter<= 0;
current_stop_bit_counter<= 0;
current_data_bit_counter<= 0;
end
else
begin
current_state<= next_state;
current_counter<= next_counter;
current_stop_bit_counter<= next_stop_bit_counter;
current_data_bit_counter<= next_data_bit_counter;
end
end

// next states logic
always@(*)
begin
next_state= current_state;
p_parity_out= 1'b0;
tx_done=1'b0;
case (current_state)
idle: begin
         tx_active= 1'b0;
         data_out= 1'b1;
         if (send)
           begin
              tx_active= 1'b1;
              if (data_length)
                 next_data_bit_counter=4'b1000;
              else
                 next_data_bit_counter=4'b0111;

              if (stop_bits)
                 next_stop_bit_counter=2'b10;
              else
                 next_stop_bit_counter=2'b01;

              next_counter= 4'b0000;
              next_state= start_bit;
           end
      
      end

start_bit:begin
             data_out= frame_out[current_counter];
             next_counter= current_counter+1;
             next_state= data;
          end

data:begin
        data_out= frame_out[current_counter];
        next_counter= current_counter+1;
        next_data_bit_counter= current_data_bit_counter-1;
        if (current_data_bit_counter==4'b0001)
           begin
               if (parity_type==2'b00 || parity_type==2'b11)
                   next_state= stop_bit;
               else
                   next_state= parity;
           end
     end

parity:begin
          data_out= 1'b0;
          p_parity_out= frame_out[current_counter];
          next_state= stop_bit;
       end

stop_bit:begin
            data_out= frame_out[current_counter];
            next_stop_bit_counter= current_stop_bit_counter-1;
            next_counter= current_counter+1;
            if (current_stop_bit_counter== 2'b01)
               next_state= done;
         end

done:begin
        tx_done=1'b1;
        next_state= idle;
     end

default: next_state= idle;
endcase
end

endmodule