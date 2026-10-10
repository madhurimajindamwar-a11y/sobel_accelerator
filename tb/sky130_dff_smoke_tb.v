`timescale 1ns/1ps

module sky130_dff_smoke_tb;
    reg clk = 0;
    reg d = 0;
    wire q;

    sky130_fd_sc_hd__dfxtp_1 dut (
        .CLK(clk),
        .D(d),
        .Q(q)
    );

    initial begin
        $monitor("time=%0t clk=%b d=%b q=%b",
                 $time, clk, d, q);

        #2 clk = 1;
        #2 clk = 0;
        d = 1;
        #2 clk = 1;
        #2;

        if (q === 1'b1)
            $display("DFF MODEL TEST: PASS");
        else
            $display("DFF MODEL TEST: FAIL");

        $finish;
    end
endmodule
