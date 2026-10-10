read_lef /work/physical_design/lef/merged_sky130.lef
read_def /work/physical_design/sobel_floorplan.def

puts "=== TEST DEFAULT I/O PIN PLACEMENT ==="

place_pins

puts "=== DEFAULT I/O PIN PLACEMENT COMPLETED ==="

exit
