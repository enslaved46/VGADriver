exec mkdir -p  vivadoRun
#xec cd vivadoRun

create_project -f vivadoRun/vivProj -part xc7a100tcsg324-1
read_vhdl src/pulseGen.vhd
read_vhdl src/vgaDriver.vhd
read_xdc  constraints/constraints.xdc

update_compile_order -fileset sources_1

launch_runs synth_1 -jobs 4
wait_on_run synth_1

open_run synth_1 -name  netlist_1
#create reports
report_timing_summary -file vivadoRun/timing_summary_post_synth.rpt
report_power  -file vivadoRun/power_synth.rpt

#Write Syn Checkpoint
write_checkpoint vivadoRun/vgaDriver_synth.dcp -force

# Place Design
place_design
write_checkpoint vivadoRun/vgaDriver_place.dcp -force

#Route Design
route_design
write_checkpoint vivadoRun/vgaDriver_route.dcp -force

# Write the bitstream
write_bitstream -force -file vivadoRun/vgaDriver.bit

#clean up
#exec mv vivado_*.*.* vivadoRun
#exec vivPorj.* ./vivadoRun
