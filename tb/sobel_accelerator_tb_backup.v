module sobel_accelerator_tb;

    reg clk;
    reg rst;
    reg valid_in;
    reg [7:0] pixel_in;

    wire [7:0] edge_pixel;
    wire edge_valid;

    // ------------------------------------------------
    // Instantiate complete Sobel accelerator
    // ------------------------------------------------

    sobel_accelerator #(
        .IMAGE_WIDTH(5)
    ) uut (

        .clk(clk),
        .rst(rst),
        .valid_in(valid_in),
        .pixel_in(pixel_in),

        .edge_pixel(edge_pixel),
        .edge_valid(edge_valid)
    );

    // ------------------------------------------------
    // Clock
    // ------------------------------------------------

    always #5 clk = ~clk;

    // ------------------------------------------------
    // Send one pixel
    // ------------------------------------------------

    task send_pixel;
        input [7:0] pixel;

        begin
            @(negedge clk);
            pixel_in = pixel;
            valid_in = 1;
        end

    endtask

    // ------------------------------------------------
    // Test
    // ------------------------------------------------

    initial begin

        $dumpfile("sobel_accelerator.vcd");
        $dumpvars(0, sobel_accelerator_tb);

        clk = 0;
        rst = 1;
        valid_in = 0;
        pixel_in = 0;

        // Reset
        #20;
        rst = 0;

        // --------------------------------------------
        // 5x5 IMAGE
        // --------------------------------------------

        send_pixel(1);
        send_pixel(2);
        send_pixel(3);
        send_pixel(4);
        send_pixel(5);

        send_pixel(6);
        send_pixel(7);
        send_pixel(8);
        send_pixel(9);
        send_pixel(10);

        send_pixel(11);
        send_pixel(12);
        send_pixel(13);
        send_pixel(14);
        send_pixel(15);

        send_pixel(16);
        send_pixel(17);
        send_pixel(18);
        send_pixel(19);
        send_pixel(20);

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

    // ------------------------------------------------
    // Display Sobel output
    // ------------------------------------------------

    always @(posedge clk) begin

        #1;

        if (edge_valid) begin

            $display(
                "EDGE OUTPUT = %0d",
                edge_pixel
            );

        end

    end

endmodule
