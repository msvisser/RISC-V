module mmio (
    input reset_n,

    input [13:0] address,
    input [3:0] byteena,
    input clken,
    input clock,
    input [31:0] data,
    input wren,
    output [31:0] q,

    output [9:0] led
);

logic [13:0] internal_address;
logic [3:0] internal_byteena;
logic [31:0] internal_data;
logic internal_wren;

logic [9:0] led_state;
logic [9:0] next_led_state;

always_comb begin
    led = led_state;
    next_led_state = led_state;

    case (internal_address)
        14'h0000: q = {22'b0, led_state};
        default: q = 0;
    endcase

    if (internal_wren) begin
        if (internal_address == 14'h0000) begin
            if (internal_byteena[0])
                next_led_state[7:0] = internal_data[7:0];
            if (internal_byteena[1])
                next_led_state[9:8] = internal_data[9:8];
        end
    end
end

always_ff @(posedge clock) begin
    if (!reset_n) begin
        internal_address <= 0;
        internal_byteena <= 0;
        internal_data <= 0;
        internal_wren <= 0;
    end else if (clken) begin
        internal_address <= address;
        internal_byteena <= byteena;
        internal_data <= data;
        internal_wren <= wren;
    end else begin
        // Reset the write enable after a single cycle
        internal_wren <= 0;
    end

    if (!reset_n) begin
        led_state <= 0;
    end else begin
        led_state <= next_led_state;
    end
end

endmodule
