(* DONT_TOUCH = "TRUE" *)
module MULarray (
input signed [31:0] a , x , 
output signed  [63:0] p 
);

assign p[0]=a[0]&x[0] ;
genvar i ;
genvar j ;

wire [30:0] sout ; //  N=1
wire [30:0] cout ; //  N-1

//First Stage 
generate 
        for (j=0;j<31;j=j+1)
        begin
            if (j!=30)
            begin
            Fulladder fa (
                .x(x[0]&a[j+1]),
                .y(x[1]&a[j]),
                .cin(1'b0),
                .s(sout[j]),
                .cout(cout[j])
            );
            end
            else
            begin
            Fulladder fa30 (
                .x(~(x[0]&a[31])),
                .y(x[1]&a[30]),
                .cin(0),
                .s(sout[30] ),
                .cout(cout[30])
            );
        end
        end

endgenerate
assign p[1]=sout[0];

//wire [31:0] my_array [31:0];  // 32 rows, each containing 32 bits
wire soutt [29:0] [30:0] ;  
wire  coutt [29:0] [30:0] ;  

//stage 2 to stage 31
generate
for(i=2;i<32;i=i+1)
begin
    for(j=0;j<31;j=j+1)
    begin
         if (i!=2 && j!=30 && i!=31)
            begin
            Fulladder faa (
                .x(coutt[i-3][j]),
                .y(soutt[i-3][j+1]),
                .cin(x[i]&a[j]),
                .s(soutt[i-2][j]),
                .cout(coutt[i-2][j])
            );
            end
            else if (i==2 && j!=30 && i!=31)
            begin
            Fulladder fa0 (
                .x(sout[j+1]),
                .y(cout[j]),
                .cin(x[2]&a[j]),
                .s(soutt[i-2][j]),
                .cout(coutt[i-2][j])
            );
        end
        else if (i==2 && j==30 && i!=31)
            begin
            Fulladder faa30 (
                .x(cout[30]),
                .y(~(x[1]&a[31])),
                .cin(x[2]&a[30]),
                .s(soutt[0][30] ),
                .cout(coutt[0][30])
            );
        end
        else if (i!=2 && j==30 && i!=31)
        begin
            Fulladder faa (
                .x(coutt[i-3][30]),
                .y(~(x[i-1]&a[31])),
                .cin(x[i]&a[30]),
                .s(soutt[i-2][j]),
                .cout(coutt[i-2][j])
            );
        end
        else if( i==31 && j!=30)
        begin
            Fulladder faa (
                .x(coutt[i-3][j]),
                .y(soutt[i-3][j+1]),
                .cin(~(x[31]&a[j])),
                .s(soutt[i-2][j]),
                .cout(coutt[i-2][j])
            );
        end
        else if (i==31 && j==30)
        begin
            Fulladder faa (
                .x(coutt[i-3][30]),
                .y(~(x[i-1]&a[31])),
                .cin(~(x[i]&a[30])),
                .s(soutt[i-2][j]),
                .cout(coutt[i-2][j])
            );
        end
    end
end
endgenerate

generate
for (i=2;i<32;i=i+1)
begin
    assign p[i]=soutt[i-2][0];
end
endgenerate

//last stage
wire  ca [30:0] ;
Fulladder fa00 (
                .x(coutt[29][0]),
                .y(soutt[29][1]),
                .cin(1'b1),
                .s(p[32]),
                .cout(ca[0])
            );

generate 
        for (j=1;j<30;j=j+1)
        begin
           
            Fulladder fa0 (
                .x(coutt[29][j]), 
                .y(soutt[29][j+1]), 
                .cin(ca[j-1]), 
                .s(p[32+j]), 
                .cout(ca[j]) 
            );
            
        end
endgenerate

wire cha;
Fulladder falast (
                .x(coutt[29][30]),
                .y(a[31]&x[31]),
                .cin(ca[29]),
                .s(p[62]),
                .cout(cha)
            );


Halfadder ha (
                .x(1'b1),
                .y(cha),
                .s(p[63])
            );


endmodule