//
// This module show you how to infer a two-port 1024x32 BRAM in
// your circuit using the standard Verilog code.
//

module bram2p
#(parameter DATA_WIDTH = 32, RAM_SIZE = 1024, ADDR_WIDTH = 32)
 (clk, we, addr, data_i, data_o);    

input  clk, we;
input  [ADDR_WIDTH-1:0] addr;
input  [DATA_WIDTH-1 : 0] data_i;
output [DATA_WIDTH-1 : 0] data_o;
reg    [DATA_WIDTH-1 : 0] data_o;
reg    [DATA_WIDTH-1 : 0] RAM [RAM_SIZE - 1:0];


always@(posedge clk)
begin
  if (we)
    data_o <= data_i;
  else
    data_o <= RAM[addr];
end


// ------------------------------------
// BRAM Port-A write operation
// ------------------------------------
always@(posedge clk)
begin
  if (we)
    RAM[addr] <= data_i;
end

endmodule

