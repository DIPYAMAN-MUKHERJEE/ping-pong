`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.08.2025 18:19:52
// Design Name: 
// Module Name: clockdivider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module hz10(
    input clk,
    output reg divclk
    );
    integer d=0;
    always @(posedge clk)begin
        if(d==999999)begin
            d<=0;
        end else begin
            d<=d+1;
        end
        divclk<=(d>=500000);
    end
endmodule
