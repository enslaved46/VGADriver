library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.my_lib.all;
entity vgaTopDriver is
  generic (
    SYS_CLK_FREQ : real := 100.0e6
    );
  port(
    sysClkIn      : in  std_logic;
    sysRstIn      : in  std_logic;
    vgaRedIn         : in  std_logic_vector(3 downto 0);
    vgaBlueIn        : in  std_logic_vector(3 downto 0);
    vgaGreenIn       : in  std_logic_vector(3 downto 0);
    usrSelIn      : in  std_logic;
   -- usrClrIn      : in  std_logic_vector(3 downto 0);
    -- synthesis translate_off
    displayEnOut  : out  std_logic;
    -- synthesis translate_on
    testLedOut    : out  std_logic_vector(1 downto 0);
    vgaRedOut     : out  std_logic_vector(3 downto 0);
    vgaBlueOut    : out  std_logic_vector(3 downto 0);
    vgaGreenOut   : out  std_logic_vector(3 downto 0);
    vSyncPulseOut : out  std_logic;
    hSyncPulseOut : out  std_logic);
end entity vgaTopDriver;

architecture rtl of vgaTopDriver is 
 signal displaynEn : std_logic;
 signal xPxle      : std_logic_vector(9 downto 0);
 signal yPxle 	   : std_logic_vector(9 downto 0);
 signal vSyncPulse : std_logic;
 signal hSyncPulse : std_logic;
 signal vgaRed     : std_logic_vector(3 downto 0);
 signal vgaBlue    : std_logic_vector(3 downto 0);
 signal vgaGreen   : std_logic_vector(3 downto 0);
 signal testLedCntrlR : std_logic;
 signal oneSecClk     : std_logic;
begin
--  vSyncPulseOut    <= vSyncPulse;
--  hSyncPulseOut    <= hSyncPulse;

  DFF(sysClkIn, sysRstIn, vSyncPulse, VsyncPulseOut);

  DFF(sysClkIn, sysRstIn, hSyncPulse, HsyncPulseOut);

  -- vgaRedOut   <= "1111" when usrSelIn = "00" else (others => '0'); --vgaRed;
  -- vgaBlueOut  <= "1111" when usrSelIn = "01" else (others => '0'); --vgaBlue;
  -- vgaGreenOut <= "1111" when usrSelIn = "10" else (others => '0'); --vgaGreen;
  
  vgaRedOut     <= vgaRedIn   when (usrSelIn and displaynEn) = '1' else vgaRed  ;--  when displaynEn = '1' else X"0";
  vgaBlueOut    <= vgaBlueIn  when (usrSelIn and displaynEn) = '1' else vgaBlue ;--  when displaynEn = '1' else X"0";
  vgaGreenOut   <= vgaGreenIn when (usrSelIn and displaynEn) = '1' else vgaGreen;--  when displaynEn = '1' else X"0";
  
  testLedOut(0) <= '1' when (testLedCntrlR = '1') else '0';
  testLedOut(1) <= oneSecClk when rising_edge (sysClkIn) ;
  
  -- synthesis translate_off
  displayEnOut <= displaynEn;
  -- synthesis translate_on
  
  testLedOutProc : process (sysClkIn)
  begin
    if(rising_edge(sysClkIn)) then
      if(sysRstIn /= '1') then
         testLedCntrlR <= '0';
        else
          testLedCntrlR <= '1';
        end if;
      end if;
  end process;

  vgaDriverInst : entity work.vgaSync
    generic map (
      CLK_FREQ       => SYS_CLK_FREQ)
    port map (
      sysClkIn       => sysClkIn,
      sysRstIn       => sysRstIn,
      displayEnOut   => displaynEn,
      xPxleOut       => xPxle,
      yPxleOut       => yPxle,
      vSyncPulseOut  => vSyncPulse,
      hSyncPulseOut  => hSyncPulse);

  pxleGenInst : entity work.pxleGen
    port map (
      sysClkIn         => sysClkIn,
      sysRstIn         => sysRstIn,
      xPxleIn          => xPxle,
      yPxleIn          => yPxle,
      enDispalyIn      => displaynEn,
     -- vSyncPulseIn     => vSyncPulse,
     --  hSyncPulseIn     => hSyncPulse,
      vgaRedOut        => vgaRed,
      vgaBlueOut       => vgaBlue,
      vgaGreenOut      => vgaGreen);
     -- vSyncPulseOut    => vSyncPulse,
     -- hSyncPulseOut    => hSyncPulseOut);
 
  get1SecClk : entity work.pulseGen(rtl)
    generic map(
      FREQUENCY_REQ   => integer(1.0),
      CLK_FREQ        => SYS_CLK_FREQ,
      SAMPLING_RATE   => 1)
    port map (
      sysClkIn        => sysClkIn,
      sysRstIn        => sysRstIn,
      enCntrIn        => '1',
      pulseOut        => oneSecClk);

end architecture rtl;
