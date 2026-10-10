`timescale 1ns/1ps

module sobel_core_corner_tb;

    reg [7:0] p1,p2,p3,p4,p5,p6,p7,p8,p9;
    wire [7:0] edge_pixel;
    integer errors = 0;
    integer tests = 0;

    sobel_core dut (
        .p1(p1), .p2(p2), .p3(p3),
        .p4(p4), .p5(p5), .p6(p6),
        .p7(p7), .p8(p8), .p9(p9),
        .edge_pixel(edge_pixel)
    );

    task check;
        input [7:0] expected;
        input [255:0] test_name;
        begin
            #1;
            tests = tests + 1;
            if (edge_pixel !== expected) begin
                errors = errors + 1;
                $display("FAIL: %0s expected=%0d actual=%0d",
                         test_name, expected, edge_pixel);
            end else begin
                $display("PASS: %0s output=%0d", test_name, edge_pixel);
            end
        end
    endtask

    initial begin
        // Case 1: all-zero window
        {p1,p2,p3,p4,p5,p6,p7,p8,p9} = {9{8'd0}};
        check(8'd0, "All-zero window");

        // Case 2: all-maximum window
        {p1,p2,p3,p4,p5,p6,p7,p8,p9} = {9{8'd255}};
        check(8'd0, "All-255 window");

        // Case 3: vertical edge, left side dark and right side bright
        p1=0; p2=0; p3=255;
        p4=0; p5=0; p6=255;
        p7=0; p8=0; p9=255;
        check(8'd255, "Vertical edge saturation");

        // Case 4: horizontal edge, top dark and bottom bright
        p1=0; p2=0; p3=0;
        p4=0; p5=0; p6=0;
        p7=255; p8=255; p9=255;
        check(8'd255, "Horizontal edge saturation");

        // Case 5: reversed vertical edge
        p1=255; p2=0; p3=0;
        p4=255; p5=0; p6=0;
        p7=255; p8=0; p9=0;
        check(8'd255, "Reversed vertical edge");

        // Case 6: reversed horizontal edge
        p1=255; p2=255; p3=255;
        p4=0;   p5=0;   p6=0;
        p7=0;   p8=0;   p9=0;
        check(8'd255, "Reversed horizontal edge");

        $display("--------------------------------");
        $display("Tests run: %0d", tests);
        $display("Errors:    %0d", errors);

        if (errors != 0)
            $fatal(1, "CORE CORNER TEST FAILED");

        $display("CORE CORNER TEST: PASS");
        $finish;
    end

endmodule
