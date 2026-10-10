read_lef /work/physical_design/lef/sky130_sobel.lef
read_liberty /pdk/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_verilog /work/synthesis/sobel_sky130_final.v

link_design sobel_accelerator

puts "=== BEFORE FLOORPLAN ==="
report_design_area

initialize_floorplan \
  -die_area "0 0 200 200" \
  -core_area "20 20 180 180" \
  -site unithd

puts "=== AFTER FLOORPLAN ==="
report_design_area

write_def /work/physical_design/floorplan.def
