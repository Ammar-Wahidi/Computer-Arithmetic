`timescale 1ns/1ps

module mulradix8_tb;
    reg signed [31:0] Multiplier, Multiplicand;
    reg clk, rst;
    wire flag;
    wire signed [63:0] Partial_product;

    // Instantiate the DUT (Device Under Test)
    mulradix8 uut (
        .Multiplier(Multiplier),
        .Multiplicand(Multiplicand),
        .clk(clk),
        .rst(rst),
        .flag(flag),
        .Partial_product(Partial_product)
    );

    // Clock Generation
    always #5 clk = ~clk; // 10 ns clock period

    initial begin
        $dumpfile("rad8multiplier_csa_tb.vcd");
        $dumpvars(0, mulradix8_tb); // FIXED MODULE NAME

        // Initialize signals
        clk = 0;
        rst = 1;
        Multiplier = 0;
        Multiplicand = 0;
        #10;
        rst =0;
        wait (flag) ;
        $display("Multiplier: %d, Multiplicand: %d, Result: %d", Multiplier, Multiplicand, Partial_product);
        #10;
        rst =1;
        //basic 2 positive numbers
        Multiplier = 5 ;
        Multiplicand = 7;
        #10;
        rst =0;
        wait (flag) ;
        #5;
        $display("Multiplier: %d, Multiplicand: %d, Result: %d", Multiplier, Multiplicand, Partial_product);
        #50;
        rst=1;
        //basic 1 positive number and 1 neqative numbers
        Multiplier = -5 ;
        Multiplicand = 7;
        #10;
        rst =0;
        wait (flag) ;
        #5;
        $display("Multiplier: %d, Multiplicand: %d, Result: %d", Multiplier, Multiplicand, Partial_product);
        #50;
        rst=1;
        //basic 2 neqative numbers
         Multiplier = -5 ;
         Multiplicand = -11;
         #10;
         rst =0;
         wait (flag) ;
         #5;
         $display("Multiplier: %d, Multiplicand: %d, Result: %d", Multiplier, Multiplicand, Partial_product);
         #50;
        rst=1;
        //mul 2 big numbers pos and neq
        Multiplier = 32'h7ff7a099 ;
        Multiplicand = 32'hf0f7a099;
        //2146934937×(−252206951)=−541471914456147087
        //F87C4E29A2FD9B71
        #10;
        rst =0;
        wait (flag) ;
        #5;
        $display("Multiplier: %d, Multiplicand: %d, Result: %d", Multiplier, Multiplicand, Partial_product);
        #50;
        rst =1 ;
        //
         Multiplier = -32'b100 ;
         Multiplicand = 32'd200;
         #10;
         rst =0;
          wait (flag) ;
           #5;
           $display("Multiplier: %d, Multiplicand: %d, Result: %d", Multiplier, Multiplicand, Partial_product);
               #50;
        $finish;
    end
endmodule
