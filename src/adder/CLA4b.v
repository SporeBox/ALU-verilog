module CLA4b(input [3:0] x,
            input [3:0] y,
            input c0,
            output [3:0] z,
            output c4);

wire c1, c2, c3;
wire P00, P11, P22, P33;
wire P01, P23, P03;
wire G00, G11, G22, G33;
wire G01, G23, G03;

AC ac0 (.xi(x[0]), .yi(y[0]), .ci(c0), .zi(z[0]), .Gij(G00), .Pii(P00));
AC ac1 (.xi(x[1]), .yi(y[1]), .ci(c1), .zi(z[1]), .Gij(G11), .Pii(P11));
AC ac2 (.xi(x[2]), .yi(y[2]), .ci(c2), .zi(z[2]), .Gij(G22), .Pii(P22));
AC ac3 (.xi(x[3]), .yi(y[3]), .ci(c3), .zi(z[3]), .Gij(G33), .Pii(P33));

BpC bc0 (.Gjk(G11), .Pjk(P11), .Gij(G00), .Pij(P00), .ci(c0), .Gik(G01), .Pik(P01), .cj(c1));
BpC bc1 (.Gjk(G33), .Pjk(P33), .Gij(G22), .Pij(P22), .ci(c2), .Gik(G23), .Pik(P23), .cj(c3));
BpC bc2 (.Gjk(G23), .Pjk(P23), .Gij(G01), .Pij(P01), .ci(c0), .Gik(G03), .Pik(P03), .cj(c2));

assign c4 = G03 | (P03 & c0);

endmodule