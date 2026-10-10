read_lef /work/physical_design/lef/sky130_sobel.lef
read_liberty /pdk/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_def /work/physical_design/floorplan.def

global_placement -density 0.7

write_def /work/physical_design/placement.def
