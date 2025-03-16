(* DONT_TOUCH = "TRUE" *)
module mulradix8 (
input signed [31:0] Multiplier , Multiplicand ,
input clk,rst,
output flag,
output signed  [63:0] Partial_product 
);
reg [3:0] counter ;
reg signed [32:0] Multiplier_reg ;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        Multiplier_reg <= {Multiplier,1'b0};
    end else if (counter < 11) begin
        Multiplier_reg <= {{3{Multiplier_reg[32]}}, Multiplier_reg[32:3]};
    end
    
end


reg signed [34:0] a, a2, a3, a4, neqa, neqa2, neqa3, neqa4;
always @(*) begin
    a = {{3{Multiplicand[31]}}, Multiplicand}; 
    a2 = a << 1;
    a3 = a2 + a;
    a4 = a << 2;
    neqa = ~a + 1;
    neqa2 = ~a2 + 1;
    neqa3 = ~a3 + 1;
    neqa4 = ~a4 + 1;
end

reg signed [34:0] muxresult ;
always @(*)
begin
    case (Multiplier_reg[3:0])
    4'b0000: muxresult = 0;
    4'b0001: muxresult = a;
    4'b0010: muxresult = a;
    4'b0011: muxresult = a2;
    4'b0100: muxresult = a2;
    4'b0101: muxresult = a3;
    4'b0110: muxresult = a3;
    4'b0111: muxresult = a4;
    4'b1000: muxresult = neqa4;
    4'b1001: muxresult = neqa3;
    4'b1010: muxresult = neqa3;
    4'b1011: muxresult = neqa2;
    4'b1100: muxresult = neqa2;
    4'b1101: muxresult = neqa;
    4'b1110: muxresult = neqa;
    4'b1111: muxresult = 0;
    endcase

end

wire [34:0] sum_out;
wire [34:0] carry_out;
reg signed [34:0] sum_out_reg;
reg signed [34:0] carry_out_reg;
CSA  csa (
.a(muxresult),
.b(sum_out_reg),
.c(carry_out_reg),
.s(sum_out),
.carry(carry_out)
) ;

always @(posedge clk or posedge rst)
begin
    if (rst)
        counter <= 0;
    else if (counter < 11)  
        counter <= counter + 1;
        
end

wire [2:0] sumadd;
wire [2:0] sumcarry;
wire cout ;
reg cout_reg;
wire [2:0]sum ;

assign sumadd = sum_out[2:0];
assign sumcarry = carry_out[2:0];
assign {cout,sum} = sumadd + sumcarry + cout_reg ;

always@(posedge clk or posedge rst) begin
    if(rst)
      cout_reg <=0;
    else
      cout_reg <= cout;
end 

always @(posedge clk or posedge rst)
begin
if(rst)
begin
sum_out_reg <=0;
carry_out_reg<=0;
//counter<=0;
end
else if (counter<11)
begin
sum_out_reg <= {{3{sum_out[34]}},sum_out[34:3]};
carry_out_reg<={{3{carry_out[34]}},carry_out[34:3]};
//counter<=counter+1;
end
end

reg [32:0] Partial_product_lowhalf_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        Partial_product_lowhalf_reg <= 0;
    end else begin
        case (counter)
            0:  Partial_product_lowhalf_reg[2:0]   <= sum;
            1:  Partial_product_lowhalf_reg[5:3]   <= sum;
            2:  Partial_product_lowhalf_reg[8:6]   <= sum;
            3:  Partial_product_lowhalf_reg[11:9]  <= sum;
            4:  Partial_product_lowhalf_reg[14:12] <= sum;
            5:  Partial_product_lowhalf_reg[17:15] <= sum;
            6:  Partial_product_lowhalf_reg[20:18] <= sum;
            7:  Partial_product_lowhalf_reg[23:21] <= sum;
            8:  Partial_product_lowhalf_reg[26:24] <= sum;
            9:  Partial_product_lowhalf_reg[29:27] <= sum;
            10: Partial_product_lowhalf_reg[32:30] <= sum;
            default: Partial_product_lowhalf_reg <= Partial_product_lowhalf_reg ; 
        endcase
    end
    
end



wire [35:0] cpa ;
wire [35:0] cpa_out ;

assign cpa = sum_out_reg + carry_out_reg +cout_reg ;
assign cpa_out = cpa[30:0];

assign flag =(counter == 11) ;
assign Partial_product = (flag) ? {cpa_out, Partial_product_lowhalf_reg} : 64'd0;


endmodule