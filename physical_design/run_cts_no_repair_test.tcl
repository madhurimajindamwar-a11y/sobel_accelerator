puts "===== LOAD SKY130 TECHNOLOGY ====="
read_lef /work/physical_design/lef/merged_sky130_cts.lef
read_liberty /pdk/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

puts "===== LOAD PDN CHECKPOINT ====="
read_db /work/physical_design/pdn/sobel_pdn_cts.odb

puts "===== LOAD TIMING CONSTRAINTS ====="
read_sdc /work/constraints/sobel.sdc

puts "===== SET CLOCK WIRE RC ====="
set_wire_rc -clock -layer met5
set_wire_rc -signal -layer met3
estimate_parasitics -placement
repair_clock_inverters
configure_cts_characterization -max_slew 1.5e-9 -max_cap 1.0e-12 -sqr_cap 0.0 -sqr_res 0.0

puts "===== RUN CLOCK TREE SYNTHESIS ====="
clock_tree_synthesis \
    -buf_list {sky130_fd_sc_hd__clkbuf_1 sky130_fd_sc_hd__clkbuf_2 sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_8} \
    -root_buf sky130_fd_sc_hd__clkbuf_16 \
    -clk_nets {clk}

puts "===== REPAIR CLOCK NETS ====="

puts "===== CHECK PLACEMENT ====="
detailed_placement
check_placement -verbose

puts "===== SAVE CTS CHECKPOINT ====="
write_def /work/physical_design/sobel_cts.def
write_db /work/physical_design/sobel_cts.odb

puts "===== REPORT POST-CTS TIMING ====="
estimate_parasitics -placement
repair_clock_inverters
configure_cts_characterization -max_slew 1.5e-9 -max_cap 1.0e-12 -sqr_cap 0.0 -sqr_res 0.0
report_checks -path_delay max
report_clock_skew

puts "===== CTS SCRIPT FINISHED ====="
exit
