module sobel_window #(
    parameter IMAGE_WIDTH = 5
)(
    input        clk,
    input        rst,
    input        valid_in,
    input  [7:0] pixel_in,

    output reg [7:0] p1,
    output reg [7:0] p2,
    output reg [7:0] p3,
    output reg [7:0] p4,
    output reg [7:0] p5,
    output reg [7:0] p6,
    output reg [7:0] p7,
    output reg [7:0] p8,
    output reg [7:0] p9,

    output reg window_valid
);

    // ------------------------------------------------
    // Two line buffers
    // ------------------------------------------------

    reg [7:0] line1 [0:IMAGE_WIDTH-1];
    reg [7:0] line2 [0:IMAGE_WIDTH-1];

    // ------------------------------------------------
    // Horizontal shift registers
    // ------------------------------------------------

    reg [7:0] row1_d1, row1_d2;
    reg [7:0] row2_d1, row2_d2;
    reg [7:0] row3_d1, row3_d2;

    // ------------------------------------------------
    // Column and row counters
    // ------------------------------------------------

    integer col;
    integer row;

    always @(posedge clk) begin

        if (rst) begin

            col <= 0;
            row <= 0;

            row1_d1 <= 0;
            row1_d2 <= 0;

            row2_d1 <= 0;
            row2_d2 <= 0;

            row3_d1 <= 0;
            row3_d2 <= 0;

            p1 <= 0;
            p2 <= 0;
            p3 <= 0;

            p4 <= 0;
            p5 <= 0;
            p6 <= 0;

            p7 <= 0;
            p8 <= 0;
            p9 <= 0;

            window_valid <= 0;

        end

        else begin

            // Default: window is invalid
            window_valid <= 0;

            if (valid_in) begin

                // ----------------------------------------
                // A 3x3 window is valid only after:
                //   - two complete rows
                //   - two pixels of the current row
                // ----------------------------------------

                if ((row >= 2) && (col >= 2)) begin

                    // Top row
                    p1 <= row1_d2;
                    p2 <= row1_d1;
                    p3 <= line2[col];

                    // Middle row
                    p4 <= row2_d2;
                    p5 <= row2_d1;
                    p6 <= line1[col];

                    // Bottom row
                    p7 <= row3_d2;
                    p8 <= row3_d1;
                    p9 <= pixel_in;

                    window_valid <= 1;

                end

                // ----------------------------------------
                // Update horizontal shift registers
                // ----------------------------------------

                row1_d2 <= row1_d1;
                row1_d1 <= line2[col];

                row2_d2 <= row2_d1;
                row2_d1 <= line1[col];

                row3_d2 <= row3_d1;
                row3_d1 <= pixel_in;

                // ----------------------------------------
                // Update line buffers
                // ----------------------------------------

                line2[col] <= line1[col];
                line1[col] <= pixel_in;

                // ----------------------------------------
                // Move column
                // ----------------------------------------

                if (col == IMAGE_WIDTH-1) begin

                    col <= 0;
                    row <= row + 1;

                end

                else begin

                    col <= col + 1;

                end

            end

        end

    end

endmodule
