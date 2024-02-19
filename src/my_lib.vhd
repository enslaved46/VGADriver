library ieee;
        use ieee.std_logic_1164.all;
        use ieee.numeric_std.all;

package my_lib is
    function log2Fn(x    :    positive) return natural;
    procedure DFF(signal clkIn : in std_logic;
                  signal rstIn : in  std_logic ;
                  signal dIn   : in std_logic;
                  signal dOut  : out std_logic);
  end package my_lib;

  package body my_lib is
    procedure DFF(signal clkIn : in std_logic;
                  signal rstIn : in std_logic;
                  signal dIn   : in std_logic;
                  signal dOut  : out std_logic) is
    variable temp : std_logic;
    begin
      if rising_edge(clkIn) then
        if(rstIn /= '1') then
          temp := '0';
        else
          temp := dIn;
        end if;
        dOut <= temp;
      end if;
    end procedure DFF;

    function log2Fn (x : positive) return natural is
      variable i : natural;
    begin
      i := 0;
      while (2**i < x) and i < 31 loop
        i := i + 1;
      end loop;
      return i;
    end function log2Fn;

 end package body my_lib;
