module test_netlist (
    input  A,
    input  B,
    input CLK,
    output Y
);

wire n1;

sky130_fd_sc_hd__nand2_1 u1 (
    .A(A),
    .B(B),
    .Y(n1)
);

sky130_fd_sc_hd__dfxtp_1 u2 (
    .D(n1),
    .CLK(CLK),
    .Q(Y)
);

endmodule
