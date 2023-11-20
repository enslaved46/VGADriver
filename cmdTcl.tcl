exec mkdir -p  vivadoRun
#xec cd vivadoRun

create_project -f vivadoRun/vivProj -part xc7a100tcsg324-1
read_vhdl src/pulseGen.vhd
read_vhdl src/vgaSync.vhd
read_vhdl src/pxleGen.vhd
read_vhdl src/vgaTopDriver.vhd

#read_vhdl xilinx_ip/ila_probe/synth/ila_probe.vhd
#read_vhdl src/ila_probe/ila_probe_stub.vhdl
#read_vhdl src/ila_probe/ila_probe_stub.vhdl
#read_vhdl src/ila_probe_wrapper.vhd

# read constraints
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

# read constraints
#read_xdc  constraints/ilaConstraints65536.xdc
#update_compile_order -fileset sources_1


#read xci file
#import_ip xilinx_ip/ila_probe/ila_probe.xci

opt_design
#write_debug_probes filename.ltx
# Place Design
place_design

# Create Checkpoints and logs
report_clocks -file all_clocks.log
report_clocks utilization -file clock_utilization.log
report_utilization -file degin_utilzation.log 
write_checkpoint vivadoRun/vgaDriver_place.dcp -force

#Route Design
route_design
report_clock_interaction -file clock_interaction.log
report_cdc -details -file cdc_report.log
report_timing_summary -file timing_summary_post_route.log  -report_unconstrained -verbose -datasheet
check_timing -verbose -file check_timing.log

write_checkpoint vivadoRun/vgaDriver_route.dcp -force

# Write the bitstream
write_bitstream -force -file vivadoRun/vgaDriver.bit

#clean up
#exec mv vivado_*.*.* vivadoRun
#exec vivPorj.* ./vivadoRun
