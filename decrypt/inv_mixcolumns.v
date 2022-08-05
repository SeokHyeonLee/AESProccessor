`timescale 1ns / 1ns

module inv_mixcolumns(data,
                      out);
    input [127:0] data;
    output [127:0] out;
    
    parameter GF2_8 = 8'b0001_1011;
    
    genvar i;
    generate
    for (i = 0; i<4; i = i+1) begin
        assign out[(127-i*32)-:8] = 
        inv_mix_element(data[(127-i*32)-:8],4'd14) ^
        inv_mix_element(data[(119-i*32)-:8],4'd11) ^
        inv_mix_element(data[(111-i*32)-:8],4'd13) ^
        inv_mix_element(data[(103-i*32)-:8],4'd9);
        
        assign out[(119-i*32)-:8] = 
        inv_mix_element(data[(127-i*32)-:8],4'd9) ^
        inv_mix_element(data[(119-i*32)-:8],4'd14) ^
        inv_mix_element(data[(111-i*32)-:8],4'd11) ^
        inv_mix_element(data[(103-i*32)-:8],4'd13);
        
        assign out[(111-i*32)-:8] = 
        inv_mix_element(data[(127-i*32)-:8],4'd13) ^
        inv_mix_element(data[(119-i*32)-:8],4'd9) ^
        inv_mix_element(data[(111-i*32)-:8],4'd14) ^
        inv_mix_element(data[(103-i*32)-:8],4'd11);
        
        assign out[(103-i*32)-:8] = 
        inv_mix_element(data[(127-i*32)-:8],4'd11) ^
        inv_mix_element(data[(119-i*32)-:8],4'd13) ^
        inv_mix_element(data[(111-i*32)-:8],4'd9) ^
        inv_mix_element(data[(103-i*32)-:8],4'd14);
    end
    endgenerate
    
    function [7:0] inv_mix_element(input [7:0] data, input [3:0] critia);
        case (critia)
            4'd14:begin
                inv_mix_element = multiple2(multiple2(multiple2(data) ^ data)^data);
            end
            4'd13: inv_mix_element   = multiple2(multiple2(multiple2(data)^data))^data;
            4'd11: inv_mix_element   = multiple2(multiple2(multiple2(data))^data)^data;
            4'd9: inv_mix_element    = multiple2(multiple2(multiple2(data)))^data;
            default: inv_mix_element = 8'dx;
        endcase
    endfunction
    
    function [7:0] multiple2 (input [7:0] data);
        multiple2 = {data[6:0], 1'b0} ^ ({8{data[7]}} & GF2_8);
    endfunction
    
endmodule
