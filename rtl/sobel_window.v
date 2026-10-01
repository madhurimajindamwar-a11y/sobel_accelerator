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

    output reg       window_valid
);

    reg [7:0] line1 [0:IMAGE_WIDTH-1];
    reg [7:0] line2 [0:IMAGE_WIDTH-1];

    integer col;

    always @(posedge clk) begin

        if (rst) begin

            col <= 0;
            window_valid <= 0;

            p1 <= 0;
            p2 <= 0;
            p3 <= 0;
            p4 <= 0;
            p5 <= 0;
            p6 <= 0;
            p7 <= 0;
            p8 <= 0;
            p9 <= 0;

        end
        else if (valid_in) begin

            /*
             * Create the 3x3 window.
             *
             * line2 = previous previous row
             * line1 = previous row
             * pixel_in = current row
             */

            if (col >= 2) begin

                p1 <= line2[col-2];
                p2 <= line2[col-1];
                p3 <= line2[col];

                p4 <= line1[col-2];
                p5 <= line1[col-1];
                p6 <= line1[col];

                p7 <= pixel_in;
                p8 <= pixel_in;
                p9 <= pixel_in;

                window_valid <= 1;

            end
            else begin
                window_valid <= 0;
            end

            /*
             * Shift image rows.
             */

            line2[col] <= line1[col];
            line1[col] <= pixel_in;

            /*
             * Move to next column.
             */

            if (col == IMAGE_WIDTH-1)
                col <= 0;
            else
                col <= col + 1;

        end

    end

endmodule
