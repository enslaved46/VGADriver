library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library std;
  use std.textio.all;

entity vgaSync is
  generic (
    CLK_FREQ        : real     := 100.0e6
  );
  port (
    sysClkIn       : in   std_logic;
    sysRstIn       : in   std_logic;
    displayEnOut   : out  std_logic;
    xPxleOut       : out  std_logic_vector(9 downto 0);
    yPxleOut       : out  std_logic_vector(9 downto 0);
    vSyncPulseOut  : out  std_logic;
    hSyncPulseOut  : out  std_logic);
end entity vgaSync;

--bp-va-sp-fp
architecture rtl of vgaSync is 
  constant HORIZONTAL_WHOLE_LINE   : natural := 800;
  constant HORIZONTAL_BACK_PORCH   : natural := 48;
  constant HORIZONTAL_VISIBLE_AREA : natural := 640;
  constant HORIZONTAL_FRONT_PORCH  : natural := 16;
  constant HORIZONTAL_SYNC_PULSE   : natural := 96;
  
  constant VERTICAL_WHOLE_LINE     : natural := 525;
  constant VERTICAL_BACK_PORCH     : natural := 33;
  constant VERTICAL_VISIBLE_AREA   : natural := 480;
  constant VERTICAL_FRONT_PORCH    : natural := 10;
  constant VERTICAL_SYNC_PULSE     : natural := 2;

  constant DEBUG : boolean := FALSE;

  signal   enVgaR                  : std_logic;
  signal   pixelClkEn, pixelClkEn0, pixelClkEn1              : std_logic;
 
  alias    H_W_L is HORIZONTAL_WHOLE_LINE;
  alias    H_B_P is HORIZONTAL_BACK_PORCH;
  alias    H_V_A is HORIZONTAL_VISIBLE_AREA;
  alias    H_F_P is HORIZONTAL_FRONT_PORCH;
  alias    H_S_P is HORIZONTAL_SYNC_PULSE;
  
  alias    V_W_L is VERTICAL_WHOLE_LINE;
  alias    V_B_P is VERTICAL_BACK_PORCH;
  alias    V_V_A is VERTICAL_VISIBLE_AREA;
  alias    V_F_P is VERTICAL_FRONT_PORCH;
  alias    V_S_P is VERTICAL_SYNC_PULSE;
 
 -----------------------------------
 -- Find number of bits needed
 -----------------------------------
  function log2Fn (x : positive) return natural is
    variable i : natural;
   begin
      i := 0;  
      while (2**i < x) and i < 31 loop
         i := i + 1;
      end loop;
      return i;
   end function;

  signal  vSyncCntrR       : unsigned (log2Fn (H_W_L) -1 downto 0);
  signal  hSyncCntrR       : unsigned (log2Fn (V_W_L) -1 downto 0);
  signal  vSyncPulseR      : std_logic;
  signal  hSyncPulseR      : std_logic;
  signal  displayEnR       : std_logic;
  signal  xPixelCntrR      : unsigned(log2Fn(H_V_A)-1 downto 0);
 -- signal  xPixelCntrR      : unsigned(log2Fn(H_V_A)-1 downto 0);
--  signal  yPixelCntrR      : unsigned(log2Fn(V_V_A)-1 downto 0);
  signal  yPixelCntrR      : unsigned(9 downto 0);

  signal  vgaRedR          : std_logic_vector(3 downto 0);
  signal  vgaBlueR         : std_logic_vector(3 downto 0);
  signal  vgaGreenR        : std_logic_vector(3 downto 0);
  signal  displayCntrR     : unsigned(3 downto 0);
  signal  vSyncCntrEn : std_logic;

  signal ilaProbe : std_logic_vector ( 63 downto 0 );

  constant MAX_H_SYNC_ON   : natural := H_B_P + H_V_A + H_F_P - 1;
  constant MAX_V_SYNC_ON   : natural := V_B_P + V_V_A + V_F_P - 1;

  signal tstCntr       :   unsigned (9 downto 0);

begin
  -- output proc
  vSyncPulseOut <= vSyncPulseR;
  hSyncPulseOut <= hSyncPulseR;
 
  displayEnOut  <= displayEnR;
  xPxleOut <= std_logic_vector(xPixelCntrR);
  yPxleOut <= std_logic_vector(yPixelCntrR);

