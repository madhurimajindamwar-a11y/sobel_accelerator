module sobel_core_balanced (
    input [7:0] p1,p2,p3,p4,p5,p6,p7,p8,p9,
    output reg [7:0] edge_pixel
);
    reg signed [9:0] gx_pair, gy_pair;
    reg signed [9:0] gx_double, gy_double;
    reg signed [10:0] gx, gy;
    reg [10:0] abs_gx, abs_gy;
    reg [11:0] magnitude;

    always @(*) begin
        gx_pair =
            ($signed({2'b00,p3}) + $signed({2'b00,p9}))
          - ($signed({2'b00,p1}) + $signed({2'b00,p7}));

        gy_pair =
            ($signed({2'b00,p7}) + $signed({2'b00,p9}))
          - ($signed({2'b00,p1}) + $signed({2'b00,p3}));

        gx_double =
            ($signed({2'b00,p6}) - $signed({2'b00,p4})) <<< 1;

        gy_double =
            ($signed({2'b00,p8}) - $signed({2'b00,p2})) <<< 1;

        gx = gx_pair + gx_double;
        gy = gy_pair + gy_double;

        abs_gx = gx[10] ? -gx : gx;
        abs_gy = gy[10] ? -gy : gy;
        magnitude = abs_gx + abs_gy;

        if (magnitude > 12'd255)
            edge_pixel = 8'd255;
        else
            edge_pixel = magnitude[7:0];
    end
endmodule
