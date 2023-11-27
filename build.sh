#!/bin/bash

#$14_22=1422 
#(date +"+%m_%d_%H_%M")
mkdir -p 14_22

cp cmdTcl.tcl 14_22

cp -r {src,constraints} 14_22

cd 14_22

vivado -log build_log.log -jou build_jou.jou -mode batch -source cmdTcl.tcl