# _*_MakeFile -*-
#target: dependencies
#	action
	
GHDL   := ghdl
FLAGS  := "--std=08"
DEVICE := ARTRIX7
SIM_DIR:= runDir
FILES=\
	pulseGen.vhd \
	vgaDriver.vhd \
	vgaTb.vhd

.PHONY: default
default: help


.PHONY: help cmp run clean 

help:
	@echo
	@echo "-------VGA DRIVER MAKEFILE--------------------"
	@echo "-------cmp : Compile simulation Files DRIVER--"
	@echo "-------run : Run Simulation-------------------"

cmp:
	@mkdir -p $(SIM_DIR)
	#@cp *.vhd $(SIM_DIR)
	@$(GHDL) -a  --workdir=$(SIM_DIR) $(FLAGS) $(FILES)
	@$(GHDL) -e  --workdir=$(SIM_DIR) $(FLAGS) vgaTb 

run:
	$(GHDL) -r $ --workdir=$(SIM_DIR) $(FLAGS) vgaTb --wave=wave.ghw --stop-time=1us

clean : 
	rm-r $(SIM_DIR)
