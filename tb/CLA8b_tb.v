module CLA8b_tb;

reg [7:0] x;
reg [7:0] y;
reg c0;
wire [7:0] z;
wire c8;

CLA8b uut (.x(x), .y(y), .c0(c0), .z(z), .c8(c8));

   integer i;
   integer j;

initial begin
    $dumpfile("cla8b.vcd");
    $dumpvars(0, CLA8b_tb); 
    c0 = 0;

    for(i = 0; i < 256; i=i+1) begin
        for(j = 0; j < 256; j=j+1) begin
            x = i[7:0];
            y = j[7:0];

            #10;

        end
    end
    $finish;
end
endmodule