read_lef /work/physical_design/lef/merged_sky130.lef
read_def /work/physical_design/sobel_floorplan.def

puts "=== TEST AUTOMATIC I/O PIN PLACEMENT ==="

auto_place_pins met3

puts "=== AUTOMATIC PIN PLACEMENT TEST COMPLETED ==="

exit
