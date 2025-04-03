module Adder (
input [23:0] a ,
input [23:0] b , 
input cin ,
output[23:0] s ,
output cout 
);

assign {cout,s}= a+b+cin ;

endmodule