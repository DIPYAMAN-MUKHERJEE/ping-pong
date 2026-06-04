`timescale 1ns / 1ps

module vcounter(
    input clk,
    input vcounton,
    output reg [15:0] vcount=0
    );
    
    always @(posedge clk)begin
        if(vcounton)begin
            if(vcount>=524)begin
                vcount<=0;
            end
            else begin
                vcount<=vcount+1;
            end
        end
    end
endmodule
