module SUM (
input cin, 
input [15:1]c,
input [15:0] p,
output [15:0] s 
);
assign s[0]= p[0]^cin ;
genvar i;
generate;
    for ( i=1;i<16;i=i+1)
    begin
       assign s[i]=p[i] ^ c[i]; 
    end
endgenerate
endmodule