
`timescale 1ns/1ps

module sobel_accelerator_tb;

    reg clk;
    reg rst;
    reg valid_in;
    reg [7:0] pixel_in;

    wire [7:0] edge_pixel;
    wire edge_valid;

    integer output_count;
    integer error_count;
    integer i;

    // Instantiate complete Sobel accelerator
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

    // 10 ns clock period
    always #5 clk = ~clk;

    // Send one pixel on a falling clock edge
    task send_pixel;
        input [7:0] pixel;
        begin
            @(negedge clk);
            pixel_in = pixel;
            valid_in = 1'b1;
        end
    endtask

    // Initialize testbench and stream a 5x5 image
    initial begin
        $dumpfile("sobel_accelerator.vcd");
        $dumpvars(0, sobel_accelerator_tb);

        clk         = 1'b0;
        rst         = 1'b1;
        valid_in    = 1'b0;
        pixel_in    = 8'd0;
        output_count = 0;
        error_count  = 0;

        // Apply reset
        repeat (2) @(negedge clk);
        rst = 1'b0;

        // 5x5 image: pixel values 1 through 25
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

        // Stop sending pixels
        @(negedge clk);
        valid_in = 1'b0;

        // Wait for the final output and monitor to settle
        repeat (4) @(negedge clk);
        #2;

        // Final verification summary
        $display("================================");
        if (output_count == 9 && error_count == 0) begin
            $display("SELF-CHECKING TEST: PASS");
        end
        else begin
            $display("SELF-CHECKING TEST: FAIL");
        end

        $display("Total outputs checked: %0d", output_count);
        $display("Incorrect outputs: %0d", error_count);
        $display("================================");

        if (output_count != 9 || error_count != 0)
            $fatal(1, "Sobel accelerator verification failed");

        $finish;
    end

    // Self-checking output monitor
    always @(posedge clk) begin
        #1;

        if (rst == 1'b0 && edge_valid === 1'b1) begin
            output_count = output_count + 1;

            // For this specific 5x5 test image, each
            // valid Sobel output is expected to equal 48.
            if (edge_pixel !== 8'd48) begin
                error_count = error_count + 1;
                $display(
                    "FAIL: Output %0d expected 48, got %0d",
                    output_count, edge_pixel
                );
            end
            else begin
                $display(
                    "PASS: Output %0d = %0d",
                    output_count, edge_pixel
                );
            end
        end
    end

endmodule
