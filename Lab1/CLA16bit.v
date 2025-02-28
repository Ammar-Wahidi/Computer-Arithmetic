module CLA16bit (
input [15:0] g,
input [15:0] p,
input cin,
output [16:1]c ,
output gcla4 , pcla4 
);
wire gcla0,gcla1,gcla2,gcla3;
wire pcla0,pcla1,pcla2,pcla3;
fourbitCLA CLA0 (
    .p(p[3:0]),
    .g(g[3:0]),
    .cin(cin),
    .gcla(gcla0),
    .pcla(pcla0),
    .c(c[3:1])
);
fourbitCLA CLA1 (
    .p(p[7:4]),
    .g(g[7:4]),
    .cin(c[4]),
    .gcla(gcla1),
    .pcla(pcla1),
    .c(c[7:5])
);
fourbitCLA CLA2 (
    .p(p[11:8]),
    .g(g[11:8]),
    .cin(c[8]),
    .gcla(gcla2),
    .pcla(pcla2),
    .c(c[11:9])
);
fourbitCLA CLA3 (
    .p(p[15:12]),
    .g(g[15:12]),
    .cin(c[12]),
    .gcla(gcla3),
    .pcla(pcla3),
    .c(c[15:13])
);
fourbitCLA CLA4 (
    .p({pcla3,pcla2,pcla1,pcla0}),
    .g({gcla3,gcla2,gcla1,gcla0}),
    .cin(cin),
    .gcla(gcla4),
    .pcla(pcla4),
    .c({c[16],c[12],c[8],c[4]})
);




endmodule