library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
use std.textio.all;
entity vgaTb is
end  vgaTb;

architecture behav of vgaTb is
  constant tbVgaRedIn    : std_logic_vector(3 downto 0) := x"F";
  constant tbVgaBlueIn   : std_logic_vector(3 downto 0) := x"F";
  constant tbVgaGreenIn  : std_logic_vector(3 downto 0) := x"F";

  signal tbDataRdy       : std_logic := '0';
  signal tbClk           : std_logic := '0';
  signal tbRst           : std_logic := '0';

  signal vga             : std_logic_vector(3 downto 0);
  signal tbVgaRedOut     : std_logic_vector(3 downto 0);
  signal tbVgaBlueOut    : std_logic_vector(3 downto 0);
  signal tbVgaGreenOut   : std_logic_vector(3 downto 0);

  signal tbdisplayEn   : std_logic;
  signal tbVSyncPulse  : std_logic ;
  signal tbHSyncPulse  : std_logic ;
  signal tbXpxle       : std_logic_vector(9 downto 0);
  signal tbYpxle       : std_logic_vector(9 downto 0);
  signal testLed      :  std_logic_vector(1 downto 0);
  signal tboneSecClk : std_logic; 
  -- signal tbVsyncPulseOut : std_logic ;
  -- signal tbHsyncPulseOut   : std_logic ;
begin
 
  UUT : entity work.vgaTopDriver(rtl)
  generic map (
    SYS_CLK_FREQ  => 100.0e6)
  port map(
    sysClkIn      => tbClk,
    sysRstIn      => tbRst,
    usrSelIn      => "11",
    usrClrIn      => "0000",
    testLedOut    => testLed,
   -- displayEnOut  => tbdisplayEn,
    vgaRedOut     => tbVgaRedOut,
    vgaBlueOut    => tbVgaBlueOut,
    vgaGreenOut   => tbVgaGreenOut,
    vSyncPulseOut => tbVsyncPulse,
    hSyncPulseOut => tbHsyncPulse );

  tbClk     <= not tbClk after 5 ns;
  tbRst     <= '0' , '1' after 100 ns;

 -- process
 --   variable l : line;
 --   begin
 --     write (l, String'("Hello world!"));
  --    writeline (output, l);
   --   wait;
  --end process;

   --process (vga)
     --variable l : line;
     --begin
       --write(l, to_integer(unsigned(vga)));
       --writeline (output, l);
   --end process;

  vga <= tbVgaGreenOut when tbdisplayEn = '1' else (others => '0');
  tbget1SecClk : entity work.pulseGen(rtl)
    generic map(
      FREQUENCY_REQ   => integer(1.0),
      CLK_FREQ        => 100.0e6,
      SAMPLING_RATE   => 1)
    port map (
      sysClkIn        => tbClk,
      sysRstIn        => tbRst,
      enCntrIn        => '1',
      pulseOut        => tboneSecClk);
end architecture behav;  
