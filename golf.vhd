--Program based on modifications from the Lab6 program 'pong'

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity golf is
    port (
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
end golf;

architecture Behavioral of golf is
    constant ball_size : integer := 8;
    constant wall_width : integer := 5;
    constant ball_speed : std_logic_vector (10 downto 0) := conv_std_logic_vector (6, 11);
    signal ball_on : std_logic;
    signal wall_on : std_logic;
    signal game_on : std_logic := '1'; --ball is not in hole, ball in hole, set to 0
    --current ball position, initialized to center of screen for now
    signal ball_x : std_logic_vector(10 downto 0) := conv_std_logic_vector(400, 11);
    signal ball_y : std_logic_vector(10 downto 0) := conv_std_logic_vector(300, 11);

    signal ball_x_motion, ball_y_motion : std_logic_vector(10 downto 0) := conv_std_logic_vector(0, 11);


begin
    red <= NOT wall_on;
    green <= NOT ball_on;
    blue <= NOT ball_on;
    
    balldraw : process (ball_x, ball_y, pixel_row, pixel_col) is
        VARIABLE vx, vy : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    begin
        IF pixel_col <= ball_x THEN -- vx = |ball_x - pixel_col|
            vx := ball_x - pixel_col;
        ELSE
            vx := pixel_col - ball_x;
        END IF;
        IF pixel_row <= ball_y THEN -- vy = |ball_y - pixel_row|
            vy := ball_y - pixel_row;
        ELSE
            vy := pixel_row - ball_y;
        END IF;
        IF ((vx * vx) + (vy * vy)) < (ball_size * ball_size) THEN -- test if radial distance < bsize
            ball_on <= game_on;
        ELSE
            ball_on <= '0';
        END IF;
    end process;
    
    walldraw : process (pixel_row, pixel_col) is
        --variable wx, wy : std_logic_vector (10 downto 0);
    begin
        if  (pixel_col >= 100) and (pixel_col <= 700) and
            (pixel_row >= 100) and (pixel_row <= 105) then
            wall_on <= '1';            

        elsif (pixel_col >= 100) and (pixel_col <= 105) and
            (pixel_row >=100) and (pixel_row <= 500) then
            wall_on <= '1';
       
        elsif (pixel_col >= 100) and (pixel_col <= 400) and
            (pixel_row >=500) and (pixel_row <= 505) then
            wall_on <= '1';
       
        elsif (pixel_col >= 400) and (pixel_col <= 405) and
            (pixel_row >=300) and (pixel_row <= 500) then
            wall_on <= '1';
      
        elsif (pixel_col >= 400) and (pixel_col <= 700) and
            (pixel_row >=300) and (pixel_row <= 305) then
            wall_on <= '1';
       
        elsif (pixel_col >= 100) and (pixel_col <= 105) and
            (pixel_row >=100) and (pixel_row <= 500) then
            wall_on <= '1';
        else
            wall_on <= '0';
        end if;       
    end process;
    
    mball : process
    
    begin
        wait until rising_edge(v_sync);
        
        
    end process;
    
  
end behavioral;
