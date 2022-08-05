`timescale 1ns / 1ns

module ENCround(state,
                key,
                round,
                nextround,
                nextstate,
                nextkey);
    input [127:0] state, key;
    input [3:0] round;
    output [127:0] nextstate, nextkey;
    output [3:0] nextround;
    
    parameter FINAL_ROUND = 4'ha;
    
    wire [127:0] substate, shiftstate, mixstate, addstate;
    
    sbox_128bit sbox(.data(state), .out(substate));
    shift shifted(.data(substate), .out(shiftstate));
    mixcolumns mix(.data(shiftstate), .out(mixstate));
    keyschedule keys(.data(key), .round(round), .out(nextkey));
    
    assign nextstate = (round == FINAL_ROUND) ? shiftstate ^ nextkey:
                                                  mixstate ^ nextkey;
    assign nextround = round+1;
    
endmodule
