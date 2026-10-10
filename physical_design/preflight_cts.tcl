puts "===== LOAD SKY130 TECHNOLOGY ====="
read_lef /work/physical_design/lef/merged_sky130.lef
read_liberty /pdk/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

puts "===== LOAD SAVED PDN DATABASE ====="
read_db /work/physical_design/sobel_pdn.odb

puts "===== LOAD TIMING CONSTRAINTS ====="
read_sdc /work/constraints/sobel.sdc

puts "===== CHECK CLOCK ====="
puts "Detected clocks: [get_clocks *]"

puts "===== CHECK DESIGN TIMING ====="
report_checks -path_delay max

puts "===== CTS PREFLIGHT FINISHED ====="
exit
