module baudGen(
	input clk,
	input rst,
	input baudEn,
	input [7:0] baudLow,
	input [7:0] baudHigh,
	output reg baudTick
);
	wire [15:0] clkDiv = {baudHigh, baudLow};
	reg [15:0] counter;
	always @(posedge clk or posedge rst) begin
		if(rst) begin
			counter <= 16'b0;
			baudTick <=0;
		end else begin
			if( clkDiv == 0 || !baudEn ) begin
				counter <= 16'b0;
				baudTick <= 0;
			end else begin
				if(counter == clkDiv-1) begin
					baudTick <= 1;
					counter <= 16'b0;
				end else begin
					counter <= counter + 1;
					baudTick <= 0;
				end
			end
		end
	end
endmodule