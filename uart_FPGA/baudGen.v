module baudGen(
    input clk,
    input baudEn,
    input [7:0] baudLow,
    input [7:0] baudHigh,
    output reg baudTick = 0
);

    wire [15:0] clkDiv = {baudHigh, baudLow};

    reg [15:0] counter = 16'd0;

    always @(posedge clk) begin
        if(clkDiv == 0 || !baudEn) begin
            counter <= 16'd0;
            baudTick <= 0;
        end
        else begin
            if(counter == clkDiv - 1) begin
                baudTick <= 1;
                counter <= 16'd0;
            end
            else begin
                counter <= counter + 1;
                baudTick <= 0;
            end
        end
    end

endmodule