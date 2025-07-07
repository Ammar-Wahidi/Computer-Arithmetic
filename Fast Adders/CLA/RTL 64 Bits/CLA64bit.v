module CLA64bit (
input [63:0] x,y,
input cin,
output [63:0] s ,
output cout ,
output gcla64 , pcla64 
);
wire gcla5,gcla6,gcla7,gcla8;
wire pcla5,pcla6,pcla7,pcla8;
wire c16 , c32,c48 ;

top_CLA top0 (
.x(x[15:0]),
.y(y[15:0]),
.cin(cin),
.s(s[15:0]),
.gcla4(gcla5),
.pcla4(pcla5)
);

top_CLA top1 (
.x(x[31:16]),
.y(y[31:16]),
.cin(c16),
.s(s[31:16]),
.gcla4(gcla6),
.pcla4(pcla6)
);


top_CLA top2 (
.x(x[47:32]),
.y(y[47:32]),
.cin(c32),
.s(s[47:32]),
.gcla4(gcla7),
.pcla4(pcla7)
);

top_CLA top3 (
.x(x[63:48]),
.y(y[63:48]),
.cin(c48),
.s(s[63:48]),
.gcla4(gcla8),
.pcla4(pcla8)
);

fourbitCLA lookhead_carry (
    .p({pcla8,pcla7,pcla6,pcla5}),
    .g({gcla8,gcla7,gcla6,gcla5}),
    .cin(cin),
    .gcla(gcla64),
    .pcla(pcla64),
    .c({cout,c48,c32,c16})
);
endmodule

