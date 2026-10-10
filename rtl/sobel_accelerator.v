module sobel_accelerator #(
    parameter IMAGE_WIDTH = 5
)(
    input        clk,
    input        rst,
    input        valid_in,
    input  [7:0] pixel_in,

    output [7:0] edge_pixel,
    output       edge_valid
);

    // ------------------------------------------------
    // 3x3 window signals
    // ------------------------------------------------

    wire [7:0] p1, p2, p3;
    wire [7:0] p4, p5, p6;
    wire [7:0] p7, p8, p9;

    wire window_valid;

    // ------------------------------------------------
    // Window generator
    // ------------------------------------------------

    sobel_window #(
        .IMAGE_WIDTH(IMAGE_WIDTH)
    ) window_unit (

        .clk(clk),
        .rst(rst),
        .valid_in(valid_in),
        .pixel_in(pixel_in),

        .p1(p1),
        .p2(p2),
        .p3(p3),

        .p4(p4),
        .p5(p5),
        .p6(p6),

        .p7(p7),
        .p8(p8),
        .p9(p9),

        .window_valid(window_valid)
    );

    // ------------------------------------------------
    // Sobel processing core
    // ------------------------------------------------

    sobel_core sobel_unit (

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

    // ------------------------------------------------
    // Edge output is valid whenever the window is valid
    // ------------------------------------------------

    assign edge_valid = window_valid;

endmodule
