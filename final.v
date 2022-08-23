`timescale 1ns / 1ns

`include "round/ENCround.v"
`include "encrypt/sbox.v"
`include "encrypt/sbox_element.v"
`include "encrypt/mixcolumns.v"
`include "encrypt/shift.v"
`include "encrypt/keyschedule.v"

`include "round/DECround.v"
`include "decrypt/inv_sbox.v"
`include "decrypt/inv_sbox_element.v"
`include "decrypt/inv_mixcolumns.v"
`include "decrypt/inv_shift.v"
`include "decrypt/inv_keyschedule.v"

module AESProcessor(DONE,
                    TEXTOUT,
                    CLK,
                    nRST,
                    ENCDEC,
                    START,
                    KEY,
                    TEXTIN);
    output reg DONE;
    output reg [127:0] TEXTOUT;
    
    input CLK, nRST, ENCDEC, START;
    input [127:0] KEY, TEXTIN;
    
    
    
    //ENC ports
    reg ENCPROCESS;
    
    reg [3:0] cur_ENCround;
    wire [3:0] next_ENCround;
    
    reg [127:0] cur_ENCtext, cur_ENCkey;
    wire [127:0] next_ENCtext, next_ENCkey;
    
    //DEC ports
    reg DECPROCESS;
    
    reg [3:0] cur_DECround;
    wire [3:0] next_DECround;
    
    reg [127:0] cur_DECtext, cur_DECkey;
    wire [127:0] next_DECtext, next_DECkey;
    
    //LAST KEY ports
    reg KEYPROCESS;
    
    reg[127:0] tmp_DECtext;
    reg [3:0] tmp_DECround;
    reg [127:0] tmp_DECkey;
    wire [127:0] nexttmp_DECkey;
    
    
    
    always @(posedge CLK or negedge nRST) begin
        if (~nRST) begin
            //ENC 초기화
            ENCPROCESS   <= 1'b0;
            cur_ENCround <= 4'd0;
            cur_ENCtext  <= 128'b0;
            cur_ENCkey   <= 128'b0;
            
            //DEC 초기화
            DECPROCESS   <= 1'b0;
            cur_DECround <= 4'b0;
            cur_DECtext  <= 128'b0;
            cur_DECkey   <= 128'b0;
            
            //KEY 초기화
            KEYPROCESS   <= 1'b0;
            tmp_DECtext  <= 128'b0;
            tmp_DECround <= 4'b0;
            tmp_DECkey   <= 128'b0;
            
            //output 초기화
            DONE    <= 1'b0;
            TEXTOUT <= 128'b0;
        end
        else begin
            DONE <= 1'b0;
            TEXTOUT <= 128'b0;
            if (START && ~ENCDEC) begin
                //암호화 시작
                ENCPROCESS <= 1'b1;
                
                //ROUND 0
                cur_ENCtext  <= TEXTIN ^ KEY;
                cur_ENCkey   <= KEY;
                cur_ENCround <= 4'd1;
            end
            else if (START && ENCDEC) begin
                //복호화 준비 시작
                KEYPROCESS <= 1'b1;
                
                //ROUND 0
                tmp_DECtext  <= TEXTIN;
                tmp_DECround <= 1'b1;
                tmp_DECkey   <= KEY;
            end
            else begin
                if (ENCPROCESS) begin
                    // 암호화 진행
                    if (cur_ENCround > 4'd10) begin
                        // 종료
                        DONE       <= 1'b1;
                        TEXTOUT    <= cur_ENCtext;
                        ENCPROCESS <= 1'b0;
                        cur_ENCround <= 1'b0;
                    end
                    else begin
                        cur_ENCtext  <= next_ENCtext;
                        cur_ENCkey   <= next_ENCkey;
                        cur_ENCround <= next_ENCround;
                    end
                    
                end
                if (DECPROCESS) begin
                    // 복호화 진행
                    if (cur_DECround > 4'd10) begin
                        //종료
                        DONE       <= 1'b1;
                        TEXTOUT    <= cur_DECtext;
                        DECPROCESS <= 1'b0;
                    end
                    else begin
                        cur_DECtext  <= next_DECtext;
                        cur_DECkey   <= next_DECkey;
                        cur_DECround <= next_DECround;
                    end
                end
                if (KEYPROCESS)begin
                    if (tmp_DECround > 4'd10) begin
                        // last key 획득 후
                        KEYPROCESS <= 1'b0;
                        DECPROCESS <= 1'b1;
                        
                        //round 0
                        cur_DECtext  <= tmp_DECtext ^ tmp_DECkey;
                        cur_DECkey   <= tmp_DECkey;
                        cur_DECround <= 4'd1;
                    end
                    else begin
                        tmp_DECkey   <= nexttmp_DECkey;
                        tmp_DECround <= tmp_DECround + 1;
                    end
                end
                if (~ENCPROCESS && ~DECPROCESS && ~KEYPROCESS) begin
                    
                    //시작 x
                    //ENC 초기화
                    ENCPROCESS   <= 1'b0;
                    cur_ENCround <= 4'd0;
                    cur_ENCtext  <= 128'b0;
                    cur_ENCkey   <= 128'b0;
                    
                    //DEC 초기화
                    DECPROCESS   <= 1'b0;
                    cur_DECround <= 4'b0;
                    cur_DECtext  <= 128'b0;
                    cur_DECkey   <= 128'b0;
                    
                    //KEY 초기화
                    KEYPROCESS   <= 1'b0;
                    tmp_DECtext  <= 128'b0;
                    tmp_DECround <= 4'b0;
                    tmp_DECkey   <= 128'b0;
                    
                    //output 초기화
                    DONE    <= 1'b0;
                    TEXTOUT <= 128'b0;
                end
            
            end
        end
        
        
        
    end
    
    ENCround Ernd(.state(cur_ENCtext), .key(cur_ENCkey), .round(cur_ENCround),
    .nextstate(next_ENCtext), .nextkey(next_ENCkey), .nextround(next_ENCround));
    
    keyschedule ksch(.data(tmp_DECkey), .out(nexttmp_DECkey), .round(tmp_DECround));
    
    DECround Drnd(.state(cur_DECtext), .key(cur_DECkey), .round(cur_DECround),
    .nextstate(next_DECtext), .nextkey(next_DECkey), .nextround(next_DECround));
    
endmodule
