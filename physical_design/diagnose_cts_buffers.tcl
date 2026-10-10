puts "===== LOAD SKY130 LEF ====="
read_lef /work/physical_design/lef/merged_sky130_cts.lef

puts "===== LOAD SKY130 LIBERTY ====="
read_liberty /pdk/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

puts "===== CHECK BEFORE DATABASE LOAD ====="
puts "clkbuf_1: [get_lib_cells sky130_fd_sc_hd__clkbuf_1]"
puts "clkbuf_16: [get_lib_cells sky130_fd_sc_hd__clkbuf_16]"

puts "===== LOAD SAVED PDN DATABASE ====="
read_db /work/physical_design/sobel_pdn.odb

puts "===== CHECK AFTER DATABASE LOAD ====="
puts "clkbuf_1: [get_lib_cells sky130_fd_sc_hd__clkbuf_1]"
puts "clkbuf_16: [get_lib_cells sky130_fd_sc_hd__clkbuf_16]"

exit
