`timescale 1ns / 1ps

module hcounter(
    input clk,
    output reg [15:0] hcount=0,
    output reg vcounteron=0
    );
    
    always @(posedge clk)begin
        if(hcount>=799)begin
            hcount<=0;
            vcounteron<=1;
        end else begin
            hcount<=hcount+1;
            vcounteron<=0;
        end
    end
endmodule
