
module apb_ram_slave (
    input         PCLK,
    input         PRESETn,
    input         PSEL1,
    input         PENABLE,
    input         PWRITE,
    input  [7:0]  PADDR,
    input  [7:0]  PWDATA,
    output [7:0]  PRDATA,
    output        PREADY
);

    
    reg [7:0] memory [255:0];
    reg [7:0] prdata_reg;
    reg       pready_reg;

    assign PRDATA = prdata_reg;
    assign PREADY = pready_reg;

    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            prdata_reg <= 8'd0;
            pready_reg <= 1'b0;
         end   
            else if (PSEL1 && PENABLE) begin
                pready_reg <= 1'b1; 

                if (PWRITE) 
                    memory[PADDR] <= PWDATA;
                      else 
                    prdata_reg <= memory[PADDR];

			end
      	      else 
     	         	begin
            prdata_reg <= 8'd0;
            pready_reg <= 1'b0;
        end 
    	            
end
endmodule
