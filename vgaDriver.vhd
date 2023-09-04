library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity vgaDriver is
  generic (
    CLK_FREQ        : real     := 100.0e6
  );
  port (
    sysClkIn         : in   std_logic;
    sysRstIn         : in   std_logic;
    
    vgaRedIn         : in  std_logic_vector(3 downto 0);
    vgaBlueIn        : in  std_logic_vector(3 downto 0);
    vgaGreenIn       : in  std_logic_vector(3 downto 0);

    vgaRedOut        : out  std_logic_vector(3 downto 0);
    vgaBlueOut       : out  std_logic_vector(3 downto 0);
    vgaGreenOut      : out  std_logic_vector(3 downto 0);
    vSyncPulseOut    : out  std_logic;
    hSyncPulseOut    : out  std_logic);
end entity vgaDriver;

--bp-va-sp-fp
--
--
--
architecture rtl of vgaDriver is 
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

  signal   enVgaR                  : std_logic;
  signal   pixelClkEn              : std_logic;
 
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
  
  function log2Fn (x : positive) return natural is
    variable i : natural;
   begin
      i := 0;  
      while (2**i < x) and i < 31 loop
         i := i + 1;
      end loop;
      return i;
   end function;

  signal  vSyncCntrR    : unsigned (log2Fn (HORIZONTAL_WHOLE_LINE) -1 downto 0);
  signal  hSyncCntrR    : unsigned (log2Fn (VERTICAL_WHOLE_LINE) -1 downto 0);
  signal  vSyncPulseR   : std_logic;
  signal  hSyncPulseR   : std_logic;
  signal  displayEnR    : std_logic;
  signal  xPixelCntrR   : unsigned(log2Fn(HORIZONTAL_VISIBLE_AREA)-1 downto 0);
  signal  yPixelCntrR   : unsigned(log2Fn(VERTICAL_VISIBLE_AREA)-1 downto 0);

  signal  vgaRedR      : std_logic_vector(3 downto 0);
  signal  vgaBlueR     : std_logic_vector(3 downto 0);
  signal  vgaGreenR    : std_logic_vector(3 downto 0);
  signal  displayCntrR : unsigned(3 downto 0);
  signal  vertialSyncCntEn : std_logic;

  constant MAX_H_SYNC_ON :natural := H_B_P + H_V_A + H_F_P-1;
  constant MAX_V_SYNC_ON :natural := V_B_P + V_V_A + V_F_P-1;
  -- signal sixtyHz : std_logic;