--  tstCntr <=  tstCntr  + 1  when (rising_edge (sysClkIn) and ((hSyncPulseR and pixelClkEn) = '1')) else (others => '0') when sysRstIn /= '1' or  hSyncPulseR = '0' ;
 
  -- testCntrProc : process(sysClkIn)
  -- begin
  --   if(rising_edge(sysClkIn)) then
  --     if(sysRstIn /= '1')  then
  --       tstCntr <= 0; --(others => '0');
  --     else
  --       if   (hSyncPulseR = '1') then
  --        tstCntr <=  tstCntr  + 1;
  --       else
  --         tstCntr <=  0;
  --       end if;
  --     end if;
  --   end if;
  -- end process testCntrProc;
 
 ---------------------------------------
 -- H Sync Cntr
 -----------------------------------
  hSyncCntrProc : process(sysClkIn)
  begin
    if(rising_edge(sysClkIn)) then
      if(sysRstIn /= '1') then
        hSyncCntrR <= (others => '0');
      else
        if(pixelClkEn = '1') then
          if(hSyncCntrR = to_unsigned(H_W_L - 1, hSyncCntrR'length)) then
            hSyncCntrR <= (others => '0');
          else 
            hSyncCntrR <= hSyncCntrR + 1;
          end if;
        end if;
      end if;
    end if;
  end process hSyncCntrProc;

-- Hsync Timing
--0  47          687         703          799
-------------------------------      799    -0------------     
--      |            |          |            | BP
--BP_48 48  DA_640  688  FP_16 704---SP_96-800 

 ----------------------------------------------------------
 -- Turn on the H SYN Signal until Max Threshold is reached
 ----------------------------------------------------------
 --  hSyncPulseR <= '1' when (hSyncCntrR <= MAX_H_SYNC_ON) else '0' when sysRstIn /= '1' ;
  hSyncPulseProc : process(sysClkIn)
  begin
    if( rising_edge(sysClkIn)) then
      if(sysRstIn /= '1') then
        hSyncPulseR <=  '1' ;
      elsif (hSyncCntrR <= MAX_H_SYNC_ON) then
        hSyncPulseR <=  '1' ;
      else
        hSyncPulseR <=  '0' ;
      end if;
    end if;
  end process hSyncPulseProc;

-- hsync Timing, transformed
--  0       95 96------------------------799--0 
--  |---SP--|                             |                              |
                                             ---------
 -- hSyncPulseR <= '0' when (hSyncCntrR = MAX_H_SYNC_ON) and
                         --(hSyncCntrR < H_W_L-1) else '1';

  ----------------------------------------------------------
  -- Enable Vsync cntr when H Sync Max Cnt is reached
  ----------------------------------------------------------
  vSyncCntrEn <= '1' when (hSyncCntrR = to_unsigned(H_W_L -1, hSyncCntrR'length)) else '0';



  -----------------------------------
  -- V Sync Cntr Process
  -----------------------------------
  vSyncCntrProc : process(sysClkIn)
  begin
    if( rising_edge(sysClkIn)) then
      if(sysRstIn /= '1') then
        vSyncCntrR <= (others => '0' );
      elsif(pixelClkEn = '1') then
        if (vSyncCntrEn = '1') then
          if(vSyncCntrR = to_unsigned(V_W_L - 1, vSyncCntrR'length)) then
            vSyncCntrR <= (others => '0');
          else
            vSyncCntrR <= vSyncCntrR + 1;
          end if;
        end if;
      end if;
    end if;
  end process vSyncCntrProc;

-- Vsync Timing
 --0    32          512        522     524 
--------------------------------       -------------------    
--      |            |          |      |
--BP_33    DA_480       FP_10   --SP_2-- 

  ----------------------------------------------------------
  -- Turn on the V SYNC Signal until Max Threshold is reached
  ----------------------------------------------------------
  -- vSyncPulseR <= '1' when (hSyncCntrR < MAX_V_SYNC_ON) else '0';

  vSyncPulseProc : process(sysClkIn)
  begin
    if( rising_edge(sysClkIn)) then
      if(sysRstIn /= '1') then
        vSyncPulseR <=  '1' ;
      elsif (vSyncCntrR < MAX_V_SYNC_ON) then
        vSyncPulseR <=  '1' ;
      else
        vSyncPulseR <=  '0' ;
      end if;
    end if;
  end process vSyncPulseProc;



  -----------------------------------
  -- track display area in the screen, cycle delay
  -----------------------------------
  displayEnR <=  '1' when ((vSyncCntrR > (to_unsigned(V_B_P - 1, vSyncCntrR'length))) and (vSyncCntrR < to_unsigned(V_B_P + V_V_A - 1 , vSyncCntrR'length)) and 
		           (hSyncCntrR > (to_unsigned(H_B_P - 1, hSyncCntrR'length))) and (hSyncCntrR < to_unsigned(H_B_P + H_V_A - 1 , vSyncCntrR'length))) else 
                 '0';
-- synthesis translate_off
-- synopsys translate_off
--  process(sysRstIn, displayEnR, hSyncPulseR, vSyncPulseR, hSyncCntrR, vSyncCntrR, xPixelCntrR, yPixelCntrR)
  debugGen : if (DEBUG) generate
    -----------------------------------
  -- track display area in the screen, cycle delay
  -----------------------------------
  vgaDispayProc : process(sysClkIn)
  begin
    if( rising_edge(sysClkIn)) then
      if(sysRstIn /= '1') then
        displayEnR <=  '0';
      elsif (pixelClkEn = '1') then
        if((vSyncCntrR > (to_unsigned(V_B_P - 1, vSyncCntrR'length))) and (vSyncCntrR < to_unsigned(V_B_P + V_V_A - 1 , vSyncCntrR'length)) and
           (hSyncCntrR > (to_unsigned(H_B_P - 1, hSyncCntrR'length))) and (hSyncCntrR < to_unsigned(H_B_P + H_V_A - 1 , vSyncCntrR'length))) then
          displayEnR <=  '1'; 
        else 
         displayEnR <=  '0';
        end if;
      end if;
    end if;
  end process vgaDispayProc;

    printPorc : process(hSyncCntrR, vSyncCntrR)
      variable l : line;
      begin
     -- write (l, String'("Hello world!"));v
     -- if(displayEnR = '1') then
     -- write (l, String'("RST IN : "));
     -- write(l, std_logic'image(sysRstIn));
     -- write (l, String'("        "));

     -- write (l, String'("MAX H Sync On: "));
     -- write(l, integer'image(MAX_H_SYNC_ON));
     -- write (l, String'("        "));
      
      write (l, String'("H sync Cntr: "));
      write(l, to_integer(hSyncCntrR));
      write (l, String'("        "));
      
      write (l, String'("H Sync Pulse : "));
      write(l, std_logic'image(hSyncPulseR));
      write (l, String'("        "));

      write (l, String'(" H sync En Tst Cntr : "));
      write(l, to_integer(tstCntr));
     
    --  write (l, String'("V Sync Cnt En : "));
    --  write(l, std_logic'image(vSyncCntrEn));
    --  write (l, String'("        "));


      --write (l, String'("MAX V_Sync On: "));
     -- write(l, integer'image(MAX_V_SYNC_ON));
      --write (l, String'("        "));
     
    --  write(l, String'("V sync Cntr: "));
    --  write(l, to_integer(vSyncCntrR));
    --  write (l, String'("        "));
    --  write(l, String'("V Sync Pulse : "));
    --  write(l, std_logic'image(vSyncPulseR));
    --  write (l, String'("        "));
      
     -- write(l, String'("Display En : "));
     -- write(l, std_logic'image(displayEnR));
     -- write (l, String'("        "));     

    --  write(l, String'("X Pxle : "));
    --  write(l, to_integer(xPixelCntrR));
    --  write (l, String'("        "));
    --  write(l, String'("Y Pxle : "));
    --  write(l, to_integer(yPixelCntrR));
    
      writeline (output, l);
     -- end if;
     -- wait;
    end process printPorc;

-- ila_gen : if (FALSE) generate
--   probeWires : entity work.ila_probe_wrapper
--   port map ( 
--     clkIn => sysClkIn,
--     probe0In => ilaProbe);
--   
--   ilaProbe <= displayEnR &  vSyncPulseR & hSyncPulseR  &
--               std_logic_vector(unsigned(vSyncCntrR)) & std_logic_vector(unsigned(hSyncCntrR)) &
--               std_logic_vector(unsigned(xPixelCntrR)) &  std_logic_vector(unsigned(yPixelCntrR))
--                & hSyncPulseR & vSyncCntrEn & "0000000000000000000";
--  end generate ila_gen;
  end generate debugGen;
-- synopsys translate_on
-- synthesis translate_on
 -----------------------------------
 --
 -----------------------------------
--  pixelTrakrProc : process(sysRstIn, displayEnR, pixelClkEn, xPixelCntrR, yPixelCntrR) 
--   begin
-- --    if( rising_edge(sysClkIn)) then
--       if(sysRstIn /= '1') then
--         xPixelCntrR  <= (others => '0');
--         yPixelCntrR  <= (others => '0');
--         displayCntrR <= (others => '0');
--       elsif(displayEnR = '1' and pixelClkEn = '1') then
--         if(xPixelCntrR = to_unsigned(H_V_A - 1, xPixelCntrR'length)) then
-- 	        xPixelCntrR <= (others => '0');
--           yPixelCntrR <= yPixelCntrR + 1;
--         else
--           xPixelCntrR <= xPixelCntrR + 1;
--         end if;
--         if(yPixelCntrR = to_unsigned(V_V_A - 1, yPixelCntrR'length )) then
--           yPixelCntrR <= (others => '0');
--           --  displayCntrR<= displayCntrR + 1;
--         end if;
--      end if;
-- --    end if;
--   end process pixelTrakrProc;

 get25MhzClk : entity work.pulseGen(rtl)
    generic map(
      FREQUENCY_REQ   => integer(25.0e6),
      CLK_FREQ        => CLK_FREQ,
      SAMPLING_RATE   => 1)
    port map (
      sysClkIn        => sysClkIn,
      sysRstIn        => sysRstIn,
      enCntrIn        => '1',
      pulseOut        => pixelClkEn);

 
  -- get25MhzClk  : process(sysClkIn)
  -- begin
  --   if(rising_edge(sysClkIn)) then
  --     if(sysRstIn /= '1') then
  --       pixelClkEn0 <= '0';
  --       pixelClkEn  <= '0';
  --       pixelClkEn1 <= '0';
  --     else 
  --       pixelClkEn0 <= not pixelClkEn0;
  --       pixelClkEn  <= pixelClkEn0;
-- 
--   --    end if;
--   --   end if;
  -- end process get25MhzClk;



end architecture rtl;
