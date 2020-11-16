-- This module createsthe driving signals of the VGA protocol with 
-- a vertical refresh rate of 60Hz.  This is done by dividing the
-- system clock in half and using that for the pixel clock.  This in
-- turn drives the vertical sync when the horizontal sync has reached
-- its reset point.
-- the RGB values are feed by the VGA Painter


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;




entity romReader is
    generic (
	    N: integer := 63;
        M: integer := 15
    );
    Port (
        rst   : in  std_logic;
        clk   : in  std_logic;
        bussy : out std_logic;
        addr  : out std_logic_vector(N-1 downto 0);
        data  : out std_logic_vector(M-1 downto 0)
    );

end romReader;

architecture rtl of romReader is
    signal raw: std_logic_vector(199 downto 0) := "11100000111000001110000011100000111000001110000000000000000000000000000011100000111000000000001100011100000000111110000011100000000000000000000000000000111000001110000011100000111000001110000011100000";
    signal dp: std_logic_vector(8 downto 0);
    signal bussySignal: std_logic;
    signal memp: std_logic_vector(4 downto 0);
begin
    process(clk, rst)
    begin
        
        if rst = '1' then
            dp <= (others => '0');
            memp <= (others => '0');
        elsif clk'event and clk = '1' then
            if memp < "11001" then
                bussySignal <= '1';
                dp <= dp + 7;
                memp <= memp + 1;
                data <= "11111111";--raw(conv_integer(dp) downto conv_integer(dp)-7);
                addr <= memp;
            else
                data  <= (others => '0');
                addr  <= (others => '0');
                bussySignal <= '0';
            end if;
        end if;
    end process;

end rtl;
