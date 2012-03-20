library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Color_Decoder is
   port  (  fg    : in  std_logic;
            red   : out std_logic;
            green : out std_logic;
            blue  : out std_logic
         );
end Color_Decoder;

architecture Behavioural of Color_Decoder is

   -- colors are in RGB order
   variable foreground : std_logic_vector ( 2 downto 0 ) := "111";
   variable background : std_logic_vector ( 2 downto 0 ) := "000";

begin
   if ( fg ) then
      red   <= foreground[2];
      blue  <= foreground[1];
      green <= foreground[0];
   else
      red   <= background[2];
      blue  <= background[1];
      green <= background[0];
   end if;

end Behavioural;
