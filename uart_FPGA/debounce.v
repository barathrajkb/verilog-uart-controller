module debounce(
    input clk,
    input button,
    output reg pulse = 0
);

reg sync0 = 0;
reg sync1 = 0;

reg buttonState = 0;
reg [19:0] counter = 0;

//--------------------------------------------------
// Synchronizer
//--------------------------------------------------

always @(posedge clk) begin
    sync0 <= button;
    sync1 <= sync0;
end

//--------------------------------------------------
// Debounce
//--------------------------------------------------

always @(posedge clk) begin

    pulse <= 0;

    if(sync1 == buttonState) begin
        counter <= 0;
    end
    else begin
        counter <= counter + 1;

        // 20 ms @ 27 MHz = 540000 clocks
        if(counter == 20'd539999) begin
            counter <= 0;
            buttonState <= sync1;

            // Generate one-clock pulse only on button press
            if(sync1)
                pulse <= 1;
        end
    end

end

endmodule