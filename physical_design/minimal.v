module child(input A, output Y);
assign Y = A;
endmodule

module minimal_test(input A, output Y);
child u1(.A(A), .Y(Y));
endmodule
