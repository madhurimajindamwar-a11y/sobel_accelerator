read_lef /work/physical_design/lef/merged_sky130.lef
read_liberty /pdk/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_def /work/physical_design/sobel_floorplan.def

puts "=== TEST: LIMITED GLOBAL PLACEMENT ==="

auto_place_pins met3
global_placement -density 0.7 -overflow 0.3

puts "=== LIMITED GLOBAL PLACEMENT FINISHED ==="

write_def /work/physical_design/test_gp_limited.def
write_db /work/physical_design/test_gp_limited.odb

puts "=== DIAGNOSTIC OUTPUTS SAVED ==="
exit
