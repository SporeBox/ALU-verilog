module AC(input xi, input yi, input ci,
        output zi, output Gij, output Pii);

assign Gij = xi & yi;
assign Pii = xi | yi;
assign zi = ci ^ (xi ^ yi);

endmodule