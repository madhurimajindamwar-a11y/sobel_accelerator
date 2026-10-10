module sobel_window_tb;

    reg clk;
    reg rst;
    reg valid_in;
    reg [7:0] pixel_in;

    wire [7:0] p1, p2, p3;
    wire [7:0] p4, p5, p6;
    wire [7:0] p7, p8, p9;
    wire window_valid;

    // Instantiate Sobel window generator
    sobel_window #(
        .IMAGE_WIDTH(5)
    ) uut (
        .clk(clk),
        .rst(rst),
        .valid_in(valid_in),
        .pixel_in(pixel_in),

        .p1(p1),
        .p2(p2),
        .p3(p3),
        .p4(p4),
        .p5(p5),
        .p6(p6),
        .p7(p7),
        .p8(p8),
        .p9(p9),

        .window_valid(window_valid)
    );

    // Clock: 10 ns period
    always #5 clk = ~clk;

    // Send one pixel
    task send_pixel;
        input [7:0] pixel;
        begin
            @(negedge clk);
            pixel_in = pixel;
            valid_in = 1;
        end
    endtask

    initial begin

        // Create waveform
        $dumpfile("sobel_window.vcd");
        $dumpvars(0, sobel_window_tb);

        // Initial values
        clk = 0;
        rst = 1;
        valid_in = 0;
        pixel_in = 0;

        // Reset
        #20;
        rst = 0;

        // -------------------------
        // IMAGE ROW 1
        // -------------------------
        send_pixel(1);
        send_pixel(2);
        send_pixel(3);
        send_pixel(4);
        send_pixel(5);

        // -------------------------
        // IMAGE ROW 2
        // -------------------------
        send_pixel(6);
        send_pixel(7);
        send_pixel(8);
        send_pixel(9);
        send_pixel(10);

        // -------------------------
        // IMAGE ROW 3
        // -------------------------
        send_pixel(11);
        send_pixel(12);
        send_pixel(13);
        send_pixel(14);
        send_pixel(15);

        // -------------------------
        // IMAGE ROW 4
        // -------------------------
        send_pixel(16);
        send_pixel(17);
        send_pixel(18);
        send_pixel(19);
        send_pixel(20);

        // -------------------------
        // IMAGE ROW 5
        // -------------------------
        send_pixel(21);
        send_pixel(22);
        send_pixel(23);
        send_pixel(24);
        send_pixel(25);

        // Stop input
        @(negedge clk);
        valid_in = 0;

        #30;

        $finish;

    end

    // Display the generated window
    always @(posedge clk) begin

        #1;

        if (window_valid) begin

            $display(
                "WINDOW: %0d %0d %0d | %0d %0d %0d | %0d %0d %0d",
                p1, p2, p3,
                p4, p5, p6,
                p7, p8, p9
            );

        end

    end

endmodule
