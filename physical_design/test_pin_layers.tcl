read_lef /work/physical_design/lef/merged_sky130.lef
read_def /work/physical_design/sobel_floorplan.def

puts "=== TEST I/O PIN PLACEMENT ==="

place_pins -hor_layers met3 -ver_layers met2

puts "=== SINGLE-LAYER PIN TEST COMPLETED ==="

exit
