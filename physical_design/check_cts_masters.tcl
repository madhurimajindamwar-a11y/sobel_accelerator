read_lef /work/physical_design/lef/merged_sky130_cts.lef
read_liberty /pdk/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_db /work/physical_design/sobel_pdn.odb

puts "===== CHECK CTS BUFFER LIBRARY CELLS ====="
foreach cell {
    sky130_fd_sc_hd__buf_1
    sky130_fd_sc_hd__buf_2
    sky130_fd_sc_hd__clkbuf_1
    sky130_fd_sc_hd__clkbuf_16
} {
    set found [get_lib_cells $cell]
    if {[llength $found] > 0} {
        puts "$cell : FOUND in Liberty"
    } else {
        puts "$cell : MISSING from Liberty"
    }
}

puts "===== CHECK COMPLETE ====="
exit
