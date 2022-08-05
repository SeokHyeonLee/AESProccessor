`timescale 1ns / 1ns

module sbox_128bit(data,
                   out);
    input [127:0] data;
    output [127:0] out;
    
    genvar i;
    generate
    for (i = 0; i<16; i = i+1) begin : gen_sbox
    sbox_element sbe(.data(data[(127-i*8)-:8]), .out(out[(127-i*8)-:8]));
    end
    endgenerate
endmodule
    
