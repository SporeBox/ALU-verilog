`timescale 1ns/1ps
module subtractor_tb;
    
    reg signed [7:0] a;
    reg signed [7:0] b;
    reg en;

    wire [8:0] o;

    subtractor uut (
        .a(a),
        .b(b),
        .en(en),
        .o(o)
    );

    initial begin
        $dumpfile("subtractor_test.vcd");
        $dumpvars(0, subtractor_tb);

        en = 1;
        $display("Timp | en | a - b | Rezultat | Carry/Borrow (o[8])");
         
	a = 8'd15; b = 8'd5; 
        #10;  
        $display("%4t | %b | %3d - %3d | %3d | %b", $time, en, a, b, $signed(o[7:0]), o[8]);
    
         
        a = 8'd10; b = 8'd20; 
        #10;
        $display("%4t | %b | %3d - %3d | %3d | %b", $time, en, a, b, $signed(o[7:0]), o[8]);
 
         
        a = 8'd100; b = 8'd100; 
        #10;
        $display("%4t | %b | %3d - %3d | %3d | %b", $time, en, a, b, $signed(o[7:0]), o[8]);

         
        en = 0; a = 8'd10; b = 8'd5; 
        #10;
        $display("%4t | %b | %3d + %3d | %3d | %b", $time, en, a, b, $signed(o[7:0]), o[8]);

        $finish;
    end
endmodule
