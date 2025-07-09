
module fourbitCLA(
input [3:0]p,
input [3:0]g,
input cin,
output gcla , pcla,
output [4:1]c 
);
assign gcla = g[3] | (g[2]&p[3]) | (g[1]&p[2]&p[3] | g[0] & p[1] & p[2] &p[3]) ;
assign pcla = p[0] & p[1] & p[2] &p[3] ;

assign c[1] = g[0] | (cin&p[0]);
assign c[2] = g[1] | (g[0]&p[1]) | (p[1]&p[0]&cin);
assign c[3] = g[2] | (g[1]&p[2]) | (g[0]&p[2]&p[1]) | (p[2]&p[1]&p[0]&cin) ; 
assign c[4] = g[3] | (g[2]&p[3]) | (g[1]&p[3]&p[2]) | (g[0]&p[3]&p[2]&p[1]) | (p[3]&p[2]&p[1]&p[0]&cin) ;
endmodule 