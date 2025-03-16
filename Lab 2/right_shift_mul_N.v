(* DONT_TOUCH = "TRUE" *)
module right_shift_mul_N  #(parameter N = 32) (
input signed [N-1:0] Multiplier , Multiplicand ,
input clk,rst,
output done_flag,
output signed [2*N-1:0] Partial_product
);

reg [$clog2(N):0]counter;

//Registers used, Partial_product_reg is one register for final product and Multiplier 
reg signed [2*N-1:0] Partial_product_reg ;
wire signed [N-1:0] Multiplicand_reg ;

assign Multiplicand_reg= Multiplicand;

reg [N-1:0] sum_out; 
reg cout ;

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        counter<=0;
        Partial_product_reg <= { {N{1'b0}}, Multiplier };

    end
    else 
    begin
        Partial_product_reg <= {sum_out[N-1], sum_out[N-1:0],Partial_product_reg[N-1:1]}; 
        counter <= counter+1;
    end
end

wire enable ;
wire select ;

assign enable = Partial_product_reg[0];
assign select = (counter==N-1)? 1:0;


always @(*)
begin
if (enable)
    begin
        if (select)
        begin
        {cout,sum_out} = ~Multiplicand_reg + 1 + Partial_product_reg[2*N-1:N];
        end
        else begin
        {cout,sum_out} = Multiplicand_reg + Partial_product_reg[2*N-1:N];    
        end
    end
    else begin
        sum_out = Partial_product_reg[2*N-1:N];
    end
end

assign Partial_product = Partial_product_reg;
assign done_flag = (counter==N) ;

endmodule