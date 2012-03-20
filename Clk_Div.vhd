library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Clk_Div is
   port  (  Clk_50MHz   : in  std_logic;
            Clk_25MHz   : out std_logic
         );
end Clk_Div

architecture Behavioural of Clk_Div is

   variable count       : integer := 0;
   variable count_max   : integer := 1;

   signal   clk_line    : std_logic := '0';

begin

   process ( Clk_50MHz 'event and CLK_50MHz = '1' )   -- rising edge of CLK_50MHz

if ( count < count_max ) then
         clk_line <= clk_line;
      else
         clk_line <= ( not clk_line );
      end if;

   end process;

   Clk_25MHz <= clk_line;

end Behavioural;
