read_liberty /pdk/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_verilog /work/synthesis/sobel_accelerator_balanced_sky130.v
link_design sobel_accelerator_balanced
read_sdc /work/constraints/sobel.sdc
report_checks -path_delay max -format full
exit
