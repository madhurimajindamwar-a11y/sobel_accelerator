`timescale 1ns/1ps

module sobel_gate_tb;

    reg clk;
    reg rst;
    reg valid_in;
    reg [7:0] pixel_in;

    wire [7:0] edge_pixel;
    wire edge_valid;

    sobel_accelerator uut (
        .clk(clk),
        .rst(rst),
        .valid_in(valid_in),
        .pixel_in(pixel_in),
        .edge_pixel(edge_pixel),
        .edge_valid(edge_valid)
    );

    always #5 clk = ~clk;

    task send_pixel;
        input [7:0] pixel;
        begin
            @(negedge clk);
            valid_in = 1'b1;
            pixel_in = pixel;

            @(negedge clk);
            valid_in = 1'b0;
            pixel_in = 8'd0;
        end
    endtask

    always @(posedge clk) begin
        if (edge_valid)
            $display("GATE EDGE OUTPUT = %d", edge_pixel);
    end

    initial begin
        $dumpfile("mapped_sobel.vcd");
        $dumpvars(0, sobel_gate_tb);

        clk = 1'b0;
        rst = 1'b1;
        valid_in = 1'b0;
        pixel_in = 8'd0;

        #20;
        rst = 1'b0;

        // 5x5 image: 1 to 25
        send_pixel(8'd1);
        send_pixel(8'd2);
        send_pixel(8'd3);
        send_pixel(8'd4);
        send_pixel(8'd5);

        send_pixel(8'd6);
        send_pixel(8'd7);
        send_pixel(8'd8);
        send_pixel(8'd9);
        send_pixel(8'd10);

        send_pixel(8'd11);
        send_pixel(8'd12);
        send_pixel(8'd13);
        send_pixel(8'd14);
        send_pixel(8'd15);

        send_pixel(8'd16);
        send_pixel(8'd17);
        send_pixel(8'd18);
        send_pixel(8'd19);
        send_pixel(8'd20);

        send_pixel(8'd21);
        send_pixel(8'd22);
        send_pixel(8'd23);
        send_pixel(8'd24);
        send_pixel(8'd25);

        #100;
        $finish;
    end

endmodule
