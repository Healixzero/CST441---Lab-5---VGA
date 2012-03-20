library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lab_5 is
   port  (  Clk         : in  std_logic;  -- glck T9
            foreground  : in  std_logic_vector ( 2 downto 0 );
            background  : in  std_logic_vector ( 2 downto 0 );
            red_out     : out std_logic;  -- R_12
            green_out   : out std_logic;  -- T_12
            blue_out    : out std_logic;  -- R_11
            h_synch     : out std_logic;  -- R9
            v_synch     : out std_logic   -- T10
         );
end lab_5;

architecture Structural of lab_5 is 

   -- Clock divider ( 50MHz -> 25MHz )
   component Clk_Div 
      port  (  Clk_50Hz : in  std_logic;
               Clk_25Hz : out std_logic
            );
   end component;

   -- Ralph's vga_sync module
   component VGA_SYNC
      port  (  clock_25Mhz    : in  std_logic;
               red            : in  std_logic;
               green          : in  std_logic;
               blue           : in  std_logic;
               red_out        : out std_logic;
               green_out      : out std_logic;
               blue_out       : out std_logic;
               horiz_sync_out : out std_logic;
               vert_sync_out  : out std_logic;
               pixel_row      : out std_logic_vector ( 9 downto 0 );
               pixel_column   : out std_logic_vector ( 9 downto 0 )
            );
   end component;

   -- message ROM ( holds characters to be printed )
   component Msg_ROM
      port  (  column         : in  std_logic_vector ( 6 downto 0 );
               char_address   : out std_logic_vector ( 5 downto 0 )
            );
   end component;

   -- Ralph's character decoder ( holds all characters, outputs RGB code )
   --    a is the input address for the 8-bits (one line) of each char
   --    spo is the output, 8-bits representing a single line of a char
   component CharROM
      port  (  a     : std_logic_vector ( 9 downto 0 );
               spo   : std_logic_vector ( 7 downto 0 )
            );
   end component;

   -- color decoder ( chooses color for pixel
   component Color_Decoder
      port  (  pixel : in  std_logic;
               fg    : in  std_logic_vector ( 2 downto 0 );
               bg    : in  std_logic_vector ( 2 downto 0 );
               red   : out std_logic;
               green : out std_logic;
               blue  : out std_logic
            );
   end component;

   -- wire declarations
   signal internal_clk        : std_logic;
   signal internal_red        : std_logic;
   signal internal_green      : std_logic;
   signal internal_blue       : std_logic;
   signal internal_row        : std_logic_vector ( 9 downto 0 );
   signal internal_col        : std_logic_vector ( 9 downto 0 );
   signal internal_char_addr  : std_logic_vector ( 6 downto 0 );
   signal internal_ROM_MUX    : std_logic;
   signal internal_spo        : std_logic_vector ( 7 downto 0 );

begin

   Clock_Halver : Clk_Div
      port map (  Clk_50Hz => Clk,
                  Clk_25Hz => internal_clk
               );

   vga_synch : VGA_Sync
      port map (  clock_25Mhz    => internal_clk,
                  red            => internal_red,
                  green          => internal_green,
                  blue           => internal_red,
                  red_out        => red_out,
                  green_out      => green_out,
                  blue_out       => blue_out,
                  horiz_sync_out => h_sync,
                  vert_sync_out  => v_sync,
                  pixel_row      => internal_row,
                  pixel_column   => internal_col
               );

   Message_ROM : Msg_ROM
      port map (  column         => internal_col ( 9 downto 3 ),
                  char_address   => internal_char_addr
               );
   
   -- a is the upper 7 bits from the interal char_addr bus, and the lower 3 bits from the row index
   Character_ROM : Char_ROM
      port map (  a     => ( internal_char_add | internal_row ( 2 downto 0 ) ),
                  spo   => internal_spo;
               );

   -- 8-to-1 MUX that chooses one of the bits from the output of the ROM
   process ( spo, internal_col )
   begin
      case ( internal_col ( 2 downto 0 ) ) is
         when "000" => internal_ROM_MUX <= internal_spo[0];
         when "001" => internal_ROM_MUX <= internal_spo[1];
         when "010" => internal_ROM_MUX <= internal_spo[2];
         when "011" => internal_ROM_MUX <= internal_spo[3];
         when "100" => internal_ROM_MUX <= internal_spo[4];
         when "101" => internal_ROM_MUX <= internal_spo[5];
         when "110" => internal_ROM_MUX <= internal_spo[6];
         when "111" => internal_ROM_MUX <= internal_spo[7];
         when others => internal_ROM_MUX <= '0';
   end process;

   Color_module : Color_Decoder
      port map (  pixel => internal_ROM_MUX,
                  fg    => foreground,
                  bg    => background,
                  red   => internal_red,
                  green => internal_green,
                  blue  => internal_blue
               );
   

end Structural;
