read_lef /work/physical_design/lef/merged_sky130_cts.lef
read_liberty /pdk/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_db /work/physical_design/sobel_cts_final.odb
read_sdc /work/constraints/sobel.sdc

puts "===== SET CLOCK PROPAGATION ====="
set_propagated_clock [all_clocks]

puts "===== ESTIMATE PARASITICS ====="
estimate_parasitics -placement

puts "===== POST-CTS MAX TIMING ====="
report_checks -path_delay max -format full_clock_expanded

puts "===== POST-CTS MIN TIMING ====="
report_checks -path_delay min -format full_clock_expanded

puts "===== POST-CTS CLOCK SKEW ====="
report_clock_skew

exit
