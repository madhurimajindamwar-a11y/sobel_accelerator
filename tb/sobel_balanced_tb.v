module sobel_balanced_tb;
    reg [7:0] p1,p2,p3,p4,p5,p6,p7,p8,p9;
    wire [7:0] original_out, balanced_out;
    integer i, errors;

    sobel_core original (
        .p1(p1), .p2(p2), .p3(p3),
        .p4(p4), .p5(p5), .p6(p6),
        .p7(p7), .p8(p8), .p9(p9),
        .edge_pixel(original_out)
    );

    sobel_core_balanced balanced (
        .p1(p1), .p2(p2), .p3(p3),
        .p4(p4), .p5(p5), .p6(p6),
        .p7(p7), .p8(p8), .p9(p9),
        .edge_pixel(balanced_out)
    );

    initial begin
        errors = 0;

        for (i = 0; i < 10000; i = i + 1) begin
            p1=$random; p2=$random; p3=$random;
            p4=$random; p5=$random; p6=$random;
            p7=$random; p8=$random; p9=$random;
            #1;
            if (original_out !== balanced_out) begin
                errors = errors + 1;
                if (errors <= 10)
                    $display("Mismatch %0d: original=%0d balanced=%0d",
                             i, original_out, balanced_out);
            end
        end

        if (errors == 0)
            $display("PASS: All 10000 balanced-core comparisons matched.");
        else
            $display("FAIL: %0d mismatches.", errors);

        $finish;
    end
endmodule
