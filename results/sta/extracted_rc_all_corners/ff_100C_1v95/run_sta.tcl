
read_lef /home/vsduser/Desktop/sobel_accelerator_github/physical_design/lef/merged_sky130_cts.lef
read_liberty /home/vsduser/Desktop/OpenSTA/vsdbabysoc/lib/sky130_fd_sc_hd__ff_100C_1v95.lib
read_def /home/vsduser/Desktop/sobel_accelerator_github/physical_design/routing/sobel_detailed_pinfix.def
read_sdc /home/vsduser/Desktop/sobel_accelerator_github/constraints/sobel.sdc
set_propagated_clock [all_clocks]

read_spef /home/vsduser/Desktop/sobel_accelerator_github/results/sta/openrcx_test/sobel_extracted.spef

puts "===== SETUP ====="
report_checks -path_delay max -group_path_count 10
report_wns -max
report_tns -max

puts "===== HOLD ====="
report_checks -path_delay min -group_path_count 10
report_wns -min
report_tns -min

puts "===== STA COMPLETE ====="
