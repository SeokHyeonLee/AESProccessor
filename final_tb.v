`timescale 1ns / 1ns
`include "final.v"

module Top;
reg CLK, nRST, ENCDEC, START;
wire DONE;
wire[127:0] out;
reg [127:0] text;
    reg [127:0] key;

AESProcessor esp(.DONE(DONE),
                    .TEXTOUT(out),
                    .CLK(CLK),
                    .nRST(nRST),
                    .ENCDEC(ENCDEC),
                    .START(START),
                    .KEY(key),
                    .TEXTIN(text));

    initial begin
        
    CLK = 0;
    nRST = 0;
    ENCDEC = 0;
    START  = 0;
    text = 0;
    key = 0;
    
    

    end
    initial begin
        #20 nRST = ~nRST;
    end
    always #5 CLK = ~CLK;

    initial begin
        //#30 ENCDEC =~ENCDEC;
       // #10 ENCDEC =~ENCDEC;
    end
    initial begin
        #30 START =~START;
        #10 START =~START;
    end

    initial begin
        #50 START =~START;
        #10 START =~START;
    end

    initial begin
        #50 ENCDEC = ~ENCDEC;
        #10 ENCDEC = ~ENCDEC;
    end
    initial begin
        #30 text = 128'h3243f6a8885a308d313198a2e0370734;
        #10 text = 128'd0;
    end
    initial begin
        #50 text = 128'h11223344556677889900112233445566;
        #10 text = 128'd0;
    end

    initial begin
        #30 key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
        #10 key = 128'd0;
    end

    initial begin
        #50 key = 128'h00112233445566778899112233445566;
        #10 key = 128'd0;
    end
    
    initial begin
        $dumpfile("./wave.vcd");
        $dumpvars(0, Top);
    end

    initial #1000 $finish;

endmodule