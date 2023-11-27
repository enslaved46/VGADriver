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
  vgaRedOut   <= colorSelect.r  when enDispalyIn = '1' else X"F" ; --BLACK; --WHITE when clr = '0' else BLACK;
  vgaBlueOut  <= colorSelect.b  when enDispalyIn = '1' else X"F";  -- -- BLACK; --WHITE when clr = '0' else BLACK;
  vgaGreenOut <= colorSelect.g  when enDispalyIn = '1' else X"F" ; --BLACK; --WHITE when clr = '0' else BLACK;
  
 -- vSyncPulseOut <= vSyncPulseIn;
 -- hSyncPulseOut <= hSyncPulseIn;

createPatternProc : process (xPxleIn, sysRstIn) --, vSyncPulseIn, hSyncPulseIn)
  variable  xPxleVar : integer; -- ( xPxleIn'length -1 downto 0 );
  begin
    if(sysRstIn /= '1') then
     -- vSyncPulse <= '1';
     -- hSyncPulse <= '1';
      testColorR <= W;
      colorSelect <= WHITE;
      xPxleVar := 0;
    --   vgaRedR   <= (others => '0');
    --   vgaGreenR <= (others => '0');
    --   vgaBlueR  <= (others => '0');
    --  clr <= '0';
    else
    --  vgaGreenR  <= (others => '0');
    --  vgaGreenR  <= (others => '0');
    --  vgaBlueR   <= (others => '0');
     xPxleVar := to_integer(unsigned (xPxleIn));
      case (xPxleVar) is 
        when  0 =>  -- white
          --  clr <= '0'; -- 0x00
         testColorR <= W;
         colorSelect <= WHITE;
          -- vgaRedR    <= (others => '1');
          -- vgaGreenR  <= (others => '1');
          -- vgaBlueR   <= (others => '1');

        when 79 => --"0001001111" =>  -- 79 Yellow
          testColorR <= Y;
          colorSelect <= YELLOW;
        -- --  vgaRedR   <= (others => '1');
        --  vgaGreenR <= (others => '1');
        --  vgaBlueR  <= (others => '0');

        when 159 => --"0010011111" =>   -- 159 CYAN
         testColorR <= C;
         colorSelect <= CYAN;
        --  vgaRedR   <= (others => '0');
        --  vgaGreenR <= (others => '1');
        --  vgaBlueR  <= (others => '1');
        
        when 239 => -- "0011101111" =>  -- 239  Green
          testColorR <= G;
          colorSelect <= GREEN;
        --  vgaRedR    <= (others => '0');
        --  vgaGreenR  <= (others => '1');
        --  vgaBlueR   <= (others => '0');
     
        when 319 => --  "0110011111" =>  -- 319  MAGENTA
          testColorR <= M;
          colorSelect <= MAGENTA;
        --  vgaRedR    <= (others => '1');
        --  vgaGreenR  <= (others => '0');
        --  vgaBlueR   <= (others => '1');

        when 399 => -- "0110001111" =>  -- 399 --RED
          testColorR <= R;
          colorSelect <= RED;
        --  vgaRedR    <= (others => '1');
        --  vgaGreenR  <= (others => '0');
        --  vgaBlueR   <= (others => '0');
        
        when 479 => --"0111011111" =>   -- 479 Blue
          testColorR <= B;
          colorSelect <= BLUE;
        --  vgaRedR   <= (others => '0');
        --  vgaGreenR <= (others => '0');
        --  vgaBlueR  <= (others => '1');
        
        when 559 =>-- "1000101111" =>  -- 559 yellow
          testColorR <= BL;
          colorSelect <= BLACK;
        --  vgaRedR   <= (others => '1');
        --  vgaGreenR <= (others => '1');
        --  vgaBlueR  <= (others => '0');
       
       --  when "1001111111" => clr <= '1'; -- 639 white 
        --  vgaGreenR <= (others => '0');

         when others =>
          colorSelect <= colorSelect;
           --  testColorR <= testColorR;
          --  vgaGreenR  <= vgaGreenR;
          --  vgaGreenR  <= vgaGreenR;
          --  vgaBlueR   <= vgaBlueR;
        end case;
    end if;
  end process createPatternProc;
end architecture rtl;
