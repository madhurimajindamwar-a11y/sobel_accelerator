read_lef /data/vsdbabysoc/skywater-pdk-libs-sky130_fd_sc_hd/tech/sky130_fd_sc_hd.tlef

read_lef /data/vsdbabysoc/skywater-pdk-libs-sky130_fd_sc_hd/cells/nand2/sky130_fd_sc_hd__nand2_1.lef
read_lef /data/vsdbabysoc/skywater-pdk-libs-sky130_fd_sc_hd/cells/dfxtp/sky130_fd_sc_hd__dfxtp_1.lef

read_verilog /data/sobel_accelerator/physical_design/scripts/test_netlist.v

link_design test_netlist

puts "=== NETLIST LINK SUCCESS ==="

report_design_area

exit
