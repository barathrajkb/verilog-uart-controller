module main_echo(
    input clk,
    input button,
    input rxBit,
    output txBit
);

    //--------------------------------------------------
    // Debounced Reset
    //--------------------------------------------------

    wire rst;

    debounce db1(
        .clk(clk),
        .button(button),
        .pulse(rst)
    );

    //--------------------------------------------------
    // UART Configuration
    //--------------------------------------------------

    localparam [7:0] BAUD_LOW  = 8'd234;
    localparam [7:0] BAUD_HIGH = 8'd0;

    wire baudTick;

    wire [7:0] rxData;
    reg  [7:0] txData;

    wire rxBusy;
    wire rxDone;
    wire rxError;

    wire txBusy;
    wire txDone;

    reg txStart;

    //--------------------------------------------------
    // Baud Generator
    //--------------------------------------------------

    baudGen b1(
        .clk(clk),
        .rst(rst),
        .baudEn(1'b1),
        .baudLow(BAUD_LOW),
        .baudHigh(BAUD_HIGH),
        .baudTick(baudTick)
    );

    //--------------------------------------------------
    // UART Receiver
    //--------------------------------------------------

    receiver r1(
        .clk(clk),
        .rst(rst),
        .rxBit(rxBit),
        .rxEn(1'b1),
        .baudLow(BAUD_LOW),
        .baudHigh(BAUD_HIGH),
        .rxData(rxData),
        .rxBusy(rxBusy),
        .rxDone(rxDone),
        .rxError(rxError)
    );

    //--------------------------------------------------
    // UART Transmitter
    //--------------------------------------------------

    transmitter t1(
        .clk(clk),
        .rst(rst),
        .baudTick(baudTick),
        .txStart(txStart),
        .txEn(1'b1),
        .data(txData),
        .txBit(txBit),
        .txBusy(txBusy),
        .txDone(txDone)
    );

    //--------------------------------------------------
    // Echo Controller
    //--------------------------------------------------

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            txData  <= 8'd0;
            txStart <= 1'b0;
        end
        else begin
            txStart <= 1'b0;

            if(rxDone && !txBusy) begin
                txData  <= rxData;
                txStart <= 1'b1;
            end
        end
    end

endmodule