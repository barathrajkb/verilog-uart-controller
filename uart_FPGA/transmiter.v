module transmitter(
    input clk,
    input rst,
    input baudTick,
    input txStart,
    input txEn,
    input [7:0] data,

    output reg txBit  = 1'b1,
    output reg txBusy = 1'b0,
    output reg txDone = 1'b0
);

    reg [9:0] frame    = 10'd0;
    reg [3:0] bitCount = 4'd0;

    always @(posedge clk or posedge rst) begin

        if(rst) begin
            txBit    <= 1'b1;
            txBusy   <= 1'b0;
            txDone   <= 1'b0;
            frame    <= 10'd0;
            bitCount <= 4'd0;
        end
        else begin

            txDone <= 1'b0;

            if(txStart && txEn && !txBusy) begin
                frame    <= {1'b1, data, 1'b0};   // {STOP, DATA[7:0], START}
                bitCount <= 4'd0;
                txBusy   <= 1'b1;
                txBit    <= 1'b1;
            end
            else if(txBusy && baudTick) begin

                if(bitCount == 4'd9) begin
                    txBit    <= frame[0];
                    frame    <= 10'd0;
                    bitCount <= 4'd0;
                    txBusy   <= 1'b0;
                    txDone   <= 1'b1;
                end
                else begin
                    txBit    <= frame[0];
                    frame    <= frame >> 1;
                    bitCount <= bitCount + 1'b1;
                end

            end

        end

    end

endmodule