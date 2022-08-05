`timescale 1ns / 1ns

module inv_sbox_128bit(data,
                       out);
    input [127:0] data;
    output [127:0] out;
    
    genvar i;
    generate
    for (i = 0; i<16; i = i+1) begin : gen_sbox
    inv_sbox_element inv_sbe(.data(data[(127-i*8)-:8]), .out(out[(127-i*8)-:8]));
    end
    endgenerate
endmodule
    
