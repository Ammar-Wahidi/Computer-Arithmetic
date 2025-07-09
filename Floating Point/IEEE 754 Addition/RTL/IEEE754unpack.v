module IEEE754unpack(
    input [31:0] x ,
    output sign ,
    output [7:0] Exponent ,
    output [23:0] Fraction_withhidden_1 
);

assign sign = x[31];
assign Exponent = x[30:23];
assign Fraction_withhidden_1 = {1'b1,x[22:0]} ;

endmodule