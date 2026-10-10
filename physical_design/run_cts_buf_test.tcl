puts "===== LOAD SKY130 TECHNOLOGY ====="
read_lef /work/physical_design/lef/merged_sky130_cts.lef
read_liberty /pdk/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

puts "===== LOAD PDN CHECKPOINT ====="
read_db /work/physical_design/sobel_pdn.odb

puts "===== LOAD TIMING CONSTRAINTS ====="
read_sdc /work/constraints/sobel.sdc

puts "===== SET CLOCK WIRE RC ====="
set_wire_rc -clock -layer met5
set_wire_rc -signal -layer met3
estimate_parasitics -placement

puts "===== RUN CLOCK TREE SYNTHESIS ====="
clock_tree_synthesis \
    -buf_list {sky130_fd_sc_hd__buf_1 sky130_fd_sc_hd__buf_2 sky130_fd_sc_hd__buf_4 sky130_fd_sc_hd__buf_8} \
    -root_buf sky130_fd_sc_hd__buf_16 \
    -clk_nets {clk}

puts "===== REPAIR CLOCK NETS ====="
repair_clock_nets

puts "===== CHECK PLACEMENT ====="
detailed_placement
check_placement -verbose

puts "===== SAVE CTS CHECKPOINT ====="
write_def /work/physical_design/sobel_cts.def
write_db /work/physical_design/sobel_cts.odb

puts "===== REPORT POST-CTS TIMING ====="
estimate_parasitics -placement
report_checks -path_delay max
report_clock_skew

puts "===== CTS SCRIPT FINISHED ====="
exit
