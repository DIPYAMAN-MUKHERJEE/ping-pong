`timescale 1ns / 1ps



module refreshcounter(
    input refresh_clk,
    output reg [1:0] refreshcounter=0
    );
    always @(posedge refresh_clk)begin
        refreshcounter<=refreshcounter+1;
    end
    
endmodule
