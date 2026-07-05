`timescale 1ns/1ps

module main_tb();

    reg clk, rst, write, read;
    reg [1:0] addr;
    reg [7:0] data;

    wire txBit;
    wire [7:0] rData;

    // DUT
    main m1(
        .clk(clk),
        .rst(rst),
        .addr(addr),
        .data(data),
        .rxBit(txBit),      // Internal loopback
        .write(write),
        .read(read),
        .txBit(txBit),
        .rData(rData)
    );

    // Clock generation (100 MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("uart_main.vcd");
        $dumpvars(0, main_tb);

        // Initialize
        rst   = 1;
        write = 0;
        read  = 0;
        addr  = 2'b00;
        data  = 8'd0;

        #20;
        rst = 0;

        //--------------------------------------------------
        // Configure UART
        //--------------------------------------------------

        @(posedge clk);
        write = 1;
        addr  = 2'b01;      // DIV_LOW
        data  = 8'd1;

        @(posedge clk);
        addr  = 2'b10;      // DIV_HIGH
        data  = 8'd0;

        @(posedge clk);
        addr  = 2'b11;      // CTRL
        data  = 8'b0000_0111;   // Baud Enable + TX Enable + RX Enable

        //--------------------------------------------------
        // Transmit 0xA5
        //--------------------------------------------------

        @(posedge clk);
        addr  = 2'b00;
        data  = 8'hA5;

        @(posedge clk);
        write = 0;

        //--------------------------------------------------
        // Wait for transmission/reception
        //--------------------------------------------------

        #200;

        //--------------------------------------------------
        // Read RX_DATA
        //--------------------------------------------------

        @(posedge clk);
        read = 1;
        addr = 2'b00;

        @(posedge clk);
        read = 0;

        #50;

        $finish;
    end

endmodule