library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;




entity piReader is
    generic (
	    N: integer := 16; -- memaddrsize
        M: integer := 16; -- wordsize
        B: integer := 16  -- bus size
    );
    Port (
        CLK	    : in  std_logic;
        RST	    : in  std_logic;
        WE      : out std_logic;
        EOF     : out std_logic;
        PID     : in  std_logic_vector(B-1 downto 0);
        PIS     : in  std_logic_vector(1 downto 0);
        ADDR    : out std_logic_vector(N-1 downto 0);
        DATA    : out std_logic_vector(M-1 downto 0)
    );

end piReader;

architecture rtl of piReader is
    signal addrSig  : std_logic_vector(N-1 downto 0);
    signal dataSig  : std_logic_vector(M-1 downto 0);
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
                    addrSig <= PID(N-1 downto 0);
                when "01" =>
                    dataSig <= PID(M-1 downto 0);
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
