read_lef /work/physical_design/lef/sky130_sobel.lef
read_liberty /pdk/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_verilog /work/physical_design/lef/sky130_sobel_blackboxes.v
read_verilog /work/physical_design/minimal_test.v
link_design minimal_test

report_design_area
write_def /work/physical_design/minimal_test.def
