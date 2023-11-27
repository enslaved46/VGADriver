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
  type testPatternColorType is (R, B, G, W, BL, M, C, Y);
  signal tbScreenColorGen    : testPatternColorType;

  signal combineReceivedSignal  : std_logic_vector(11 downto 0);
begin
 
  UUT : entity work.vgaTopDriver(rtl)
  generic map (
    SYS_CLK_FREQ  => 100.0e6)
  port map(
    sysClkIn      => tbClk,
    sysRstIn      => tbRst,
    usrSelIn      => '0',-- "11",
    vgaRedIn      => "0000",
    vgaBlueIn     => "0000",
    vgaGreenIn    => "0000",
  --  usrClrIn      => "0000",
    testLedOut    => testLed,
    displayEnOut  => tbdisplayEn,
    vgaRedOut     => tbVgaRedOut,
    vgaBlueOut    => tbVgaBlueOut,
    vgaGreenOut   => tbVgaGreenOut,
    vSyncPulseOut => tbVsyncPulse,
    hSyncPulseOut => tbHsyncPulse );

  tbClk     <= not tbClk after 5 ns;
  tbRst     <= '0' , '1' after 100 ns;

  combineReceivedSignal <= tbVgaRedOut & tbVgaBlueOut & tbVgaGreenOut;
  
  tbScreenColorGen <= BL when  combineReceivedSignal = X"000" and tbDisplayEn = '1' else -- tbVgaRedOut = x"0" and  tbVgaBlueOut = x"0" and tbVgaGreenOut = x"0" else
                      R  when  combineReceivedSignal = X"F00" and tbDisplayEn = '1' else -- when tbVgaRedOut = x"1" and  tbVgaBlueOut = x"0" and tbVgaGreenOut = x"0" else 
                      B  when  combineReceivedSignal = X"00F" and tbDisplayEn = '1' else -- when tbVgaRedOut = x"0" and  tbVgaBlueOut = x"0" and tbVgaGreenOut = x"1" else 
                      G  when  combineReceivedSignal = X"0F0" and tbDisplayEn = '1' else -- when tbVgaRedOut = x"0" and  tbVgaBlueOut = x"1" and tbVgaGreenOut = x"0" else 
                      C  when  combineReceivedSignal = X"0FF" and tbDisplayEn = '1' else -- when tbVgaRedOut = x"0" and  tbVgaBlueOut = x"1" and tbVgaGreenOut = x"1" else 
                      M  when  combineReceivedSignal = X"F0F" and tbDisplayEn = '1' else -- when tbVgaRedOut = x"1" and  tbVgaBlueOut = x"0" and tbVgaGreenOut = x"1" else 
                      Y  when  combineReceivedSignal = X"FF0" and tbDisplayEn = '1' else -- when tbVgaRedOut = x"1" and  tbVgaBlueOut = x"1" and tbVgaGreenOut = x"0" else 
                      W  when  combineReceivedSignal = X"FFF" ; -- when tbVgaRedOut = x"1" and  tbVgaBlueOut = x"1" and tbVgaGreenOut = x"0" ;

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

  vga <= tbVgaGreenOut when tbdisplayEn = '1' else x"0";

  --tbget1SecClk : entity work.pulseGen(rtl)
  --  generic map(
  --    FREQUENCY_REQ   => integer(1.0),
  --    CLK_FREQ        => 100.0e6,
  --    SAMPLING_RATE   => 1)
  --  port map (
  --    sysClkIn        => tbClk,
  --    sysRstIn        => tbRst,
  --    enCntrIn        => '1',
  --    pulseOut        => tboneSecClk);
end architecture behav;  
