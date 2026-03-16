module CLA4b_tb;

reg [3:0] x;
reg [3:0] y;
reg c0;

wire [3:0]z;
wire c4;

CLA4b uut (.x(x), .y(y), .c0(c0), .z(z), .c4(c4));

   integer i;
   integer j;

initial begin
    $dumpfile("cla4b.vcd");
    $dumpvars(0, CLA4b_tb); 
    c0 = 0;

    for(i = 0; i < 16; i=i+1) begin
        for(j = 0; j < 16; j=j+1) begin
            x = i[3:0];
            y = j[3:0];

            #10;

        end
    end
    $finish;
end
endmodule