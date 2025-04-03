`timescale 1ns / 1ps

module Floating_PointAddition_tb(

    );
    reg clk;
    reg rst;
    reg [31:0] a ;
    reg [31:0] b ;
    wire done ;
    wire [31:0] out;
    
    Floating_PointAddition fb(
    .clk(clk),
    .rst(rst),
    .a(a),
    .b(b),
    .done(done),
    .out(out)
    );
    always #5 clk = ~clk;
    
    initial 
    begin
    rst=1;
    #5;
    rst=0;
    clk =0;
    a=32'b01000000101010000000000000000000;
    b=32'b00000000000000000000000000000000;
    wait (done) ;
    $display("a: %b, b: %b, Result: %b   =(a+(+0))", a, b, out);
    
    #6;
    rst =1;
    #6;
    rst=0;
     a=32'b10000000000000000000000000000000;
     b=32'b11000000101010000000000000000000;
     wait (done) ;
     $display("a: %b, b: %b, Result: %b   =((-0)+(b))", a, b, out);
       
     #5;
     rst =1;
     #5;
     rst=0;
     a=32'b01111111011111111111111111111111;
     b=32'b01111111011111111111111111111111;
     wait (done) ;
     $display("a: %b, b: %b, Result: %b   overflow", a, b, out);
          
     #5;
     rst =1;
     #5;
     rst=0;
     a=32'b01000001010000100000000000000000;
     b=32'b11000001010000100000000000000000;
     wait (done) ;
     $display("a: %b, b: %b, Result: %b   a+-a", a, b, out);
          
     #5;
     rst =1;
     #5;
     rst=0;
     a=32'b01000001010000100000000000000000;
     b=32'b01000001111100111000000000000000;
     wait (done) ;
     $display("a: %b, b: %b, Result: %b   a+b, a= 12.125,b=30.4375", a, b, out);
                   
     #5;
     rst =1;
     #5;
     rst=0;
     a=32'b01000001010000100000000000000000;
     b=32'b11000001111100111000000000000000;
     wait (done) ;
     $display("a: %b, b: %b, Result: %b   a+b, a= 12.125,b=-30.4375", a, b, out);
                   
     #5;
     rst =1;
     #5;
     rst=0;
     a=32'b11000001101001100000000000000000;
     b=32'b11000001011101000000000000000000;
     wait (done) ;
     $display("a: %b, b: %b, Result: %b   a+b, a=-20.75,b=-15.25", a, b, out);
     #5;
     rst =1;
     #5;
     rst=0;
     a=32'b01000111010000110111011101000000;
     b=32'b01000111101011111101101110100000;
     wait (done) ;
     $display("a: %b, b: %b, Result: %b   a+b(bignumbers), a=50039.25,b=90039.25", a, b, out);
     #5;
     rst =1;
     #5;
     rst=0;
     a=32'b01001001001111110111110110000110;
     b=32'b11001001100001000101110111000010;
     wait (done) ;
     $display("a: %b, b: %b, Result: %b   a+b(bignumbers&rounding), a=784344.34843,b=-1084344.3", a, b, out);
     #5;
     rst =1;
     #5;
     rst =0;
     a=32'b00111110000000001011011110000000;
     b=32'b10111101100101101010101111011110;
     wait (done) ;  
     $display("a: %b, b: %b, Result: %b   a+b(smallnumbers&rounding), a=0.1257,b=-0.07357", a, b, out);                                                                
                             
     #15;
    $finish;

    end
endmodule
