library ieee;
use ieee.std_logic_1164.all;
package ram is
  constant width:	integer := 8;
  constant depth:	integer := 2**25;
  type ram_type is array (0 to depth-1) of std_logic_vector(width-1 downto 0);
end ram;
