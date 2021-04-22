----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/13/2021 12:47:47 PM
-- Design Name: 
-- Module Name: CodeGolf - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY CodeGolf IS
    PORT (
        clk_in : IN STD_LOGIC; -- system clock
        VGA_red : OUT STD_LOGIC_VECTOR (3 DOWNTO 0); -- VGA outputs
        VGA_green : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        VGA_blue : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        VGA_hsync : OUT STD_LOGIC;
        VGA_vsync : OUT STD_LOGIC;
       -- ADC_CS : OUT STD_LOGIC; -- ADC signals
      --  ADC_SCLK : OUT STD_LOGIC;
      --  ADC_SDATA1 : IN STD_LOGIC;
       -- ADC_SDATA2 : IN STD_LOGIC;
        btnc : IN STD_LOGIC;
        btnu : IN STD_LOGIC;
        btnd : IN STD_LOGIC;
        btnl : IN STD_LOGIC;
        btnr : IN STD_LOGIC
        ); -- button to initiate serve
END CodeGolf;

ARCHITECTURE Behavioral OF CodeGolf IS
    SIGNAL pxl_clk : STD_LOGIC := '0'; -- 25 MHz clock to VGA sync module
    -- internal signals to connect modules
    SIGNAL S_red, S_green, S_blue : STD_LOGIC; --_VECTOR (3 DOWNTO 0);
    SIGNAL S_vsync : STD_LOGIC;
    SIGNAL S_pixel_row, S_pixel_col : STD_LOGIC_VECTOR (10 DOWNTO 0);
    SIGNAL batpos : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    SIGNAL serial_clk, sample_clk : STD_LOGIC;
    SIGNAL adout : STD_LOGIC_VECTOR (11 DOWNTO 0);
    SIGNAL count : STD_LOGIC_VECTOR (9 DOWNTO 0); -- counter to generate ADC clocks

    COMPONENT golf IS
        PORT (
            v_sync : IN STD_LOGIC;
            pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            hit : IN STD_LOGIC;
            hit_up : in std_logic;
            hit_down : in std_logic;
            hit_left : in std_logic;
            hit_right : in std_logic;
            red : OUT STD_LOGIC;
            green : OUT STD_LOGIC;
            blue : OUT STD_LOGIC
        );
    END COMPONENT;
    
   -- component wall is
   --     port (
   --         v_sync : in std_logic
    --    );
   -- end component;
    
    COMPONENT vga_sync IS
        PORT (
            pixel_clk : IN STD_LOGIC;
            red_in    : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            green_in  : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            blue_in   : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            red_out   : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            green_out : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            blue_out  : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            hsync : OUT STD_LOGIC;
            vsync : OUT STD_LOGIC;
            pixel_row : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
            pixel_col : OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT clk_wiz_0 is
        PORT (
            clk_in1  : in std_logic;
            clk_out1 : out std_logic
        );
    END COMPONENT;
BEGIN
    -- Process to generate clock signals
    ckp : PROCESS
    BEGIN
        WAIT UNTIL rising_edge(clk_in);
        count <= count + 1; -- counter to generate ADC timing signals
    END PROCESS;
 --   serial_clk <= NOT count(4); -- 1.5 MHz serial clock for ADC
 --   ADC_SCLK <= serial_clk;
 --   sample_clk <= count(9); -- sampling clock is low for 16 SCLKs
 --   ADC_CS <= sample_clk;
    -- Multiplies ADC output (0-4095) by 5/32 to give bat position (0-640)
    --batpos <= ('0' & adout(11 DOWNTO 3)) + adout(11 DOWNTO 5);
   -- batpos <= ("00" & adout(11 DOWNTO 3)) + adout(11 DOWNTO 4);
    -- 512 + 256 = 768
    
    add_golf : golf
    PORT MAP(--instantiate ball component
        v_sync => S_vsync, 
        pixel_row => S_pixel_row, 
        pixel_col => S_pixel_col,  
        hit => btnc,
        hit_up => btnu,
        hit_down => btnd,
        hit_left => btnl,
        hit_right => btnr,
        red => S_red, 
        green => S_green, 
        blue => S_blue
    );
    
  --  add_wall : wall
  --  port map (
   --     v_sync => S_vsync
   -- );
    
    vga_driver : vga_sync
    PORT MAP(--instantiate vga_sync component
        pixel_clk => pxl_clk, 
        red_in => S_red & "000", 
        green_in => S_green & "000", 
        blue_in => S_blue & "000", 
        red_out => VGA_red, 
        green_out => VGA_green, 
        blue_out => VGA_blue, 
        pixel_row => S_pixel_row, 
        pixel_col => S_pixel_col, 
        hsync => VGA_hsync, 
        vsync => S_vsync
    );
    VGA_vsync <= S_vsync; --connect output vsync
        
    clk_wiz_0_inst : clk_wiz_0
    port map (
      clk_in1 => clk_in,
      clk_out1 => pxl_clk
    );
END Behavioral;
