-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2022.2 (lin64) Build 3671981 Fri Oct 14 04:59:54 MDT 2022
-- Date        : Mon Nov  6 19:49:37 2023
-- Host        : droidbot running 64-bit unknown
-- Command     : write_vhdl -force -mode synth_stub
--               /home/crosswind/git_wa/FPGA/ilaProbe/ilaProbe.gen/sources_1/ip/ila_probe/ila_probe_stub.vhdl
-- Design      : ila_probe
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ila_probe is
  Port ( 
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 63 downto 0 )
  );

end ila_probe;

architecture stub of ila_probe is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe0[63:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "ila,Vivado 2022.2";
begin
end;
