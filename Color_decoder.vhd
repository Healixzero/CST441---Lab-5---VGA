library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Color_Decoder is
   port  (  pixel : in  std_logic;
	         fg    : in  std_logic_vector ( 2 downto 0 );
				bg    : in  std_logic_vector ( 2 downto 0 );
            red   : out std_logic;
            green : out std_logic;
            blue  : out std_logic
         );
end Color_Decoder;

architecture Behavioural of Color_Decoder is

begin
	process ( pixel )
	begin
      if ( pixel = '1' ) then
         red   <= fg(2);
         blue  <= fg(1);
         green <= fg(0);
      else
         red   <= bg(2);
         blue  <= bg(1);
         green <= bg(0);
      end if;
	end process;

end Behavioural;
