`timescale 1ns/1ps
 
module subtractor #(
    parameter WIDTH = 8
)(
    input [WIDTH-1:0] a,
    input [7:0] b,          
    input en,
    output [WIDTH:0]   o        
);
    wire [7:0] b_inv;
    
    assign b_inv = b ^ {8{en}}; 

    CLA8b u_add (
        .x(a),
        .y(b_inv),
        .c0(en),             
        .z(o[7:0]),          
        .c8(o[8])  
    );
endmodule
 
