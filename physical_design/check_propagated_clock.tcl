read_lef /work/physical_design/lef/merged_sky130_cts.lef
read_liberty /pdk/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_db /work/physical_design/sobel_cts_final.odb
read_sdc /work/constraints/sobel.sdc

puts "===== CHECK CLOCK COMMANDS ====="
help set_propagated_clock
help report_checks
help estimate_parasitics

puts "===== CHECK CLOCK OBJECT ====="
report_clock_properties [get_clocks clk]

exit
