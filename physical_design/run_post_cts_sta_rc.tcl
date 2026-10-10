read_lef /work/physical_design/lef/merged_sky130_cts.lef
read_liberty /pdk/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_db /work/physical_design/sobel_cts_final.odb
read_sdc /work/constraints/sobel.sdc

puts "===== CONFIGURE WIRE RC ====="
set_wire_rc -clock -layer met5
set_wire_rc -signal -layer met3

puts "===== ENABLE PROPAGATED CLOCK ====="
set_propagated_clock [all_clocks]

puts "===== ESTIMATE PLACEMENT PARASITICS ====="
estimate_parasitics -placement

puts "===== SETUP TIMING ====="
report_checks -path_delay max -format full_clock_expanded

puts "===== HOLD TIMING ====="
report_checks -path_delay min -format full_clock_expanded

puts "===== CLOCK SKEW ====="
report_clock_skew

exit
