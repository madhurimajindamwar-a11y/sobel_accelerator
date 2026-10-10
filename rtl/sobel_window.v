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

    // ---------------------------------------------------------
    // Explicit line buffers
    // IMAGE_WIDTH = 5 for this project
    // ---------------------------------------------------------

    reg [7:0] line1_0, line1_1, line1_2, line1_3, line1_4;
    reg [7:0] line2_0, line2_1, line2_2, line2_3, line2_4;

    reg [2:0] col;
    reg [2:0] row;

    reg [7:0] row1_d1, row1_d2;
    reg [7:0] row2_d1, row2_d2;
    reg [7:0] row3_d1, row3_d2;

    reg [7:0] line1_current;
    reg [7:0] line2_current;

    // ---------------------------------------------------------
    // Select current column from explicit registers
    // ---------------------------------------------------------

    always @(*) begin

        line1_current = 8'd0;
        line2_current = 8'd0;

        case (col)

            3'd0: begin
                line1_current = line1_0;
                line2_current = line2_0;
            end

            3'd1: begin
                line1_current = line1_1;
                line2_current = line2_1;
            end

            3'd2: begin
                line1_current = line1_2;
                line2_current = line2_2;
            end

            3'd3: begin
                line1_current = line1_3;
                line2_current = line2_3;
            end

            3'd4: begin
                line1_current = line1_4;
                line2_current = line2_4;
            end

            default: begin
                line1_current = 8'd0;
                line2_current = 8'd0;
            end

        endcase
    end

    // ---------------------------------------------------------
    // Window generation
    // ---------------------------------------------------------

    always @(posedge clk) begin

        if (rst) begin

            col <= 3'd0;
            row <= 3'd0;

            line1_0 <= 8'd0;
            line1_1 <= 8'd0;
            line1_2 <= 8'd0;
            line1_3 <= 8'd0;
            line1_4 <= 8'd0;

            line2_0 <= 8'd0;
            line2_1 <= 8'd0;
            line2_2 <= 8'd0;
            line2_3 <= 8'd0;
            line2_4 <= 8'd0;

            row1_d1 <= 8'd0;
            row1_d2 <= 8'd0;

            row2_d1 <= 8'd0;
            row2_d2 <= 8'd0;

            row3_d1 <= 8'd0;
            row3_d2 <= 8'd0;

            p1 <= 8'd0;
            p2 <= 8'd0;
            p3 <= 8'd0;

            p4 <= 8'd0;
            p5 <= 8'd0;
            p6 <= 8'd0;

            p7 <= 8'd0;
            p8 <= 8'd0;
            p9 <= 8'd0;

            window_valid <= 1'b0;

        end

        else begin

            window_valid <= 1'b0;

            if (valid_in) begin

                // -------------------------------------------------
                // Current 3x3 window
                // -------------------------------------------------

                p1 <= row1_d2;
                p2 <= row1_d1;
                p3 <= line2_current;

                p4 <= row2_d2;
                p5 <= row2_d1;
                p6 <= line1_current;

                p7 <= row3_d2;
                p8 <= row3_d1;
                p9 <= pixel_in;

                // -------------------------------------------------
                // Shift horizontal pixels
                // -------------------------------------------------

                row1_d2 <= row1_d1;
                row1_d1 <= line2_current;

                row2_d2 <= row2_d1;
                row2_d1 <= line1_current;

                row3_d2 <= row3_d1;
                row3_d1 <= pixel_in;

                // -------------------------------------------------
                // Update line buffers
                // -------------------------------------------------

                case (col)

                    3'd0: begin
                        line2_0 <= line1_0;
                        line1_0 <= pixel_in;
                    end

                    3'd1: begin
                        line2_1 <= line1_1;
                        line1_1 <= pixel_in;
                    end

                    3'd2: begin
                        line2_2 <= line1_2;
                        line1_2 <= pixel_in;
                    end

                    3'd3: begin
                        line2_3 <= line1_3;
                        line1_3 <= pixel_in;
                    end

                    3'd4: begin
                        line2_4 <= line1_4;
                        line1_4 <= pixel_in;
                    end

                    default: begin
                    end

                endcase

                // -------------------------------------------------
                // Column counter
                // -------------------------------------------------

                if (col == 3'd4) begin
                    col <= 3'd0;

                    // Row counter
                    if (row != 3'd7)
                        row <= row + 3'd1;

                end
                else begin
                    col <= col + 3'd1;
                end

                // -------------------------------------------------
                // Valid window
                // A 3x3 window exists from row 2, column 2
                // -------------------------------------------------

                if ((row >= 3'd2) && (col >= 3'd2))
                    window_valid <= 1'b1;

            end
        end
    end

endmodule
