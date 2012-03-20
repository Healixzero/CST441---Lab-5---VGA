--  University: 	Oregon Institute of Technology
--  Class:	CST 441
--  Lab: 	Lab 4 
--  Project:	Video 
---------------------------------------------------------------------------    
--  This file defines the Character Rom for the video lab
---------------------------------------------------------------------------    
--  Date:	08.25.2001
--  Ver.:	1.0
--
--  Author:	Ralph Carestia
-----------------------------------------------------------------------------
LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;
LIBRARY lpm;
USE lpm.lpm_components.ALL;

ENTITY Char_ROM IS
	PORT(	character_address		: IN	STD_LOGIC_VECTOR(5 DOWNTO 0);
			font_row, font_col		: IN 	STD_LOGIC_VECTOR(2 DOWNTO 0);
			rom_mux_output			: OUT	STD_LOGIC);
END Char_ROM;

ARCHITECTURE a OF Char_ROM IS
	SIGNAL	rom_data			: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL	rom_address			: STD_LOGIC_VECTOR(8 DOWNTO 0);
BEGIN
				-- Small 8 by 8 Character Generator ROM for Video Display
				-- Each character is eight 8-bits words of pixel data
 char_gen_rom: lpm_rom
      GENERIC MAP ( lpm_widthad => 9,
        lpm_numwords => 512,
        lpm_outdata => "UNREGISTERED",
        lpm_address_control => "UNREGISTERED",
				-- Reads in mif file for character generator font data 
        lpm_file => "tcgrom.mif",
        lpm_width => 8)
      PORT MAP ( address => rom_address, q => rom_data);

rom_address <= character_address & font_row;

				-- Mux to pick off correct rom data bit from 8-bit word
				-- for on screen character generation
rom_mux_output <= rom_data ( (CONV_INTEGER(NOT font_col(2 DOWNTO 0))));

END a;

PACKAGE Char_ROM_PKG IS
	COMPONENT Char_ROM
	END COMPONENT;
END Char_ROM_PKG;

