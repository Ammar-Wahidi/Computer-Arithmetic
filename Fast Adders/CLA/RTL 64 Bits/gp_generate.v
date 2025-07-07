module gp_generate (
input [15:0]x,
input [15:0]y,
output [15:0]p,
output [15:0]g
);
genvar i ;
generate;
    
    for (i=0;i<16;i=i+1)
    begin 
       assign  p[i]= x[i]^y[i];
       assign  g[i]= x[i]&y[i];
    end
endgenerate

endmodule 