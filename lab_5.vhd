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
   component Char_ROM
      port  (  character_address : std_logic_vector ( 5 downto 0 );
               font_row          : std_logic_vector ( 2 downto 0 );
               font_col          : std_logic_vector ( 2 downto 0 );
               rom_mux_output    : std_logic
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
   signal internal_clk  : std_logic;

begin

   Clock_Halver : Clk_Div
      port map (  Clk_50Hz => Clk,
                  Clk_25Hz => internal_clk
               );
   vga_synch : VGA_Sync

end Structural;
