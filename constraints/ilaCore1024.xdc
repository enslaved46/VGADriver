
create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list sysClkIn_IBUF_BUFG]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 8 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {vgaDriverInst/hSyncCntrR[0]} {vgaDriverInst/hSyncCntrR[1]} {vgaDriverInst/hSyncCntrR[2]} {vgaDriverInst/hSyncCntrR[4]} {vgaDriverInst/hSyncCntrR[5]} {vgaDriverInst/hSyncCntrR[6]} {vgaDriverInst/hSyncCntrR[8]} {vgaDriverInst/hSyncCntrR[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 10 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {vgaDriverInst/yPixelCntrR[0]} {vgaDriverInst/yPixelCntrR[1]} {vgaDriverInst/yPixelCntrR[2]} {vgaDriverInst/yPixelCntrR[3]} {vgaDriverInst/yPixelCntrR[4]} {vgaDriverInst/yPixelCntrR[5]} {vgaDriverInst/yPixelCntrR[6]} {vgaDriverInst/yPixelCntrR[7]} {vgaDriverInst/yPixelCntrR[8]} {vgaDriverInst/yPixelCntrR[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 9 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {vgaDriverInst/vSyncCntrR[0]} {vgaDriverInst/vSyncCntrR[1]} {vgaDriverInst/vSyncCntrR[2]} {vgaDriverInst/vSyncCntrR[3]} {vgaDriverInst/vSyncCntrR[4]} {vgaDriverInst/vSyncCntrR[5]} {vgaDriverInst/vSyncCntrR[7]} {vgaDriverInst/vSyncCntrR[8]} {vgaDriverInst/vSyncCntrR[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 10 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {vgaDriverInst/xPixelCntrR[0]} {vgaDriverInst/xPixelCntrR[1]} {vgaDriverInst/xPixelCntrR[2]} {vgaDriverInst/xPixelCntrR[3]} {vgaDriverInst/xPixelCntrR[4]} {vgaDriverInst/xPixelCntrR[5]} {vgaDriverInst/xPixelCntrR[6]} {vgaDriverInst/xPixelCntrR[7]} {vgaDriverInst/xPixelCntrR[8]} {vgaDriverInst/xPixelCntrR[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 10 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {vgaDriverInst/xPxle[0]} {vgaDriverInst/xPxle[1]} {vgaDriverInst/xPxle[2]} {vgaDriverInst/xPxle[3]} {vgaDriverInst/xPxle[4]} {vgaDriverInst/xPxle[5]} {vgaDriverInst/xPxle[6]} {vgaDriverInst/xPxle[7]} {vgaDriverInst/xPxle[8]} {vgaDriverInst/xPxle[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 10 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {vgaDriverInst/yPxle[0]} {vgaDriverInst/yPxle[1]} {vgaDriverInst/yPxle[2]} {vgaDriverInst/yPxle[3]} {vgaDriverInst/yPxle[4]} {vgaDriverInst/yPxle[5]} {vgaDriverInst/yPxle[6]} {vgaDriverInst/yPxle[7]} {vgaDriverInst/yPxle[8]} {vgaDriverInst/yPxle[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list hSyncPulseOut_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list vgaDriverInst/pixelClkEn]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list vSyncPulseOut_OBUF]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets sysClkIn_IBUF_BUFG]
