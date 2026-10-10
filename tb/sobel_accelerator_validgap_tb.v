`timescale 1ns/1ps

module sobel_accelerator_validgap_tb;

    reg clk = 0;
    reg rst = 1;
    reg valid_in = 0;
    reg [7:0] pixel_in = 0;

    wire [7:0] edge_pixel;
    wire edge_valid;

    integer i;
    integer output_count = 0;
    integer errors = 0;

    sobel_accelerator #(.IMAGE_WIDTH(5)) dut (
        .clk(clk),
        .rst(rst),
        .valid_in(valid_in),
        .pixel_in(pixel_in),
        .edge_pixel(edge_pixel),
        .edge_valid(edge_valid)
    );

    always #5 clk = ~clk;

    always @(posedge clk) begin
        #1;
        if (rst) begin
            if (edge_valid !== 1'b0) begin
                errors = errors + 1;
                $display("ERROR: edge_valid not cleared during reset");
            end
        end else if (edge_valid === 1'b1) begin
            output_count = output_count + 1;
            if (edge_pixel !== 8'd48) begin
                errors = errors + 1;
                $display("ERROR: output %0d was %0d, expected 48",
                         output_count, edge_pixel);
            end
        end
    end

    task send_pixel;
        input [7:0] value;
        begin
            @(negedge clk);
            pixel_in = value;
            valid_in = 1;

            @(posedge clk);
            #2;
            valid_in = 0;

            // Insert an idle cycle after each pixel.
            @(negedge clk);
        end
    endtask

    initial begin
        repeat (2) @(negedge clk);
        rst = 0;

        for (i = 1; i <= 25; i = i + 1)
            send_pixel(i);

        @(negedge clk);
        valid_in = 0;
        repeat (3) @(negedge clk);
        #2;

        $display("--------------------------------");
        $display("Expected outputs: 9");
        $display("Actual outputs:   %0d", output_count);
        $display("Errors:           %0d", errors);

        if (output_count != 9 || errors != 0)
            $fatal(1, "VALID-GAP TEST FAILED");

        $display("ACCELERATOR VALID-GAP TEST: PASS");
        $finish;
    end

endmodule
