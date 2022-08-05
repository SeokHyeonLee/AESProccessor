`timescale 1ns / 1ns

module inv_keyschedule(data,
                       round,
                       out);
    input [127:0] data;
    input [3:0] round;
    
    output [127:0] out;

    wire [31:0] tmp_out;
    
    parameter [0:(10*8)-1] roundconstant = {8'h36, 8'h1b, 8'h80, 8'h40, 8'h20, 8'h10, 8'h08, 8'h04, 8'h02, 8'h01};
    
    sbox_element sbb0(.data(out[23-:8]), .out(tmp_out[31-:8]));
    sbox_element sbb1(.data(out[15-:8]), .out(tmp_out[23-:8]));
    sbox_element sbb2(.data(out[07-:8]), .out(tmp_out[15-:8]));
    sbox_element sbb3(.data(out[31-:8]), .out(tmp_out[07-:8]));
    
    assign out[127-:32] = tmp_out ^ data[127-:32] ^ {roundconstant[(round-1)*8+:8],24'b0};
    assign out[095-:32] = data[127-:32] ^ data[95-:32];
    assign out[063-:32] = data[095-:32] ^ data[63-:32];
    assign out[031-:32] = data[063-:32] ^ data[31:0];
    
endmodule
