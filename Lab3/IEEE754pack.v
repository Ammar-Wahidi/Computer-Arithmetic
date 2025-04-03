module IEEE754pack(
    input sign ,
    input  [7:0] Exponent,
    input [23:0] Fraction_withhidden_1,
    output  [31:0] x 
);

assign x = {sign , Exponent , Fraction_withhidden_1[22:0] };

endmodule