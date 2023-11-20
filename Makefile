# _*_MakeFile -*-
#target: dependencies
#	action

GHDL   := ghdl
FLAGS  := "--std=08"
DEVICE := ARTRIX7
SIM_DIR:= simDir
BUILD_DIR = batchRun
src=\
	src/ila_probe/sim/ila_probe.vhd \
        xilinx_ip/ila_probe/ila_probe_stub.vhdl \
	src/ila_probe_wrapper.vhd \
	src/pulseGen.vhd \
	src/vgaSync.vhd \
	src/pxleGen.vhd \
        src/vgaTopDriver.vhd \
    
tb=\
	tb/vgaTb.vhd \
	xilinx_ip/ila_probe/sim/ila_probe.vhd \

.PHONY: default
default: help


.PHONY: help cmp run clean

help:
	@echo
	@echo "-------VGA DRIVER MAKEFILE--------------------"
	@echo "------- cm    : Compile simulation Files ----------"
	@echo "------- cr    : Compile and Run Sim ---------------"
	@echo "------- rs    : Run Simulation --------------------"
	@echo "------- cs    : Delete Sim Dir --------------------"
	@echo "------- cb    : Delete Build Dir ------------------"
	@echo "------- clean : Delete all the run Dirs -----------"

all: clean cm rs

clean : cs cb

cr: cm run

cm:
	@mkdir -p $(SIM_DIR)
	#@cp *.vhd $(SIM_DIR)
	@$(GHDL) -a  --workdir=$(SIM_DIR) --work=work $(FLAGS) $(src) $(tb)
	@$(GHDL) -e  --workdir=$(SIM_DIR) $(FLAGS) vgaTb

rs:
	$(GHDL) -r $ --workdir=$(SIM_DIR) $(FLAGS) vgaTb --wave=wave.ghw --stop-time=100ms
	mv wave.ghw $(SIM_DIR)

cs :
	rm -rf $(SIM_DIR)

cb:
	rm -rf $(BUILD_DIR)
