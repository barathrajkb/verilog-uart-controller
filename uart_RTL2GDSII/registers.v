	module registers(
		input clk,
		input rst,
		input write,
		input read,
		input [1:0] addr,
		input [7:0] data,
		input [7:0] RX_DATA,
		input rxBusy,
		input rxDone,
		input txDone,
		input rxError,
		input txBusy,
		output reg [7:0] TX_DATA,
		output reg [7:0] DIV_LOW,
		output reg [7:0] DIV_HIGH,
		output reg [7:0] CTRL,
		output reg [7:0] readData,
		output reg txStart
	);
		// Register Map
		//
		// Address   Write                Read
		// -----------------------------------------
		// 00        TX_DATA              RX_DATA
		// 01        DIV_LOW              DIV_LOW
		// 10        DIV_HIGH             DIV_HIGH
		// 11        CTRL                 STATUS
		//
		// CONTROL REGISTER DEFINITION
		// bit 0 - enable baud bit
		// bit 1 - enable TX bit
		// bit 2 - enable RX bit
		//
		// STATUS REGISTER DEFINITION
		// bit 0 - TX_BUSY
		// bit 1 - TX_DONE
		// bit 2 - RX_BUSY
		// bit 3 - RX_DONE
		// bit 4 - RX_ERROR
		// bit 5 - RX_DATA_READY
		wire [7:0] STS = {2'd0,rxDataReady, rxError, rxDone , rxBusy, txDone,  txBusy};
		reg rxDataReady;
		always @(posedge clk or posedge rst) begin
			if(rst) begin
				TX_DATA <= 8'd0;
				DIV_LOW <= 8'd0;
				DIV_HIGH <= 8'd0;
				CTRL <= 8'd0;
				readData <= 0;
				txStart <= 0;
				rxDataReady <= 0;
			end else begin
				if(rxDone) begin
					rxDataReady <= 1;
				end else if(read && addr == 2'd0) begin
					rxDataReady <= 0;
				end
				txStart <= 0;
				if(write) begin
					case(addr)
						2'd0 : begin
									if(!txBusy) begin
										TX_DATA <= data;
										txStart <= 1;
									end
								 end
						2'd1 : DIV_LOW <= data;
						2'd2 : DIV_HIGH <= data;
						2'd3 : CTRL <= data;
						default : ;
					endcase
				end else if(read) begin
					case(addr)
						2'd0 : readData <= RX_DATA;
						2'd1 : readData <= DIV_LOW;
						2'd2 : readData <= DIV_HIGH;
						2'd3 : readData <= STS;
						default : readData <= 8'd0;
					endcase
				end
			end
		end
	endmodule