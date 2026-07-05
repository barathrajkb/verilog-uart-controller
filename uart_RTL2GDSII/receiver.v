module receiver(
	input clk,
	input rst,
	input rxBit,
	input rxEn,
    input [7:0] baudLow,
    input [7:0] baudHigh,
	output reg [7:0] rxData,
	output reg rxBusy,
	output reg rxDone,
    output reg rxError
);
    wire [15:0] clkDiv = {baudHigh, baudLow};
	reg [3:0] bitCount;
    reg [15:0] counter;

    always @(posedge clk or posedge rst) begin
		if(rst) begin
            bitCount <= 4'd0;
            counter <= 16'd0;
            rxBusy <= 0;
            rxDone <= 0;
            rxError <= 0;
            rxData <= 0;
        end else begin
            rxDone <= 0;
            rxError <= 0;
            if(rxEn && !rxBusy && !rxBit) begin
                bitCount <= 4'd0;
                rxBusy <= 1;
                counter <= 0;
            end else if(rxBusy) begin
                if(clkDiv !=0) begin
                    if(bitCount == 4'd0) begin
                        if(counter == clkDiv + (clkDiv>>1) -1) begin
                            rxData[bitCount] <= rxBit;
                            bitCount <= bitCount + 1;
                            counter <= 0;
                        end else begin
                            counter <= counter + 1;
                        end
                    
                    end else if(bitCount <= 4'd7) begin
                        if(counter == clkDiv-1) begin
                            rxData[bitCount] <= rxBit;
                            bitCount <= bitCount + 1;
                            counter <= 0;
                        end else begin
                            counter <= counter + 1;
                        end

                    end else begin
                        if(counter == clkDiv-1) begin
                            if(rxBit) begin
                                bitCount <= 4'd0;
                                rxBusy <= 0;
                                rxDone <= 1;
                            end else begin
                                bitCount <= 4'd0;
                                rxBusy <= 0;
                                rxError <= 1;
                            end
                            counter <= 0;
                        end else begin
                            counter <= counter + 1;
                        end
                    end
                end else begin
                    bitCount <= 4'd0;
                    rxBusy <= 0;
                    rxError <= 1;
                    counter <= 0;
                end
            end
        end
    end
endmodule
