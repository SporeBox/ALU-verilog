`timescale 1ns/1ps
module divider (
    input  wire        clk,
    input  wire        reset_n,
    input  wire        start,
    input  wire [7:0]  a,      // dividend
    input  wire [7:0]  b,      // divisor
    output wire [15:0] o,      // { quotient, remainder }
    output wire        done
);

  // Combined register: {R, Q} initialization:
  wire [15:0] reg_data, reg_data_next;
  wire [15:0] init_val;
  assign init_val = {8'd0, a};

  // 4-bit counter for 8 iterations:
  wire [3:0] count, count_next;
  assign count_next = start ? 4'd8 : (count - 4'd1);

  // One iteration: shift combined register left by one.
  wire [15:0] shifted;
  leftshifter #(.WIDTH(16)) shifter (
      .in(reg_data),
      .serial_in(1'b0),
      .out(shifted)
  );
  
  // Extract remainder and quotient parts.
  wire [7:0] R_sh, Q_sh;
  assign R_sh = shifted[15:8];
  assign Q_sh = shifted[7:0];

  // Compute R_sh - b using CLA8b (two's complement subtraction)
  wire        sub_cout;
  wire [7:0]  sub_result;
  CLA8b sub_adder (
      .x(R_sh),
      .y(~b),
      .c0(1'b1),
      .z(sub_result),
      .c8(sub_cout)
  );
  wire [8:0] sub_out = {sub_cout, sub_result};

  // Compute R_sh + b using CLA8b
  wire        add_cout;
  wire [7:0]  add_result;
  CLA8b add_adder (
      .x(R_sh),
      .y(b),
      .c0(1'b0),
      .z(add_result),
      .c8(add_cout)
  );
  wire [8:0] add_out = {add_cout, add_result};

  // Choose the proper result.
  wire [7:0] R_temp;
  assign R_temp = (R_sh[7] == 1'b0) ? sub_out[7:0] : add_out[7:0];

  // Determine quotient bit.
  wire qbit;
  assign qbit = (R_temp[7] == 1'b0) ? 1'b1 : 1'b0;

  // Form new quotient and remainder.
  wire [7:0] Q_new;
  assign Q_new = { Q_sh[7:1], qbit };
  assign reg_data_next = { R_temp, Q_new };
  
  // Final Correction
  wire [7:0] final_R, final_Q;
  assign final_R = reg_data[15:8];
  assign final_Q = reg_data[7:0];
  
  wire        final_cout;
  wire [7:0]  final_result;
  CLA8b final_correction (
      .x(final_R),
      .y(b),
      .c0(1'b0),
      .z(final_result),
      .c8(final_cout)
  );
  wire [8:0] final_corr = {final_cout, final_result};

  wire [7:0] corrected_R;
  assign corrected_R = (final_R[7] == 1'b1) ? final_corr[7:0] : final_R;

  assign o = { final_Q, corrected_R };
  assign done = (count == 4'd0);

  // Registers for combined data and counter.
  dff #(.WIDTH(16)) reg_data_dff (
      .clk(clk),
      .reset_n(reset_n),
      .d(start ? init_val : reg_data_next),
      .q(reg_data)
  );
  dff #(.WIDTH(4)) count_dff (
      .clk(clk),
      .reset_n(reset_n),
      .d(count_next),
      .q(count)
  );  

endmodule

