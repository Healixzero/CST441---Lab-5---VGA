library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Char_ROM is
   port  (  character_address : in  std_logic_vector ( 5 downto 0 );
            font_row          : in  std_logic_vector ( 2 downto 0 );
            font_col          : in  std_logic_vector ( 2 downto 0 );
            font_mux_output   : out std_logic
         );
end Char_ROM;

architecture Behavioural of Char_ROM is



begin



end Behavioural;
