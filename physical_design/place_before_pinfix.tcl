# ============================================
# Sobel Accelerator - SKY130 Placement
# ============================================

# Read the merged SKY130 technology and cell LEF
read_lef /work/physical_design/lef/merged_sky130.lef

# Read the SKY130 standard-cell timing library
read_liberty /pdk/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# Load the verified floorplan
read_def /work/physical_design/sobel_floorplan.def

puts "=== START GLOBAL PLACEMENT ==="

# Global placement
global_placement -density 0.7

puts "=== START DETAILED PLACEMENT ==="

# Legalize cell locations
detailed_placement

# Check that the placement is legal
check_placement -verbose

# Save placement results
write_def /work/physical_design/placement.def
write_db /work/physical_design/placement.odb

puts "=== PLACEMENT FLOW COMPLETED ==="

exit
