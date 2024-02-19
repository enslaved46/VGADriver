library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

package colorPackage is 

  --type colorPaterrn_t is array(0  to 7) of std_logic_vector( downto 0);
  constant COLOR_RESLN : positive := 4; 
  subtype colorIntensityValue is std_logic_vector(COLOR_RESLN - 1 downto 0);
 -- type colorChooseType is (RED, BLUE, GREEN, WHITE, BLACK, MAGENTA, CYAN, YELLOW);
  
  type testPatternColorRecType is record
    r : colorIntensityValue;
    g : colorIntensityValue;
    b : colorIntensityValue;
  end record;

  constant BLACK   : testPatternColorRecType:= ("0000", "0000","0000");
  constant BLUE    : testPatternColorRecType:= ("0000", "0000","1111");
  constant GREEN   : testPatternColorRecType:= ("0000", "1111","0000");
  constant CYAN    : testPatternColorRecType:= ("0000", "1111","1111");
  constant RED     : testPatternColorRecType:= ("1111", "0000","0000");
  constant MAGENTA : testPatternColorRecType:= ("1111", "0000","1111");
  constant YELLOW  : testPatternColorRecType:= ("1111", "1111","0000");
  constant WHITE   : testPatternColorRecType:= ("1111", "1111","1111");

end package;

package body colorPackage is
end package body colorPackage;
