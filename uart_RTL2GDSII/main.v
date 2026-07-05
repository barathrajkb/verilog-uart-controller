module main(
	input clk,
	input rst,
	input [1:0] addr,
	input [7:0] data,
	input rxBit,
	input write,
	input read,
	output txBit,
	output [7:0] rData
);

wire [7:0] txData, baudLow, baudHigh, ctrl, rxData;
wire baudTick, txBusy, txStart, rxBusy, rxDone, txDone, rxError;

registers r1(.clk(clk), .rst(rst), .write(write), .read(read), .addr(addr), .data(data), .RX_DATA(rxData), .txDone(txDone),.rxBusy(rxBusy), .rxDone(rxDone), .rxError(rxError), .txBusy(txBusy), .TX_DATA(txData), .DIV_LOW(baudLow), .DIV_HIGH(baudHigh), .CTRL(ctrl), .readData(rData), .txStart(txStart) );

baudGen b1(.clk(clk),.rst(rst),.baudEn(ctrl[0]), .baudLow(baudLow), .baudHigh(baudHigh), .baudTick(baudTick) );

transmitter t1(.clk(clk), .rst(rst), .baudTick(baudTick), .txStart(txStart), .txEn(ctrl[1]), .data(txData), .txBit(txBit), .txBusy(txBusy), .txDone(txDone));

receiver r2(.clk(clk), .rst(rst), .rxBit(rxBit), .rxEn(ctrl[2]), .baudLow(baudLow), .baudHigh(baudHigh), .rxData(rxData), .rxBusy(rxBusy), .rxDone(rxDone), .rxError(rxError) );

endmodule

