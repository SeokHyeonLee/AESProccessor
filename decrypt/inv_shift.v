`timescale 1ns / 1ns

module inv_shift(data,
             out);
    
    input [127:0] data;
    output [127:0] out;
    
    
    // 0 row : >>> 0
    assign out[127-:8]      = data[127-:8];
    assign out[(127-32)-:8] = data[(127-32)-:8];
    assign out[(127-64)-:8] = data[(127-64)-:8];
    assign out[(127-96)-:8] = data[(127-96)-:8];
    
    // 1 row : >>> 1
    assign out[(127-8)-:8]   = data[(127-104)-:8];
    assign out[(127-40)-:8]  = data[(127-8)-:8];
    assign out[(127-72)-:8]  = data[(127-40)-:8];
    assign out[(127-104)-:8] = data[(127-72)-:8];
    
    // 2 row : >>> 2
    assign out[(127-16)-:8]  = data[(127-80)-:8];
    assign out[(127-48)-:8]  = data[(127-112)-:8];
    assign out[(127-80)-:8]  = data[(127-16)-:8];
    assign out[(127-112)-:8] = data[(127-48)-:8];
    
    // 3 row : >>> 3
    assign out[(127-24)-:8]  = data[(127-56)-:8];
    assign out[(127-56)-:8]  = data[(127-88)-:8];
    assign out[(127-88)-:8]  = data[(127-120)-:8];
    assign out[(127-120)-:8] = data[(127-24)-:8];
    
    
    
endmodule
