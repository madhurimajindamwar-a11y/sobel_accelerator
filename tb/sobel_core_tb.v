module sobel_core_tb;

    reg [7:0] p1, p2, p3;
    reg [7:0] p4, p5, p6;
    reg [7:0] p7, p8, p9;

    wire [7:0] edge_pixel;

    sobel_core uut (
        .p1(p1),
        .p2(p2),
        .p3(p3),
        .p4(p4),
        .p5(p5),
        .p6(p6),
        .p7(p7),
        .p8(p8),
        .p9(p9),
        .edge_pixel(edge_pixel)
    );

    initial begin

        // Test pattern 1
        p1 = 10; p2 = 10; p3 = 10;
        p4 = 10; p5 = 10; p6 = 10;
        p7 = 10; p8 = 10; p9 = 10;

        #10;

        $display("Test 1 Edge = %d", edge_pixel);

        // Test pattern 2
        p1 = 0; p2 = 0; p3 = 255;
        p4 = 0; p5 = 0; p6 = 255;
        p7 = 0; p8 = 0; p9 = 255;

        #10;

        $display("Test 2 Edge = %d", edge_pixel);

        // Test pattern 3
        p1 = 0; p2 = 0; p3 = 0;
        p4 = 0; p5 = 0; p6 = 0;
        p7 = 255; p8 = 255; p9 = 255;

        #10;

        $display("Test 3 Edge = %d", edge_pixel);

        $finish;

    end

endmodule