begin
  --vgaRedOut     <= vgaRedR;
  --vgaBlueOut    <= vgaBlueR;
  --vgaGreenOut   <= vgaGreenR;
   vgaRedOut     <= vgaRedIn   when displayEnR = '1' else X"0";
   vgaBlueOut    <= vgaBlueIn  when displayEnR = '1' else X"0";
   vgaGreenOut   <= vgaGreenIn when displayEnR = '1' else X"0";
   vSyncPulseOut <= vSyncPulseR;
   hSyncPulseOut <= hSyncPulseR;

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

  -- get60HzClk : entity work.pulseGen(rtl)
  --   generic map(
  --     FREQUENCY_REQ   => integer(1.0e6),
  --     CLK_FREQ        => CLK_FREQ,
  --     SAMPLING_RATE   => 1)
  --   port map (
  --     sysClkIn        => sysClkIn,
  --     sysRstIn        => sysRstIn,
  --     enCntrIn        => '1',
  --     pulseOut        => sixtyHz);

  hSyncCntrProc : process(sysClkIn)
  begin
    if( rising_edge(sysClkIn)) then
      if(sysRstIn /= '1') then
        hSyncCntrR <= (others => '0');
        -- vertialSyncCntEn <= '0';
       -- hSyncPulseR <= '0';
      else
        if(pixelClkEn = '1') then
          -- vertialSyncCntEn <= '0';
          if(hSyncCntrR = to_unsigned(H_W_L -1, hSyncCntrR'length)) then
            hSyncCntrR <= (others => '0');
--            vertialSyncCntEn <= '1';  -- this creates a clk cycle delay in Vcount
          else 
            hSyncCntrR <= hSyncCntrR +1;
           -- if(hSyncCntrR < (to_unsigned(MAX_H_SYNC_ON, hSyncCntrR'length))) then
           --   hSyncPulseR <= '1';
           -- elsif (hSyncCntrR = (to_unsigned(MAX_H_SYNC_ON, hSyncCntrR'length))) or (hSyncCntrR < (to_unsigned(H_W_L, hSyncCntrR'length))) then
           --   hSyncPulseR <= '0';
           -- end if;
          end if;
        end if;
      end if;
    end if;
  end process hSyncCntrProc;

  hSyncPulseR <= '1' when (hSyncCntrR <= MAX_H_SYNC_ON-1) else '0';

--0  47          687         703          799
-------------------------------      799    -0------------     
--      |            |          |            | BP
--BP_48 48  DA_640  688  FP_16 704---SP_96-800 


--  0       95 96------------------------799--0 
--  |---SP--|                             |                              |
                                             ---------
 --hSyncPulseR <= '0' when (hSyncCntrR = MAX_H_SYNC_ON) and
                         --(hSyncCntrR < H_W_L-1) else '1';

  -- hSyncPulseProc : process(sysClkIn)
  -- begin
  --   if( rising_edge(sysClkIn)) then
  --     if(sysRstIn /= '1') then
  --       hSyncPulseR <= '0';
  --     else
  --       if(pixelClkEn = '1') then
  --         if(hSyncCntrR < (to_unsigned(MAX_H_SYNC_ON, hSyncCntrR'length))) then
  --         --  hSyncPulseR <= '1';
  --         else 
  --         --  hSyncPulseR <= '0';
  --         end if;
  --       end if;
  --     end if;
  --   end if;
  -- end process hSyncPulseProc;

  vertialSyncCntEn <= '1' when (hSyncCntrR = to_unsigned(H_W_L -1, hSyncCntrR'length)) else '0';

  vSyncCntrProc : process(sysClkIn)
  begin
    if( rising_edge(sysClkIn)) then
      if(sysRstIn /= '1') then
        vSyncCntrR <= (others => '0' );
      elsif(pixelClkEn = '1') then
        if (vertialSyncCntEn = '1') then
          if(vSyncCntrR = to_unsigned(VERTICAL_WHOLE_LINE-1, vSyncCntrR'length)) then
            vSyncCntrR <= (others => '0');
          else 
            vSyncCntrR <= vSyncCntrR +1;
          end if;
        end if;
      end if;
    end if;
  end process vSyncCntrProc;

 --0    32          512        522     524 
--------------------------------       -------------------    
--      |            |          |      |
--BP_33    DA_480       FP_10   --SP_2-- 

vSyncPulseR <= '1' when (hSyncCntrR <= MAX_V_SYNC_ON) else '0';
-- 
--  vSyncPulseProc : process(sysClkIn)
--  begin
--    if( rising_edge(sysClkIn)) then
--      if(sysRstIn /= '1') then
--        vSyncPulseR <= '0';
--      else
--        if (pixelClkEn = '1') then
--            if((vSyncCntrR < to_unsigned(V_B_P + V_V_A + V_F_P -1, vSyncCntrR'length))) then
--              vSyncPulseR <= '1';
--            else 
--              vSyncPulseR <= '0';
--            end if;
--          -- end if;
--        end if;
--      end if;
--    end if;
--  end process vSyncPulseProc;

  vgaDispayProc : process(sysClkIn)
  begin
    if( rising_edge(sysClkIn)) then
      if(sysRstIn /= '1') then
        displayEnR <=  '0';
      elsif (pixelClkEn = '1') then
        if((vSyncCntrR > (to_unsigned(V_B_P, vSyncCntrR'length))) and (vSyncCntrR < to_unsigned(V_B_P + V_V_A, vSyncCntrR'length)) and
           (hSyncCntrR > (to_unsigned(H_B_P, hSyncCntrR'length))) and (hSyncCntrR < to_unsigned(H_B_P + H_V_A, vSyncCntrR'length))) then
          displayEnR <=  '1'; 
        else 
          displayEnR <=  '0';
        end if;
      end if;
    end if;
  end process vgaDispayProc;

--  vgaRedR   <= X"1" when (displayCntrR  = X"0") else
--               X"1" when (displayCntrR  = X"1") else
--               X"0" when (displayCntrR  = X"2") else
--               X"0" when (displayCntrR  = X"3");
--  vgaBlueR  <= X"1" when (displayCntrR  = X"0") else
--               X"0" when (displayCntrR  = X"1") else
--               X"1" when (displayCntrR  = X"2") else
--               X"0" when (displayCntrR  = X"3");
--  vgaGreenR <= X"1" when (displayCntrR  = X"0") else
--               X"0" when (displayCntrR  = X"1") else
--               X"0" when (displayCntrR  = X"2") else
--               X"1" when (displayCntrR  = X"3");
  pixelTrakrProc : process(sysClkIn)
  begin
    if( rising_edge(sysClkIn)) then
      if(sysRstIn /= '1') then
        xPixelCntrR  <= (others => '0');
        yPixelCntrR  <= (others => '0');
        displayCntrR <= (others => '0');
      elsif(displayEnR = '1') then
        if(yPixelCntrR = to_unsigned(VERTICAL_VISIBLE_AREA-1,yPixelCntrR'length )) then
          yPixelCntrR <= (others => '0');
          displayCntrR<= displayCntrR + 1;
        else 
          yPixelCntrR <= yPixelCntrR +1;
        end if;
        if(xPixelCntrR = to_unsigned(HORIZONTAL_VISIBLE_AREA-1,xPixelCntrR'length)) then
          xPixelCntrR <= (others => '0');
        else 
          xPixelCntrR <= xPixelCntrR +1;
        end if;
      end if;
    end if;
  end process pixelTrakrProc;

end architecture rtl;