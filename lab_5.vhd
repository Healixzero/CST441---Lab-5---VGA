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
            v_synch     : out std_logic;   -- T10
				test1       : out std_logic_vector ( 2 downto 0 )
         );
end lab_5;

architecture Structural of lab_5 is 

   -- Clock divider ( 50MHz -> 25MHz )
   component Clk_Div 
      port  (  Clk_50MHz : in  std_logic;
               Clk_25MHz : out std_logic
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
               char_address   : out std_logic_vector ( 6 downto 0 )
            );
   end component;

   -- Ralph's character decoder ( holds all characters, outputs RGB code )
   --    a is the input address for the 8-bits (one line) of each char
   --    spo is the output, 8-bits representing a single line of a char
   component Char_ROM
      port  (  a     : in  std_logic_vector ( 9 downto 0 );
               spo   : out std_logic_vector ( 7 downto 0 )
            );
   end component;

	component MUX_8_1
		port	(	DATA_IN  : in  std_logic_vector ( 7 downto 0 ); 
					SEL_IN   : in  std_logic_vector ( 2 downto 0 );
					DATA_OUT : out std_logic
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
   signal internal_char_addr  : std_logic_vector ( 9 downto 0 );
   signal internal_ROM_MUX    : std_logic;
   signal internal_spo        : std_logic_vector ( 7 downto 0 );

begin

   Clock_Halver : Clk_Div
      port map (  Clk_50MHz => Clk,
                  Clk_25MHz => internal_clk
               );

   vga_synch : VGA_Sync
      port map (  clock_25Mhz    => internal_clk,
                  red            => internal_red,
                  green          => internal_green,
                  blue           => internal_blue,
                  red_out        => red_out,
                  green_out      => green_out,
                  blue_out       => blue_out,
                  horiz_sync_out => h_synch,
                  vert_sync_out  => v_synch,
                  pixel_row      => internal_row,
                  pixel_column   => internal_col
               );

   Message_ROM : Msg_ROM
      port map (  column         => internal_col ( 9 downto 3 ),
                  char_address   => internal_char_addr ( 9 downto 3 )
               );
   
	-- put together the internal_char_add bus
	internal_char_addr ( 2 downto 0 ) <= internal_row ( 2 downto 0 );
	
   -- a is the upper 7 bits from the interal char_addr bus, and the lower 3 bits from the row index
   Character_ROM : Char_ROM
      port map (  a     => internal_char_addr,
                  spo   => internal_spo
               );

   -- 8-to-1 MUX that chooses one of the bits from the output of the ROM
   DEMUX : MUX_8_1
		port map	(	DATA_IN	=> internal_spo,
						SEL_IN	=> internal_col ( 2 downto 0 ),
						DATA_OUT	=> internal_ROM_MUX
					);

   Color_module : Color_Decoder
      port map (  pixel => internal_ROM_MUX,
                  fg    => foreground,
                  bg    => background,
                  red   => internal_red,
                  green => internal_green,
                  blue  => internal_blue
               );
					
   test1 <= internal_col ( 2 downto 0 );

end Structural;
