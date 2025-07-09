`timescale 1ns/1ps

module MULarray_tb;
    reg signed [31:0] Multiplier, Multiplicand;
    wire signed [63:0] Partial_product;

    // Instantiate the DUT (Device Under Test)
    MULarray uut (
        .a(Multiplier),
        .x(Multiplicand),
        .p(Partial_product)
    );

    // Clock Generation
   
    initial begin
        $dumpfile("MULarray_tb.vcd");
        $dumpvars(0, MULarray_tb); // FIXED MODULE NAME

        // Initialize signals
        Multiplier = 0;
        Multiplicand = 0;
        #10;
        $display("Multiplier: %d, Multiplicand: %d, Result: %d", Multiplier, Multiplicand, Partial_product);
        #10;
        Multiplier = 4;
        Multiplicand = 4;
        #10;
        $display("Multiplier: %d, Multiplicand: %d, Result: %d", Multiplier, Multiplicand, Partial_product);
        #10;
        Multiplier = 2;
        Multiplicand = -20;
        #10;
        $display("Multiplier: %d, Multiplicand: %d, Result: %d", Multiplier, Multiplicand, Partial_product);
        #10;
         Multiplier = -3;
         Multiplicand = -30;
         #10;
         $display("Multiplier: %d, Multiplicand: %d, Result: %d", Multiplier, Multiplicand, Partial_product);
         #10;
          Multiplier = 32'hffff8000;
          Multiplicand =32'h7830002;
          #10;
          $display("Multiplier: %d, Multiplicand: %d, Result: %d", Multiplier, Multiplicand, Partial_product);
          #10;
        $finish;
    end
endmodule
