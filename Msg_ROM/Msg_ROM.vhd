library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Msg_ROM is
   port  (  column         : in  std_logic_vector ( 6 downto 0 );
            char_address   : out std_logic_vector ( 5 downto 0 )
         );
end Msg_ROM;

-- prints out "BMH " as its message note the space

architecture Behavioural of Msg_ROM is

   signal char1 : std_logic_vector ( 5 downto 0 ) := "000010"; -- B 02o
   signal char2 : std_logic_vector ( 5 downto 0 ) := "001101"; -- M 15o
   signal char3 : std_logic_vector ( 5 downto 0 ) := "001000"; -- H 10o
   signal char4 : std_logic_vector ( 5 downto 0 ) := "100000"; --   40o

begin

   process ( column )
   begin
      case ( column ( 1 downto 0 ) ) is
         when "00" => char_address <= char1;
         when "01" => char_address <= char2;
         when "10" => char_address <= char3;
         when "11" => char_address <= char4;
			when others => char_address <= "000000";
      end case;
   end process;

end Behavioural;
