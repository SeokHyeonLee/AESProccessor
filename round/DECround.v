`timescale 1ns / 1ns

module DECround(state,
                key,
                round,
                nextround,
                nextstate,
                nextkey);
    input [127:0] state, key;
    input [3:0] round;
    output [127:0] nextstate, nextkey;
    output [3:0] nextround;

    parameter INIT_ROUND = 4'h1;
    
    wire [127:0] substate, shiftstate, mixstate, addstate;
    wire [127:0] tmp_mixstate;
    
    inv_mixcolumns inv_mix(.data(state), .out(tmp_mixstate));
    assign mixstate = (round == INIT_ROUND) ? state : tmp_mixstate;
    inv_shift inv_sh(.data(mixstate), .out(shiftstate));
    inv_sbox_128bit inv_sb(.data(shiftstate), .out(substate));
    inv_keyschedule keys(.data(key), .round(round), .out(nextkey));
    
    assign nextstate = substate ^ nextkey;
    assign nextround = round+1;
    
endmodule
