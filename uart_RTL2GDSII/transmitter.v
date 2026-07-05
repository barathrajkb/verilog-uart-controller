module transmitter(
	input clk,
	input rst,
	input baudTick,
	input txStart,
	input txEn,
	input [7:0] data,
	output reg txBit,
	output reg txBusy,
	output reg txDone
);
	reg [9:0] frame;
	reg [3:0] bitCount;
	
	always @(posedge clk or posedge rst) begin
		if(rst) begin
			txBit <= 1;
			txDone <= 0;
			txBusy <= 0;
			bitCount <= 0;
			frame <= 0;
		end else begin
			txDone <= 0;
			if(txStart && txEn && !txBusy) begin
				frame <= {1'd1 , data, 1'd0}; // {STOP BIT , 8 DATA BITS, START BIT}
				bitCount <= 0;
				txBusy <= 1;
				txBit <= 1;
			end else if( txBusy && baudTick ) begin
				if (bitCount == 9) begin
					 txBit    <= frame[0];   // transmit stop bit
					 frame    <= 0;
					 bitCount <= 0;
					 txBusy   <= 0;
					 txDone <= 1;
				end
				else begin
					 txBit    <= frame[0];
					 frame    <= frame >> 1;
					 bitCount <= bitCount + 1;
				end
			end
		end
	end

endmodule