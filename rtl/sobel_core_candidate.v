module sobel_core (
    input  [7:0] p1, p2, p3,
    input  [7:0] p4, p5, p6,
    input  [7:0] p7, p8, p9,
    output reg [7:0] edge_pixel
);

    // Signed 11-bit gradients: enough for the Sobel range.
    reg signed [10:0] gx;
    reg signed [10:0] gy;

    reg [10:0] abs_gx;
    reg [10:0] abs_gy;
    reg [11:0] magnitude;

    always @(*) begin
        gx = -$signed({1'b0, p1})
             + $signed({1'b0, p3})
             - ($signed({1'b0, p4}) <<< 1)
             + ($signed({1'b0, p6}) <<< 1)
             - $signed({1'b0, p7})
             + $signed({1'b0, p9});

        gy = -$signed({1'b0, p1})
             - ($signed({1'b0, p2}) <<< 1)
             - $signed({1'b0, p3})
             + $signed({1'b0, p7})
             + ($signed({1'b0, p8}) <<< 1)
             + $signed({1'b0, p9});

        abs_gx = gx[10] ? -gx : gx;
        abs_gy = gy[10] ? -gy : gy;
        magnitude = abs_gx + abs_gy;

        if (magnitude > 12'd255)
            edge_pixel = 8'd255;
        else
            edge_pixel = magnitude[7:0];
    end

endmodule
