`timescale 1ns/1ps

module sobel_gls_diag_tb;
    reg clk = 0;
    reg rst = 1;
    reg valid_in = 0;
    reg [7:0] pixel_in = 0;
    wire [7:0] edge_pixel;
    wire edge_valid;
    integer i;

    sobel_accelerator uut (
        .clk(clk),
        .rst(rst),
        .valid_in(valid_in),
        .pixel_in(pixel_in),
        .edge_pixel(edge_pixel),
        .edge_valid(edge_valid)
    );

    always #5 clk = ~clk;

    initial begin
        $display("time rst valid_in edge_valid edge_pixel");
        $monitor("%0t %b %b %b %d",
                 $time, rst, valid_in, edge_valid, edge_pixel);

        repeat (3) @(negedge clk);
        rst = 0;

        for (i = 1; i <= 25; i = i + 1) begin
            @(negedge clk);
            valid_in = 1;
            pixel_in = i;
        end

        @(negedge clk);
        valid_in = 0;
        pixel_in = 0;

        repeat (5) @(negedge clk);
        $finish;
    end
endmodule
