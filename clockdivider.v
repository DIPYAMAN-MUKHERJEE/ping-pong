`timescale 1ns / 1ps

module clockdivider(
    input clk,
    output reg divclk
    );
    integer d=0;
    always @(posedge clk)begin
        if(d==3)begin
            d<=0;
        end else begin
            d<=d+1;
        end
        divclk<=(d>=2);
    end
endmodule
