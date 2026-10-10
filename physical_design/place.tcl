# ============================================
# Sobel Accelerator - SKY130 Placement Flow
# ============================================

# Step 1: Load merged technology and standard-cell LEF
read_lef /work/physical_design/lef/merged_sky130.lef

# Step 2: Load SKY130 timing library
read_liberty /pdk/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# Step 3: Load the verified floorplan
read_def /work/physical_design/sobel_floorplan.def

# Step 4: Place top-level I/O pins
puts "=== START AUTOMATIC I/O PIN PLACEMENT ==="

auto_place_pins met3

# Step 5: Run global placement
puts "=== START GLOBAL PLACEMENT ==="

global_placement -density 0.7

# Step 6: Legalize standard-cell placement
puts "=== START DETAILED PLACEMENT ==="

detailed_placement

# Step 7: Check placement legality
puts "=== CHECK PLACEMENT LEGALITY ==="

check_placement -verbose

# Step 8: Save placement results
puts "=== SAVE PLACEMENT RESULTS ==="

write_def /work/physical_design/placement.def
write_db /work/physical_design/placement.odb

puts "=== PLACEMENT FLOW COMPLETED ==="

exit

