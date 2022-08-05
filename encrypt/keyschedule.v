`timescale 1ns / 1ns

module keyschedule(data,
                   round,
                   out);
    input [127:0] data;
    input [3:0] round;
    
    output [127:0] out;

    wire [31:0] tmp_out;
    
    parameter [0:(10*8)-1] roundconstant = {8'h01, 8'h02, 8'h04, 8'h08, 8'h10, 8'h20, 8'h40, 8'h80, 8'h1b, 8'h36} ;
    
    sbox_element sbb0(.data(data[23-:8]), .out(tmp_out[31-:8]));
    sbox_element sbb1(.data(data[15-:8]), .out(tmp_out[23-:8]));
    sbox_element sbb2(.data(data[07-:8]), .out(tmp_out[15-:8]));
    sbox_element sbb3(.data(data[31-:8]), .out(tmp_out[07-:8]));
    
    assign out[127-:32] = tmp_out ^ data[127-:32] ^ {roundconstant[(round-1)*8+:8], 8'h00, 8'h00, 8'h00};
    assign out[095-:32] = out[127-:32] ^ data[095-:32];
    assign out[063-:32] = out[095-:32] ^ data[063-:32];
    assign out[031-:32] = out[063-:32] ^ data[031-:32];
    
endmodule
