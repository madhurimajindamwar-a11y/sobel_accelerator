read_db /work/physical_design/sobel_floorplan.odb

puts "=== FLOORPLAN CHECK ==="
report_design_area
check_placement

puts "=== FLOORPLAN DATABASE READ SUCCESS ==="

exit
