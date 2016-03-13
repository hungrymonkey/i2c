library ieee;
use ieee.std_logic_1164.all;
package ram_mat is
  constant width:	integer := 8;
  constant depth:	integer := 8;
  type ram_type is array (0 to 3686399) of std_logic_vector(width-1 downto 0);
end ram_mat;
