
module sobel_core (
    input  [7:0] p1,
    input  [7:0] p2,
    input  [7:0] p3,
    input  [7:0] p4,
    input  [7:0] p5,
    input  [7:0] p6,
    input  [7:0] p7,
    input  [7:0] p8,
    input  [7:0] p9,

    output reg [7:0] edge_pixel
);

    integer gx;
    integer gy;
    integer magnitude;

    always @(*) begin

        // Horizontal gradient
        gx = -p1 + p3
           - (2 * p4) + (2 * p6)
           - p7 + p9;

        // Vertical gradient
        gy = -p1 - (2 * p2) - p3
           + p7 + (2 * p8) + p9;

        // Absolute value of Gx
        if (gx < 0)
            gx = -gx;

        // Absolute value of Gy
        if (gy < 0)
            gy = -gy;

        // Approximate gradient magnitude
        magnitude = gx + gy;

        // Saturation
        if (magnitude > 255)
            edge_pixel = 8'd255;
        else
            edge_pixel = magnitude[7:0];

    end

endmodule
