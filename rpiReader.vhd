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




entity piReader is
    generic (
	    N: integer := 5 -- memaddrsize
    );
    Port (
        clk	    : in  std_logic;
        rst	    : in  std_logic;
        piR     : in  std_logic_vector(3 downto 1);
        piG     : in  std_logic_vector(3 downto 1);
        piB     : in  std_logic_vector(3 downto 2);
        pisyncF : in  std_logic;
        pisyncP : in  std_logic;
        addr    : out std_logic_vector(N-1 downto 0);
        data    : out std_logic_vector(7 downto 0)
    );

end piReader;

architecture rtl of piReader is
    signal memp: std_logic_vector(N-1 downto 0);
    signal firstIteration: std_logic;
    constant memLength: std_logic_vector(N-1 downto 0) := "11111111";
    signal lastSyncPstatus: std_logic;
begin
    process(clk, rst)
    begin
        
        if rst = '0' then
            lastSyncPstatus <= '0';
            firstIteration <= '1';
            memp <= (others => '0');
        elsif clk'event and clk = '1' then
            if pisyncF = '0' then
                memp <= (others => '0');
                lastSyncPstatus <= '0';
                addr <= memp;
                data  <= (others => '0');
            elsif memp < memLength then
                if lastSyncPstatus = '1' and pisyncP = '0' then
                    lastSyncPstatus <= '1';
                    if firstIteration = '1' then
                        firstIteration <= '0';
                        memp <= (others => '0');
                    end if;
                    memp <= memp + 1;
                elsif pisyncP = '1' then
                    lastSyncPstatus <= '1';
                end if;
                data <= piR & piG & piB;
                addr <= memp;
            else
                data  <= (others => '0');
                addr  <= (others => '0');
            end if;
        end if;
    end process;
end rtl;
