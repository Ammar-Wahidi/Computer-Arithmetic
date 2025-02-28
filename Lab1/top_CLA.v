module top_CLA (
input [15:0] x,y,
input cin,
output [15:0] s ,
output cout ,
output gcla4 , pcla4 
);
wire [15:0] p,g;
gp_generate gp_gen (
.x(x[15:0]),
.y(y[15:0]),
.p(p[15:0]),
.g(g[15:0])
);

wire [16:1]c;
CLA16bit CLA16 (
.p(p[15:0]),
.g(g[15:0]),
.cin(cin),
.c(c[16:1]),
.gcla4(gcla4),
.pcla4(pcla4)
);

SUM sum (
.cin(cin),
.c(c[15:1]),
.p(p[15:0]),
.s(s[15:0])
);
assign cout = c[16] ;

endmodule