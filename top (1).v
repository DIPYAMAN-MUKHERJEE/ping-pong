`timescale 1ns / 1ps

module top(
    input clk,
    input reset,
    input rup,
    input rdown,
    input bup,
    input bdown,
    output hsync,
    output vsync,
    output reg [3:0] red,
    output reg [3:0] green,
    output reg [3:0] blue,
    output wire [7:0] seg,
    output wire [3:0] anode,
    output wire [3:0] inactive
    );
    wire divclk;
    assign inactive=4'b1111;
    khz10 khz10(
        .clk(clk),
        .divclk(divclk)
    );
    wire [1:0] refreshcount;
    refreshcounter refreshcountbox(
        .refresh_clk(divclk),
        .refreshcounter(refreshcount)
    );
    anodecontrol anodecontrol(
        .refreshcounter(refreshcount),
        .anode(anode)
    );
    wire [3:0] bcd;
    reg [3:0] rone;
    reg [3:0] rten;
    reg [3:0] bone;
    reg [3:0] bten;
    parameter INFILE  = "./img/kodim01.hex",WIDTH  = 768,   // Image width
         HEIGHT  = 512;   // Image height;
    bcdctrl bcdctrl(
        refreshcount,
        bone,
        bten,
        rone,
        rten,
        bcd
    );
    bcdtocathode bcdcathodeconvert(
        bcd,
        seg
    );
    wire clk1hz;
    wire [15:0]hcount;
    wire [15:0]vcount;
    wire clk25mghz;
    wire vcounteron;
    clockdivider mghz25 (
        clk,
        clk25mghz
    );
    hcounter hcounter(
        clk25mghz,
        hcount,
        vcounteron
    );
    vcounter vcounter(
        clk25mghz,
        vcounteron,
        vcount
    );
    hz10 hz10(
        clk,
        clk1hz
    );
    reg [15:0] h;
    reg [15:0] v;
    reg [15:0] redup;
    reg [15:0] reddown;
    reg[15:0] blueup;
    reg[15:0] bluedown;
    reg hf;
    reg vf;
    initial begin
        h<=0;
        v<=0;
        blueup<=0;
        bluedown<=0;
        redup<=0;
        reddown<=0;
        hf<=0;
        vf<=0;
        rone<=0;
        rten<=0;
        bone<=0;
        bten<=0;
    end

    always @(posedge clk1hz)begin
    if(reset)begin
        blueup<=0;
        bluedown<=0;
        redup<=0;
        reddown<=0;
        hf<=0;
        vf<=0;
        rone<=0;
        rten<=0;
        bone<=0;
        bten<=0;
        h<=315;
        v<=237;
    end else begin
        if(rup)begin
            if(290+redup-reddown<515)begin
                redup<=redup+1;
            end
        end
        else if (rdown)begin
            if(190+redup-reddown>34)begin
                reddown<=reddown+1;
            end    
        end
        
        if(bup)begin
            if(290+blueup-bluedown<515)begin
                blueup<=blueup+1;
            end
        end
        else if (bdown)begin
            if(190+blueup-bluedown>34)begin
                bluedown<=bluedown+1;
            end    
        end
        
        
        if(~hf)begin
            if (h==594&&((v>=156+blueup-bluedown && v<=256+blueup-bluedown)||(v>=145+blueup-bluedown && v<=245+blueup-bluedown))) begin
                hf<=1;
            end
            else if(h==629)begin
                hf<=1;
                h<=315;
                if(rone<9)begin
                    rone<=rone+1;
                end else if(rone>=9)begin
                    rone<=0;
                    rten<=rten+1;
                end
            end else begin
                h<=h+1;
            end
        end
        else begin
            if(h==36&&((v>=156+redup-reddown && v<=256+redup-reddown)||(v>=145+redup-reddown && v<=245+redup-reddown)))begin
                hf<=0;
            end
            else if(h==0)begin
                hf<=0;
                h<=315;
                if(bone<9)begin
                    bone<=bone+1;
                end else if(bone>=9)begin
                    bone<=0;
                    bten<=bten+1;
                end
            end else begin
                h<=h-1;
            end
        end
        
            if(~vf)begin
                if(h==0||h==629)begin
                    v<=237;
                end
                else if(v==474)begin
                    vf<=1;
                end else begin
                    v<=v+1;
                end
                
                
            end
            else begin
                if(h==0||h==629)begin
                    v<=237;
                end
                else if(v==0)begin
                    vf<=0;
                end else begin
                    v<=v-1;
                end
                
            end
        end
    end
    assign hsync=(hcount<96);
    assign vsync=(vcount<2);
    //assign blue=(hcount>143 && hcount<784 && vcount>34 && vcount<515)?4'b0000:4'b0000;
    
    always @ (*)begin
        red=(hcount>158 && hcount<179 && vcount>(190+redup-reddown) 
        && vcount<(290+redup-reddown))?4'b1111:4'b0000;
        blue=(hcount>748 && hcount<769 && vcount>(190+blueup-bluedown) 
        && vcount<(290+blueup-bluedown))?4'b1111:4'b0000;
        green=(hcount>(143+h) && hcount<(154+h) && vcount>34+v && vcount<45+v)?4'b1111:4'b0000;
    end
endmodule
