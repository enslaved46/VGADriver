library ieee;
use IEEE.STD_LOGIC_1164.ALL;

entity ila_probe_wrapper is
  port ( 
    clkIn : in STD_LOGIC;
    probe0In : in STD_LOGIC_VECTOR ( 63 downto 0 )
  );

end ila_probe_wrapper;

architecture rtl of ila_probe_wrapper is

component ila_probe
  port ( 
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 63 downto 0 )
  );
end component ila_probe;

begin

probe : ila_probe
  port map (
    clk => clkIn,
    probe0 => probe0In
  );

end architecture rtl;
