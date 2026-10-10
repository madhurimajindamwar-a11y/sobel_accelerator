`timescale 1ns/1ps

module sobel_accelerator_640x480_tb;

    localparam W = 640;
    localparam H = 480;
    localparam EXPECTED = (W-2)*(H-2);

    reg clk = 0;
    reg rst = 1;
    reg valid_in = 0;
    reg [7:0] pixel_in = 0;

    wire [7:0] p1,p2,p3,p4,p5,p6,p7,p8,p9;
    wire window_valid;
    wire [7:0] edge_pixel;

    integer x,y;
    integer count = 0;
    integer errors = 0;
    integer gx,gy,mag;
    integer ox,oy;

    sobel_window #(.IMAGE_WIDTH(W)) window_unit (
        .clk(clk), .rst(rst), .valid_in(valid_in),
        .pixel_in(pixel_in),
        .p1(p1), .p2(p2), .p3(p3),
        .p4(p4), .p5(p5), .p6(p6),
        .p7(p7), .p8(p8), .p9(p9),
        .window_valid(window_valid)
    );

    sobel_core_balanced core_unit (
        .p1(p1), .p2(p2), .p3(p3),
        .p4(p4), .p5(p5), .p6(p6),
        .p7(p7), .p8(p8), .p9(p9),
        .edge_pixel(edge_pixel)
    );

    function [7:0] pix;
        input integer px, py;
        integer v;
        begin
            v = (px*3 + py*7 + ((px*py)%17)) % 256;
            pix = v;
        end
    endfunction

    function integer abs_int;
        input integer value;
        begin
            if (value < 0) abs_int = -value;
            else abs_int = value;
        end
    endfunction

    function [7:0] reference_edge;
        input integer px, py;
        integer a,b,c,d,e,f,g,h,i;
        integer rx,ry,m;
        begin
            a=pix(px,py);       b=pix(px+1,py);       c=pix(px+2,py);
            d=pix(px,py+1);     e=pix(px+1,py+1);     f=pix(px+2,py+1);
            g=pix(px,py+2);     h=pix(px+1,py+2);     i=pix(px+2,py+2);

            rx = -a+c-2*d+2*f-g+i;
            ry = -a-2*b-c+g+2*h+i;
            m = abs_int(rx)+abs_int(ry);

            if (m > 255) reference_edge = 8'd255;
            else reference_edge = m;
        end
    endfunction

    always #5 clk = ~clk;

    always @(posedge clk) begin
        #1;
        if (!rst && window_valid) begin
            ox = count % (W-2);
            oy = count / (W-2);

            if (edge_pixel !== reference_edge(ox,oy)) begin
                errors = errors + 1;
                if (errors <= 10)
                    $display("Mismatch output=%0d x=%0d y=%0d got=%0d expected=%0d",
                        count,ox,oy,edge_pixel,reference_edge(ox,oy));
            end
            count = count + 1;
        end
    end

    initial begin
        repeat (2) @(negedge clk);
        rst = 0;

        for (y=0; y<H; y=y+1) begin
            for (x=0; x<W; x=x+1) begin
                @(negedge clk);
                pixel_in = pix(x,y);
                valid_in = 1;
            end
        end

        @(negedge clk);
        valid_in = 0;
        repeat (2) @(negedge clk);
        #2;

        $display("----------------------------------------");
        $display("Image:             %0d x %0d",W,H);
        $display("Expected outputs:  %0d",EXPECTED);
        $display("Actual outputs:    %0d",count);
        $display("Output mismatches: %0d",errors);

        if (count != EXPECTED || errors != 0)
            $fatal(1,"FULL-FRAME ACCELERATOR TEST FAILED");

        $display("FULL-FRAME ACCELERATOR TEST: PASS");
        $finish;
    end

endmodule
