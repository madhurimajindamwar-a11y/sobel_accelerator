read_lef /work/physical_design/lef/merged_sky130_cts.lef
read_liberty /pdk/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_def /work/physical_design/placement_candidate.def

# SKY130 standard-cell power nets
set ::env(VDD_PIN) VPWR
set ::env(GND_PIN) VGND
set ::env(VDD_NET) VPWR
set ::env(GND_NET) VGND

# Power-grid layers and provisional test dimensions
set ::env(FP_PDN_LOWER_LAYER) met4
set ::env(FP_PDN_UPPER_LAYER) met5
set ::env(FP_PDN_VWIDTH) 1.6
set ::env(FP_PDN_HWIDTH) 1.6
set ::env(FP_PDN_VPITCH) 40.0
set ::env(FP_PDN_HPITCH) 40.0
set ::env(FP_PDN_VOFFSET) 0
set ::env(FP_PDN_HOFFSET) 0

# Standard-cell rails; no core ring in this test
set ::env(DESIGN_IS_CORE) 1
set ::env(FP_PDN_CORE_RING) 0
set ::env(FP_PDN_ENABLE_GLOBAL_CONNECTIONS) 1
set ::env(FP_PDN_ENABLE_RAILS) 1
set ::env(FP_PDN_RAILS_LAYER) met1
set ::env(FP_PDN_RAIL_WIDTH) 0.48
set ::env(FP_PDN_RAIL_OFFSET) 0
set ::env(PLACE_SITE_HEIGHT) 2.7
set ::env(FP_HORIZONTAL_HALO) 0
set ::env(FP_VERTICAL_HALO) 0

puts "===== STARTING TEST PDN GENERATION ====="
pdngen /tmp/common_pdn.tcl -verbose

puts "===== CHECKING POWER GRID ====="
check_power_grid -net VPWR
check_power_grid -net VGND

write_def /work/physical_design/pdn/sobel_pdn_cts.def
write_db /work/physical_design/pdn/sobel_pdn_cts.odb

puts "===== TEST PDN GENERATION FINISHED ====="
exit
