`timescale 1ns / 1ns

module mixcolumns(data,
                  out);
    input [127:0] data;
    output [127:0] out;
    
    parameter GF2_8 = 8'b0001_1011;

    genvar i;
    generate
    for (i = 127; i>0; i = i-32) begin
        assign out[ i    -:8] = multiple2(data[i-:8]) ^ multiple3(data[(i-8)-:8]) ^           data[(i-16)-:8]  ^           data[(i-24)-:8] ;
        assign out[(i-8) -:8] =           data[i-:8]  ^ multiple2(data[(i-8)-:8]) ^ multiple3(data[(i-16)-:8]) ^           data[(i-24)-:8] ;
        assign out[(i-16)-:8] =           data[i-:8]  ^           data[(i-8)-:8]  ^ multiple2(data[(i-16)-:8]) ^ multiple3(data[(i-24)-:8]);
        assign out[(i-24)-:8] = multiple3(data[i-:8]) ^           data[(i-8)-:8]  ^           data[(i-16)-:8]  ^ multiple2(data[(i-24)-:8]);
    end
    endgenerate
    
    
    function [7:0] multiple2 (input [7:0] data);
        multiple2 = {data[6:0], 1'b0} ^ ({8{data[7]}} & GF2_8);
    endfunction
    
    function [7:0] multiple3 (input [7:0] data);
        multiple3 = multiple2(data) ^ data;
    endfunction
    
endmodule
