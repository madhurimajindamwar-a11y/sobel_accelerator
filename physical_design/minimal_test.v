module minimal_test (
    input A,
    output Y
);

sky130_fd_sc_hd__clkinv_1 test_inv (
    .A(A),
    .Y(Y)
);

endmodule
