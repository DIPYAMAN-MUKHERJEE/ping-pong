`timescale 1ns / 1ps



module bcdctrl(
    input [1:0] refreshcounter,
    input [3:0] d1,
    input [3:0] d2,
    input [3:0] d3,
    input [3:0] d4,
    output reg [3:0] bcd
    );
    always @(refreshcounter)begin
        case (refreshcounter)
            2'd0:bcd=d1;
            2'd1:bcd=d2;
            2'd2:bcd=d3;
            2'd3:bcd=d4;
        endcase
    end
endmodule
