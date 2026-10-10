`timescale 1ns/1ps

module sobel_window_640x480_pattern_tb;

    localparam IMAGE_WIDTH  = 640;
    localparam IMAGE_HEIGHT = 480;
    localparam EXPECTED_WINDOWS =
        (IMAGE_WIDTH - 2) * (IMAGE_HEIGHT - 2);

    reg clk = 0;
    reg rst = 1;
    reg valid_in = 0;
    reg [7:0] pixel_in = 0;

    wire [7:0] p1,p2,p3,p4,p5,p6,p7,p8,p9;
    wire window_valid;

    integer x, y;
    integer output_count = 0;
    integer errors = 0;
    integer out_x, out_y;
    integer base;

    sobel_window #(.IMAGE_WIDTH(IMAGE_WIDTH)) dut (
        .clk(clk), .rst(rst),
        .valid_in(valid_in), .pixel_in(pixel_in),
        .p1(p1), .p2(p2), .p3(p3),
        .p4(p4), .p5(p5), .p6(p6),
        .p7(p7), .p8(p8), .p9(p9),
        .window_valid(window_valid)
    );

    // Deterministic, nonzero image pattern.
    function [7:0] pixel_value;
        input integer px;
        input integer py;
        integer value;
        begin
            value = (px * 3 + py * 7 + ((px * py) % 17)) % 256;
            pixel_value = value;
        end
    endfunction

    always #5 clk = ~clk;

    // Check all nine pixels of every generated window.
    always @(posedge clk) begin
        #1;
        if (!rst && window_valid) begin
            out_y = output_count / (IMAGE_WIDTH - 2);
            out_x = output_count % (IMAGE_WIDTH - 2);
            base = out_y * IMAGE_WIDTH + out_x;

            if (p1 !== pixel_value(out_x,     out_y)     ||
                p2 !== pixel_value(out_x + 1, out_y)     ||
                p3 !== pixel_value(out_x + 2, out_y)     ||
                p4 !== pixel_value(out_x,     out_y + 1) ||
                p5 !== pixel_value(out_x + 1, out_y + 1) ||
                p6 !== pixel_value(out_x + 2, out_y + 1) ||
                p7 !== pixel_value(out_x,     out_y + 2) ||
                p8 !== pixel_value(out_x + 1, out_y + 2) ||
                p9 !== pixel_value(out_x + 2, out_y + 2)) begin

                errors = errors + 1;
                if (errors <= 10)
                    $display(
                        "MISMATCH window=%0d at output x=%0d y=%0d",
                        output_count, out_x, out_y
                    );
            end

            output_count = output_count + 1;
        end
    end

    initial begin
        repeat (2) @(negedge clk);
        rst = 0;

        for (y = 0; y < IMAGE_HEIGHT; y = y + 1) begin
            for (x = 0; x < IMAGE_WIDTH; x = x + 1) begin
                @(negedge clk);
                pixel_in = pixel_value(x, y);
                valid_in = 1;
            end
        end

        @(negedge clk);
        valid_in = 0;
        repeat (2) @(negedge clk);
        #2;

        $display("----------------------------------------");
        $display("Image size:        %0d x %0d",
                 IMAGE_WIDTH, IMAGE_HEIGHT);
        $display("Expected windows:  %0d", EXPECTED_WINDOWS);
        $display("Actual windows:    %0d", output_count);
        $display("Window mismatches: %0d", errors);

        if (output_count != EXPECTED_WINDOWS || errors != 0)
            $fatal(1, "640x480 PATTERN TEST FAILED");

        $display("640x480 PATTERN TEST: PASS");
        $finish;
    end

endmodule
