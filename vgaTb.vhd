library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity vgaTb is
end  vgaTb;

architecture behav of vgaTb is
signal tbDataRdy       : std_logic := '0';
signal tbClk           : std_logic := '0';
signal tbRst           : std_logic := '0';

signal tbVgaRedOut     : std_logic_vector(3 downto 0);
signal tbVgaBlueOut    : std_logic_vector(3 downto 0);
signal tbVgaGreenOut   : std_logic_vector(3 downto 0);

constant tbVgaRedIn      : std_logic_vector(3 downto 0) := x"F";
constant tbVgaBlueIn     : std_logic_vector(3 downto 0) := x"F";
constant tbVgaGreenIn    : std_logic_vector(3 downto 0) := x"F";

signal tbVSyncPulseOut  : std_logic ;
signal tbHSyncPulseOut  : std_logic ;

begin
  UUT : entity work.vgaDriver(rtl)
  generic map (
    CLK_FREQ       => 100.0e6)
  port map(
    sysClkIn        => tbClk,
    sysRstIn        => tbRst,
    
    vgaRedIn       => tbVgaRedIn,
    vgaBlueIn      => tbVgaBlueIn,
    vgaGreenIn     => tbVgaGreenIn,
    vgaRedOut       => tbVgaRedOut ,
    vgaBlueOut      => tbVgaBlueOut,
    vgaGreenOut     => tbVgaGreenOut,
    vSyncPulseOut   => tbVSyncPulseOut ,
    hSyncPulseOut   => tbHSyncPulseOut);

  tbClk     <= not tbClk after 5 ns;
  tbRst     <= '0' , '1' after 100 ns;

end architecture behav;  
