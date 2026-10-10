`timescale 1ns/1ps

module sobel_window_selfcheck_tb;

    reg clk = 0;
    reg rst = 1;
    reg valid_in = 0;
    reg [7:0] pixel_in = 0;

    wire [7:0] p1, p2, p3, p4, p5, p6, p7, p8, p9;
    wire window_valid;

    integer i;
    integer j;
    integer output_count = 0;
    integer errors = 0;
    reg [7:0] expected [0:8][0:8];

    sobel_window #(.IMAGE_WIDTH(5)) dut (
        .clk(clk),
        .rst(rst),
        .valid_in(valid_in),
        .pixel_in(pixel_in),
        .p1(p1), .p2(p2), .p3(p3),
        .p4(p4), .p5(p5), .p6(p6),
        .p7(p7), .p8(p8), .p9(p9),
        .window_valid(window_valid)
    );

    always #5 clk = ~clk;

    task send_pixel;
        input [7:0] value;
        begin
            @(negedge clk);
            pixel_in = value;
            valid_in = 1;
            @(posedge clk);
            #1;
            if (window_valid) begin
                case (output_count)
                    0: if ({p1,p2,p3,p4,p5,p6,p7,p8,p9} !==
                           {expected[0][0],expected[0][1],expected[0][2],
                            expected[0][3],expected[0][4],expected[0][5],
                            expected[0][6],expected[0][7],expected[0][8]})
                           errors = errors + 1;
                    1: if ({p1,p2,p3,p4,p5,p6,p7,p8,p9} !==
                           {expected[1][0],expected[1][1],expected[1][2],
                            expected[1][3],expected[1][4],expected[1][5],
                            expected[1][6],expected[1][7],expected[1][8]})
                           errors = errors + 1;
                    2: if ({p1,p2,p3,p4,p5,p6,p7,p8,p9} !==
                           {expected[2][0],expected[2][1],expected[2][2],
                            expected[2][3],expected[2][4],expected[2][5],
                            expected[2][6],expected[2][7],expected[2][8]})
                           errors = errors + 1;
                    3: if ({p1,p2,p3,p4,p5,p6,p7,p8,p9} !==
                           {expected[3][0],expected[3][1],expected[3][2],
                            expected[3][3],expected[3][4],expected[3][5],
                            expected[3][6],expected[3][7],expected[3][8]})
                           errors = errors + 1;
                    4: if ({p1,p2,p3,p4,p5,p6,p7,p8,p9} !==
                           {expected[4][0],expected[4][1],expected[4][2],
                            expected[4][3],expected[4][4],expected[4][5],
                            expected[4][6],expected[4][7],expected[4][8]})
                           errors = errors + 1;
                    5: if ({p1,p2,p3,p4,p5,p6,p7,p8,p9} !==
                           {expected[5][0],expected[5][1],expected[5][2],
                            expected[5][3],expected[5][4],expected[5][5],
                            expected[5][6],expected[5][7],expected[5][8]})
                           errors = errors + 1;
                    6: if ({p1,p2,p3,p4,p5,p6,p7,p8,p9} !==
                           {expected[6][0],expected[6][1],expected[6][2],
                            expected[6][3],expected[6][4],expected[6][5],
                            expected[6][6],expected[6][7],expected[6][8]})
                           errors = errors + 1;
                    7: if ({p1,p2,p3,p4,p5,p6,p7,p8,p9} !==
                           {expected[7][0],expected[7][1],expected[7][2],
                            expected[7][3],expected[7][4],expected[7][5],
                            expected[7][6],expected[7][7],expected[7][8]})
                           errors = errors + 1;
                    8: if ({p1,p2,p3,p4,p5,p6,p7,p8,p9} !==
                           {expected[8][0],expected[8][1],expected[8][2],
                            expected[8][3],expected[8][4],expected[8][5],
                            expected[8][6],expected[8][7],expected[8][8]})
                           errors = errors + 1;
                    default: errors = errors + 1;
                endcase

                $display("Window %0d: %0d %0d %0d | %0d %0d %0d | %0d %0d %0d",
                         output_count + 1, p1,p2,p3,p4,p5,p6,p7,p8,p9);
                output_count = output_count + 1;
            end
        end
    endtask

    initial begin
        expected[0][0]=1;  expected[0][1]=2;  expected[0][2]=3;
        expected[0][3]=6;  expected[0][4]=7;  expected[0][5]=8;
        expected[0][6]=11; expected[0][7]=12; expected[0][8]=13;

        expected[1][0]=2;  expected[1][1]=3;  expected[1][2]=4;
        expected[1][3]=7;  expected[1][4]=8;  expected[1][5]=9;
        expected[1][6]=12; expected[1][7]=13; expected[1][8]=14;

        expected[2][0]=3;  expected[2][1]=4;  expected[2][2]=5;
        expected[2][3]=8;  expected[2][4]=9;  expected[2][5]=10;
        expected[2][6]=13; expected[2][7]=14; expected[2][8]=15;

        expected[3][0]=6;  expected[3][1]=7;  expected[3][2]=8;
        expected[3][3]=11; expected[3][4]=12; expected[3][5]=13;
        expected[3][6]=16; expected[3][7]=17; expected[3][8]=18;

        expected[4][0]=7;  expected[4][1]=8;  expected[4][2]=9;
        expected[4][3]=12; expected[4][4]=13; expected[4][5]=14;
        expected[4][6]=17; expected[4][7]=18; expected[4][8]=19;

        expected[5][0]=8;  expected[5][1]=9;  expected[5][2]=10;
        expected[5][3]=13; expected[5][4]=14; expected[5][5]=15;
        expected[5][6]=18; expected[5][7]=19; expected[5][8]=20;

        expected[6][0]=11; expected[6][1]=12; expected[6][2]=13;
        expected[6][3]=16; expected[6][4]=17; expected[6][5]=18;
        expected[6][6]=21; expected[6][7]=22; expected[6][8]=23;

        expected[7][0]=12; expected[7][1]=13; expected[7][2]=14;
        expected[7][3]=17; expected[7][4]=18; expected[7][5]=19;
        expected[7][6]=22; expected[7][7]=23; expected[7][8]=24;

        expected[8][0]=13; expected[8][1]=14; expected[8][2]=15;
        expected[8][3]=18; expected[8][4]=19; expected[8][5]=20;
        expected[8][6]=23; expected[8][7]=24; expected[8][8]=25;

        repeat (2) @(negedge clk);
        rst = 0;

        for (i=1; i<=25; i=i+1) begin
            if (i==4 || i==11 || i==19) begin
                @(negedge clk);
                valid_in = 0;
                repeat (2) @(negedge clk);
            end
            send_pixel(i);
        end

        @(negedge clk);
        valid_in = 0;
        #2;

        $display("--------------------------------");
        $display("Expected windows: 9");
        $display("Actual windows:   %0d", output_count);
        $display("Window mismatches: %0d", errors);

        if (output_count != 9 || errors != 0)
            $fatal(1, "WINDOW SELF-CHECK FAILED");

        $display("WINDOW SELF-CHECK: PASS");
        $finish;
    end
endmodule
