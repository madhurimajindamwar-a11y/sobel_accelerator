read_lef /pdk/skywater-pdk-libs-sky130_fd_sc_hd/tech/sky130_fd_sc_hd.tlef
read_lef /pdk/skywater-pdk-libs-sky130_fd_sc_hd/cells/dfxtp/sky130_fd_sc_hd__dfxtp_1.lef
read_liberty /pdk/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_verilog /work/synthesis/sobel_sky130_final.v
link_design sobel_accelerator
puts "=== NETLIST LINK SUCCESS ==="
exit
