module regfile (
    input clk,
    input reset_n,

    input [4:0] address_reg1,
    input [4:0] address_reg2,
    output [31:0] output_reg1,
    output [31:0] output_reg2,

    input [4:0] address_dest,
    input [31:0] data_dest,
    input write_dest
);

logic [31:0] regs[0:31];

initial begin
    for (int i = 0; i < 32; i++) begin
        regs[i] = 32'h0;
    end
end

always_comb begin
    output_reg1 = regs[address_reg1];
    output_reg2 = regs[address_reg2];
end

always_ff @(posedge clk) begin
    if (!reset_n) begin
        for (int i = 0; i < 32; i++) begin
            regs[i] <= 32'h0;
        end
    end
    else begin
        if (write_dest && address_dest != 0) begin
            regs[address_dest] <= data_dest;
        end
    end
end

endmodule
