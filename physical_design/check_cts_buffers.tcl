read_lef /work/physical_design/lef/merged_sky130.lef
read_liberty /pdk/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_db /work/physical_design/sobel_pdn.odb

puts "===== CHECK REQUESTED CTS CELLS ====="
foreach cell {
    sky130_fd_sc_hd__clkbuf_1
    sky130_fd_sc_hd__clkbuf_2
    sky130_fd_sc_hd__clkbuf_4
    sky130_fd_sc_hd__clkbuf_8
    sky130_fd_sc_hd__clkbuf_16
    sky130_fd_sc_hd__buf_1
    sky130_fd_sc_hd__buf_2
    sky130_fd_sc_hd__buf_4
} {
    puts "$cell : [ord::get_db_block]"
}
exit
