module parity(

	input        rst,
        input [1:0]  parity_type,
        input [7:0]  data_in, 
	
        output reg parity_out
);


// parity block
always@(*)
begin
if (!rst)
parity_out= 1'b0;
else begin
case (parity_type)
2'b00:parity_out=1'b0;
2'b01:begin if( ^data_in)
              parity_out=1'b0;
            else
              parity_out=1'b1;
      end
2'b10:begin if( ^data_in)
              parity_out=1'b1;
            else
              parity_out=1'b0;
      end
2'b11:parity_out=1'b0;
endcase
end
end

endmodule