read_lef /work/physical_design/lef/merged_sky130.lef
read_liberty /pdk/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_def /work/physical_design/test_gp_limited.def

puts "=== START DETAILED PLACEMENT ==="
detailed_placement

puts "=== CHECK PLACEMENT LEGALITY ==="
check_placement -verbose

puts "=== SAVE LEGALIZED PLACEMENT CANDIDATE ==="
write_def /work/physical_design/placement_candidate.def
write_db /work/physical_design/placement_candidate.odb

puts "=== LEGALIZATION SCRIPT COMPLETED ==="
exit
