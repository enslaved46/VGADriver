library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library std;
  use std.textio.all;

entity pxleGen is
  port (
    sysClkIn         : in   std_logic;
    sysRstIn         : in   std_logic;
    xPxleIn          : in   std_logic_vector(9 downto 0);
   -- yPxleIn          : in   std_logic_vector(9 downto 0);
  --  vSyncPulseIn     : in   std_logic;
  --  hSyncPulseIn     : in   std_logic;
    vgaRedOut        : out  std_logic_vector(3 downto 0);
    vgaBlueOut       : out  std_logic_vector(3 downto 0);
    vgaGreenOut      : out  std_logic_vector(3 downto 0));
  --  vSyncPulseOut    : out  std_logic;
  --  hSyncPulseOut    : out  std_logic);
end entity pxleGen;

architecture rtl of pxleGen is 
  constant HORIZONTAL_SQ : positive := 640/8;
  constant VERTICAL_SQ   : positive := 480/8;
  constant WHITE : std_logic_vector(3 downto 0) := X"0"; -- std_logic_vector(unsigned(0,3),3);
  constant BLACK : std_logic_vector(3 downto 0) := X"F"; -- std_logic_vector(unsigned(15,3),3);

  signal   clr   : std_logic ;
begin
  -- balack i s0
  vgaRedOut   <= WHITE when clr = '0' else BLACK;
  vgaBlueOut  <= WHITE when clr = '0' else BLACK;
  vgaGreenOut <= WHITE when clr = '0' else BLACK;
  
 -- vSyncPulseOut <= vSyncPulseIn;
 -- hSyncPulseOut <= hSyncPulseIn;

createPatternProc : process (xPxleIn, sysRstIn)
  begin
    if(sysRstIn /= '1') then
     -- vSyncPulse <= '1';
     -- hSyncPulse <= '1';
      
      --      vgaRedR    <= (others => '0');
      --     vgadGreenR <= (others => '0');
      --    vgaBlueR   <= (others => '0');
      clr <= '0';
    else
      case (xPxleIn) is 
	      when "0000000000" => clr <= '0'; -- 0x00
	      when "0001001111" => clr <= '1';-- 79 
	      when "0010011111" => clr <= '0';-- 159
	      when "0011101111" => clr <= '1';-- 239       
        when "0110011111" => clr <= '0';-- 319
	      when "0110001111" => clr <= '1';-- 399
	      when "0111011111" => clr <= '0';-- 479
	      when "1000101111" => clr <= '1';-- 559
	      when "1001111111" => clr <= '0';-- 639
	      when others => null;
        end case;
    end if;
  end process createPatternProc;
end architecture rtl;
