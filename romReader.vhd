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
	    N: integer := 5; -- memaddrsize
        M: integer := 8  -- wordsize
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
    signal dp: std_logic_vector(M-1 downto 0);
    signal memp: std_logic_vector(N-1 downto 0);
    signal firstIteration: std_logic;
    signal memPipeline: std_logic_vector(M-1 downto 0);

    signal raw: std_logic_vector(1000 downto 0);
    constant memLength: std_logic_vector(N-1 downto 0) := "10001";
begin
    process(clk, rst)
    begin
        
        if rst = '1' then
			raw (1000 downto 118) <= (others => '1');
			raw (119 downto 0) <= "000011110000111000001101000011000000101100001010000010010000100000000111000001010000010000000011000000100000000100000000";
            bussy <= '0';
            addr  <= (others => '0');
            firstIteration <= '1';
            dp <= (others => '0');
            memp <= (others => '0');
        elsif clk'event and clk = '1' then
            if memp < memLength then
                if firstIteration = '1' then
                    firstIteration <= '0';
                    dp <= (others => '0');
                    memp <= (others => '0');
                end if;
                dp <= dp + 7;
                memp <= memp + 1;
                bussy <= '1';
                data <= raw(conv_integer(dp) + 7 downto conv_integer(dp));
                addr <= memp;

            else
                data  <= (others => '0');
                addr  <= (others => '0');
                bussy <= '0';
            end if;
        end if;
    end process;
end rtl;
