(* DONT_TOUCH = "TRUE" *)
module Floating_PointAddition(
    input clk,
    input rst,
    input [31:0] a ,
    input [31:0] b ,
    output reg done,
    output [31:0] out 
    
//  output reg state ;
);

wire        a_sign ;
wire [7:0]  a_Exponent;
wire [23:0] a_fraction;
wire        b_sign;
wire [7:0]  b_Exponent;
wire [23:0] b_fraction;

reg        a_sign_reg ;
reg [7:0]  a_Exponent_reg;
reg [23:0] a_fraction_reg;
reg        b_sign_reg;
reg [7:0]  b_Exponent_reg;
reg [23:0] b_fraction_reg;

reg [3:0] state;

wire [7:0]  e_ab ;
reg  [7:0]  Exponent ;
reg         sign_reg;
wire [23:0] addfrac ;
wire        carryfrac;
reg [23:0]  outaddfrac_reg;
wire        cin;
wire        signlogic;
reg         carryfrac_reg;
wire        G ;
wire        R ;
wire        S ;
wire [20:0] mantissa ;
wire        round_up ;

initial 
begin
    state = 0 ;
    done =0;
    sign_reg=0;
    Exponent=0;
    outaddfrac_reg=0;
    carryfrac_reg=0;

end

IEEE754unpack unpacka (
.x(a),
.sign(a_sign),
.Exponent(a_Exponent),
.Fraction_withhidden_1(a_fraction)
);
IEEE754unpack unpackb (
.x(b),
.sign(b_sign),
.Exponent(b_Exponent),
.Fraction_withhidden_1(b_fraction)
);

assign e_ab = (a_Exponent>b_Exponent) ? a_Exponent - b_Exponent : b_Exponent - a_Exponent ;
assign cin = a_sign ^ b_sign ;
assign signlogic = (a[30:0]>b[30:0]) ? 1:0;
assign G = outaddfrac_reg[2];
assign R = outaddfrac_reg[1];
assign S = outaddfrac_reg[0];
assign mantissa = outaddfrac_reg[23:3]; 
assign round_up = (G & (R | S)) | (G & R & ~S & mantissa[0]);

Adder add_sub (
.a(a_fraction_reg),
.b(b_fraction_reg),
.cin(cin),
.s(addfrac),
.cout(carryfrac)
);

//States 
always @(posedge clk or posedge rst)
begin
if (rst==1)
    begin
    state = 0 ;
    done =0;
    sign_reg=0;
    Exponent=0;
    outaddfrac_reg=0;
    carryfrac_reg=0;
    end
else
begin
case (state)
0:
//spcial cases and starting
begin
if (b[30:0]==0 )
begin
    sign_reg <= a_sign;
    Exponent <= a_Exponent;
    outaddfrac_reg<=a_fraction;
    state <=8;
end
else
if (a[30:0]==0 )
begin
    sign_reg <= b_sign;
    Exponent <= b_Exponent;
    outaddfrac_reg<=b_fraction;
    state <=8;
end
else
if (b[30:0]==a[30:0] && a_sign != b_sign)
begin
    sign_reg <= 0;
    Exponent <= 0;
    outaddfrac_reg<=0;
    state <=8;
end
else
begin
    a_sign_reg <= a_sign;
    a_Exponent_reg<=a_Exponent;
    a_fraction_reg<=a_fraction;
    b_sign_reg<=b_sign;
    b_Exponent_reg<=b_Exponent;
    b_fraction_reg<=b_fraction;
    state <=1;
end
end
1:
//Compare the exponents then shifting
begin
if (a_Exponent>b_Exponent) 
begin
    b_fraction_reg <= b_fraction_reg >> e_ab;
    Exponent<=a_Exponent;
    state <=2;
end
else if (a_Exponent<b_Exponent)
begin
    a_fraction_reg <= a_fraction_reg >> e_ab;
    Exponent<=b_Exponent;
    state <=2;
end
else
begin
    Exponent<=b_Exponent;
    state <=2;
end
end
2:
//add or sub
begin
if (cin)
begin
    if (a_sign_reg)
    begin
        sign_reg<= signlogic  ;
        a_fraction_reg<=~a_fraction_reg;
        state <= 3;
    end
    else
    begin
        sign_reg<= !signlogic  ;
        b_fraction_reg<=~b_fraction_reg;
        state <=3;
    end
end 
else 
begin
    sign_reg<= a_sign_reg;
    state <=3;
end
end
3: 
begin
    outaddfrac_reg<=addfrac;
    carryfrac_reg<=carryfrac;
    state <=4;
end
//Normlize the sum and shifting 
4:
begin
if (!cin)
begin
    if (carryfrac_reg && outaddfrac_reg[23] != 1 )
    begin
        Exponent<= Exponent+1;
        outaddfrac_reg<=addfrac>>1;
        state <=6;
        carryfrac_reg<=0;
    end
    else if(outaddfrac_reg[23] != 1)
    begin
        state <= 5 ;
    end
    else
    begin
        outaddfrac_reg<=addfrac;
        state <=6;
    end
end
else
begin
if (!carryfrac_reg)
begin
    outaddfrac_reg = ~outaddfrac_reg +1;
    state <= 4;
    carryfrac_reg<=1;
end
else if (outaddfrac_reg[23]!=1)
begin
    state <= 5;
end
else
begin
    state <=6;
end
end
end
//Noemalizing and addition for subtarction 
5:
begin
    outaddfrac_reg<= outaddfrac_reg<< 1 ;
    Exponent<= Exponent-1;
    state <= 4;
end
//overflow or underflow ?
6:
begin
    if (Exponent == 255 || Exponent ==0 )
    begin
        state<= 8  ;
    end
    else 
    begin
        state <=7;
    end
end
//Rounding 
7:
begin

    if (round_up) begin
        if (mantissa == 21'h1FFFFF) begin  
            Exponent <= Exponent + 1;       
            outaddfrac_reg <= {21'h100000, 3'b0};  
        end
        else begin
            outaddfrac_reg <= {mantissa + 1, 3'b0};  
        end
    end
    else begin
        outaddfrac_reg <= {mantissa, 3'b0};  
    end
    state <= 8;
end
8:
begin
    state<= 9  ;
    done <= 1  ;
end 
9:
begin
    state<= 0;
    done<=0;
end
endcase 
end
end

IEEE754pack pack (
.x(out),
.sign(sign_reg),
.Exponent(Exponent),
.Fraction_withhidden_1(outaddfrac_reg)
);

endmodule 