module divider_tb;
  reg         clk;
  reg         reset_n;
  reg         start;
  reg  [7:0]  a, b;
  wire [15:0] o;
  wire        done;
  
  divider uut (
      .clk(clk),
      .reset_n(reset_n),
      .start(start),
      .a(a),
      .b(b),
      .o(o),
      .done(done)
  );
  
  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Helper task for testing division
  task test_div(input [7:0] dividend, input [7:0] divisor);
    begin
      reset_n = 0; start = 0;
      #10; reset_n = 1; #5;
      a = dividend; b = divisor;
      start = 1; #10; start = 0;
      wait(done); #5;
      $display("%d ÷ %d: quotient = %d, remainder = %d", dividend, divisor, o[15:8], o[7:0]);
    end
  endtask
  
  // Testbench stimuli with additional tests
  initial begin
    $dumpfile("divider_tb.vcd");
    $dumpvars(0, divider_tb);
    
    // Test Cases
    test_div(8'd15, 8'd3);     // Expected: 5, remainder 0.
    test_div(8'd100, 8'd9);    // Expected: approx. 11, remainder ~1.
    test_div(8'd0, 8'd1);      // Expected: 0, remainder 0.
    test_div(8'd255, 8'd1);    // Expected: 255, remainder 0.
    test_div(8'd1, 8'd255);    // Expected: 0, remainder 1.
    test_div(8'd128, 8'd2);    // Expected: 64, remainder 0.
    test_div(8'd255, 8'd255);  // Expected: 1, remainder 0.
    test_div(8'd5, 8'd2);      // Expected: 2, remainder 1.
    
    // Additional edge cases...
    test_div(8'd250, 8'd5);    // 250 ÷ 5: Expected: 50, remainder 0.
    test_div(8'd37, 8'd7);     // 37 ÷ 7.
    
    $finish;
  end
endmodule
