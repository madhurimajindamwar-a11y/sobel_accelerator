`timescale 1ns/1ps

module sobel_window_reset_tb;

    reg clk = 0;
    reg rst = 1;
    reg valid_in = 0;
    reg [7:0] pixel_in = 0;

    wire [7:0] p1,p2,p3,p4,p5,p6,p7,p8,p9;
    wire window_valid;

    integer i;
    integer output_count = 0;
    integer errors = 0;

    sobel_window #(.IMAGE_WIDTH(5)) dut (
        .clk(clk), .rst(rst), .valid_in(valid_in),
        .pixel_in(pixel_in),
        .p1(p1), .p2(p2), .p3(p3),
        .p4(p4), .p5(p5), .p6(p6),
        .p7(p7), .p8(p8), .p9(p9),
        .window_valid(window_valid)
    );

    always #5 clk = ~clk;

    task send_pixel;
        input [7:0] value;
        begin
            @(negedge clk);
            pixel_in = value;
            valid_in = 1;
            @(posedge clk);
            #1;
            if (window_valid) begin
                output_count = output_count + 1;

                if (p1 !== (output_count == 1 ? 8'd101 :
                            output_count == 2 ? 8'd102 :
                            output_count == 3 ? 8'd103 :
                            output_count == 4 ? 8'd106 :
                            output_count == 5 ? 8'd107 :
                            output_count == 6 ? 8'd108 :
                            output_count == 7 ? 8'd111 :
                            output_count == 8 ? 8'd112 : 8'd113)) begin
                    errors = errors + 1;
                    $display("ERROR: unexpected p1 at output %0d: %0d",
                             output_count, p1);
                end
            end
        end
    endtask

    initial begin
        repeat (2) @(negedge clk);
        rst = 0;

        // Start an old stream, then reset before a complete frame.
        send_pixel(201);
        send_pixel(202);
        send_pixel(203);
        send_pixel(204);

        @(negedge clk);
        valid_in = 0;
        rst = 1;

        @(posedge clk);
        #1;
        if (window_valid !== 1'b0 ||
            {p1,p2,p3,p4,p5,p6,p7,p8,p9} !== 72'd0) begin
            errors = errors + 1;
            $display("ERROR: window state was not cleared by reset");
        end

        // Release reset and send a fresh image with values 101..125.
        @(negedge clk);
        rst = 0;

        for (i = 101; i <= 125; i = i + 1)
            send_pixel(i);

        @(negedge clk);
        valid_in = 0;
        #2;

        $display("--------------------------------");
        $display("Post-reset windows: %0d", output_count);
        $display("Errors: %0d", errors);

        if (output_count != 9 || errors != 0)
            $fatal(1, "RESET RECOVERY TEST FAILED");

        $display("RESET RECOVERY TEST: PASS");
        $finish;
    end

endmodule
