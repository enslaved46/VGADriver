library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.colorPackage.all;

entity pxleGen is
  port (
    sysClkIn         : in   std_logic;
    sysRstIn         : in   std_logic;
    xPxleIn          : in   std_logic_vector(9 downto 0);
    yPxleIn          : in   std_logic_vector(9 downto 0);
    enDispalyIn      : in   std_logic;
    -- vSyncPulseIn     : in   std_logic;
    -- hSyncPulseIn     : in   std_logic;
    vgaRedOut        : out  std_logic_vector(3 downto 0);
    vgaBlueOut       : out  std_logic_vector(3 downto 0);
    vgaGreenOut      : out  std_logic_vector(3 downto 0));
    --  vSyncPulseOut    : out  std_logic;
    --  hSyncPulseOut    : out  std_logic);
end entity pxleGen;

architecture rtl of pxleGen is 
  constant HORIZONTAL_SQ : positive := 640/8;
  constant VERTICAL_SQ   : positive := 480/8;

  -- constant WHITE         : std_logic_vector(3 downto 0) := X"0"; -- std_logic_vector(unsigned(0,3),3);
  -- constant BLACK         : std_logic_vector(3 downto 0) := X"F"; -- std_logic_vector(unsigned(15,3),3);

  signal vgaRedR        : std_logic_vector(3 downto 0);
  signal vgaBlueR       : std_logic_vector(3 downto 0);
  signal vgaGreenR      : std_logic_vector(3 downto 0);
  signal   clr          : std_logic ;
  type testPatternColorType is (R, B, G, W, BL, M, C, Y);
  signal testColorR     : testPatternColorType;
  signal colorSelect    : testPatternColorRecType;

  begin

  -- balack i s0
  vgaRedOut   <= colorSelect.r when enDispalyIn = '1' else X"F" ; --BLACK; --WHITE when clr = '0' else BLACK;
  vgaBlueOut  <= colorSelect.b when enDispalyIn = '1' else X"F";  -- -- BLACK; --WHITE when clr = '0' else BLACK;
  vgaGreenOut <= colorSelect.g when enDispalyIn = '1' else X"F"; --BLACK; --WHITE when clr = '0' else BLACK;
  
   -- vSyncPulseOut <= vSyncPulseIn;
   -- hSyncPulseOut <= hSyncPulseIn;
   colorSelect <= WHITE   when (to_integer(unsigned (xPxleIn)) < HORIZONTAL_SQ *1) else
                  YELLOW  when (to_integer(unsigned (xPxleIn)) < HORIZONTAL_SQ *2) else
                  CYAN    when (to_integer(unsigned (xPxleIn)) < HORIZONTAL_SQ *3) else
                  GREEN   when (to_integer(unsigned (xPxleIn)) < HORIZONTAL_SQ *4) else
                  MAGENTA when (to_integer(unsigned (xPxleIn)) < HORIZONTAL_SQ *5) else
                  RED     when (to_integer(unsigned (xPxleIn)) < HORIZONTAL_SQ *6) else
                  BLUE    when (to_integer(unsigned (xPxleIn)) < HORIZONTAL_SQ *7) else
                  BLACK   when (to_integer(unsigned (xPxleIn)) >= HORIZONTAL_SQ *7);
  end architecture rtl;


  --createPatternProc : process (xPxleIn, sysRstIn) --, vSyncPulseIn, hSyncPulseIn)
  --  variable  xPxleVar : integer; -- ( xPxleIn'length -1 downto 0 );
  --  begin
  --    if(sysRstIn /= '1') then
  --      xPxleVar    := 0;
  --      testColorR  <= W;
  --      colorSelect <= WHITE;
  --    else
  --      xPxleVar := to_integer(unsigned (xPxleIn));
  --      case (xPxleVar) is 
  --        when  0 =>  -- white
  --          testColorR  <= W;
  --          colorSelect <= WHITE;
--
--        when 79 => --"0001001111" =>  -- 79 Yellow
--          testColorR  <= Y;
--          colorSelect <= YELLOW;
--
--        when 159 => --"0010011111" =>   -- 159 CYAN
--         testColorR  <= C;
--         colorSelect <= CYAN;
--        
--        when 239 => -- "0011101111" =>  -- 239  Green
--          testColorR  <= G;
--          colorSelect <= GREEN;
--     
--        when 319 => --  "0110011111" =>  -- 319  MAGENTA
--          testColorR  <= M;
--          colorSelect <= MAGENTA;
--
--        when 399 => -- "0110001111" =>  -- 399 --RED
--          testColorR  <= R;
--          colorSelect <= RED;
--        
--        when 479 => --"0111011111" =>   -- 479 Blue
--          testColorR  <= B;
--          colorSelect <= BLUE;
--        
--        when 559 =>-- "1000101111" =>  -- 559 yellow
--          testColorR  <= BL;
--          colorSelect <= BLACK;
--
--        when others =>
--         colorSelect <= colorSelect;
--         testColorR  <= testColorR;
--        end case;
--    end if;
--  end process createPatternProc;

