read_lef /work/physical_design/lef/merged_sky130.lef
read_liberty /pdk/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_def /work/physical_design/sobel_floorplan.def

puts "===== CHECKING ALTERNATIVE PLACEMENT COMMAND ====="
help global_placement_or
puts "===== CHECKING DETAILED PLACEMENT COMMAND ====="
help detailed_placement

exit
