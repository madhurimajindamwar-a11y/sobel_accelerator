# Sobel Accelerator - Preliminary Power Analysis

# Load SKY130 typical-corner library
read_liberty /home/vsduser/Desktop/OpenSTA/vsdbabysoc/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# Load completed routed OpenROAD database
read_db physical_design/routing/sobel_detailed_pinfix.odb

# Database already contains the design
puts "===== DESIGN LOADED ====="

# Generate preliminary power report
report_power > results/power/power_tt_025C_1v80.rpt

puts "POWER_ANALYSIS_COMPLETE"
