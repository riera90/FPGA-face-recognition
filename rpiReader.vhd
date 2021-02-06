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
	    N: integer := 8 -- memaddrsize
    );
    Port (
        CLK	    : in  std_logic;
        RST	    : in  std_logic;
        WE      : out std_logic;
        EOF     : out std_logic;
        PID     : in  std_logic_vector(N-1 downto 0);
        PIS     : in  std_logic_vector(1 downto 0);
        ADDR    : out std_logic_vector(N-1 downto 0);
        DATA    : out std_logic_vector(N-1 downto 0)
    );

end piReader;

architecture rtl of piReader is
    signal addrSig  : std_logic_vector(N-1 downto 0);
    signal dataSig  : std_logic_vector(N-1 downto 0);
    signal eofSignal: std_logic;
    signal writeSignal: std_logic;
begin
    process(clk, rst)
    begin
        if rst = '1' then

        elsif clk'event and clk = '1' then
            WE <= '0';
            EOF <= '0';
            case PIS is
                when "10" =>
                    addrSig <= PID;
                when "01" =>
                    dataSig <= PID;
                    if writeSignal = '0' then
                        WE <= '1';
                        writeSignal <= '1';
                    end if;
                when "00" =>
                    eofSignal <= '0';
                    writeSignal <= '0';
                when "11" =>
                    if eofSignal = '0' then
                        EOF <= '1';
                        eofSignal <= '1';
                    end if;
                when others =>
            end case;
        end if;
    end process;

    ADDR <= addrSig;
    DATA <= dataSig;
end rtl;
