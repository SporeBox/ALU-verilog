module CLA8b(input [7:0] x,
            input [7:0] y,
            input c0,
            output [7:0] z,
            output c8);

wire c4;
CLA4b cla0 (.x(x[3:0]), .y(y[3:0]), .c0(c0), .z(z[3:0]), .c4(c4));
CLA4b cla1 (.x(x[7:4]), .y(y[7:4]), .c0(c4), .z(z[7:4]), .c4(c8));

endmodule
