module CSA  (
input [34:0] a,b,c,
output [34:0] s,
output [34:0] carry
);

assign s = a^b^c ;
assign carry = {a&b|b&c|a&c,1'b0};


endmodule 