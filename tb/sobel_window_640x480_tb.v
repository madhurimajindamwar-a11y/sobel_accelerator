`timescale 1ns/1ps

module sobel_window_640x480_tb;

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

    sobel_window #(.IMAGE_WIDTH(IMAGE_WIDTH)) dut (
        .clk(clk), .rst(rst),
        .valid_in(valid_in), .pixel_in(pixel_in),
        .p1(p1), .p2(p2), .p3(p3),
        .p4(p4), .p5(p5), .p6(p6),
        .p7(p7), .p8(p8), .p9(p9),
        .window_valid(window_valid)
    );

    always #5 clk = ~clk;

    always @(posedge clk) begin
        #1;
        if (!rst && window_valid) begin
            output_count = output_count + 1;

            if ({p1,p2,p3,p4,p5,p6,p7,p8,p9} !== 72'd0) begin
                errors = errors + 1;
                if (errors <= 5)
                    $display("ERROR: nonzero pixel in constant-zero window");
            end
        end
    end

    initial begin
        repeat (2) @(negedge clk);
        rst = 0;

        for (y = 0; y < IMAGE_HEIGHT; y = y + 1) begin
            for (x = 0; x < IMAGE_WIDTH; x = x + 1) begin
                @(negedge clk);
                pixel_in = 8'd0;
                valid_in = 1'b1;
            end
        end

        @(negedge clk);
        valid_in = 1'b0;
        repeat (2) @(negedge clk);
        #2;

        $display("----------------------------------------");
        $display("Image size:       %0d x %0d",
                 IMAGE_WIDTH, IMAGE_HEIGHT);
        $display("Input pixels:     %0d", IMAGE_WIDTH * IMAGE_HEIGHT);
        $display("Expected windows: %0d", EXPECTED_WINDOWS);
        $display("Actual windows:   %0d", output_count);
        $display("Errors:           %0d", errors);

        if (output_count != EXPECTED_WINDOWS || errors != 0)
            $fatal(1, "640x480 WINDOW TEST FAILED");

        $display("640x480 WINDOW TEST: PASS");
        $finish;
    end

endmodule
