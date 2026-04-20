// Testbench pentru SRT Radix-2 Divider
`timescale 1ns/1ps

module SRT_Radix2_tb;
    reg        clk;
    reg        start;
    reg  [7:0] M_in;
    reg  [7:0] Q_in;
    wire [7:0] Q_out;
    wire [7:0] A_out;
    wire       done;

    // Instantiere
    SRT_Radix2 uut (
        .clk(clk),
        .start(start),
        .M_in(M_in),
        .Q_in(Q_in),
        .Q_out(Q_out),
        .A_out(A_out),
        .done(done)
    );

    // Clock: perioada 10ns
    initial clk = 0;
    always #5 clk = ~clk;

    // Task pentru un test individual
    task do_divide;
        input [7:0] dividend;
        input [7:0] divisor;
        begin
            Q_in  = dividend;
            M_in  = divisor;
            start = 1;
            @(posedge clk);
            start = 0;

            // Asteapta done
            wait(done == 1);
            @(posedge clk);

            $display("%0d / %0d = cat:%0d rest:%0d (asteptat cat:%0d rest:%0d)",
                     dividend, divisor,
                     Q_out, A_out,
                     dividend / divisor,
                     dividend % divisor);
        end
    endtask

    initial begin
        $dumpfile("srt_radix2.vcd");
        $dumpvars(0, SRT_Radix2_tb);

        start = 0;
        M_in  = 0;
        Q_in  = 0;
        #20;

        // Teste de baza
        $display("=== Teste SRT Radix-2 ===");
        do_divide(8'd10,  8'd2);   // 10 / 2  = 5 rest 0
        do_divide(8'd15,  8'd4);   // 15 / 4  = 3 rest 3
        do_divide(8'd100, 8'd7);   // 100 / 7 = 14 rest 2
        do_divide(8'd255, 8'd3);   // 255 / 3 = 85 rest 0
        do_divide(8'd7,   8'd2);   // 7 / 2   = 3 rest 1

        $display("=== Done ===");
        $finish;
    end
endmodule
