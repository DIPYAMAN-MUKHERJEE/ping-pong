`timescale 1ns / 1ps

module khz10(
    input clk,
    output reg divclk
    );
    integer d=0;
    always @(posedge clk)begin
        if(d==999)begin
            d<=0;
        end else begin
            d<=d+1;
        end
        divclk<=(d>=500);
    end
endmodule
