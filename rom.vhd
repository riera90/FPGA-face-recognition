library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- N x M ram module

entity rom is
    generic (
	    N: integer := 32; -- mem addr size
        M: integer := 8   -- word size
    );
    port (CLK  : in std_logic;
          WE   : in std_logic;
          EN   : in std_logic;
          RST  : in std_logic;
          ADDR : in std_logic_vector(N-1 downto 0);
          DI   : in std_logic_vector(M-1 downto 0);
          DO   : out std_logic_vector(M-1 downto 0));
end rom;

architecture rtl of rom is
begin
    process (RST, CLK)
    begin
        if RST = '1' then
            DO <= (others => '0');
        elsif CLK'event and CLK = '1' then
            if EN = '1' then
                if WE = '1' then
                    DO <= (others => '0');
                elsif  addr(7 downto 4) = "0000" or addr(7 downto 4) = "1111" or addr(3 downto 0) = "1111" then -- or addr(3 downto 0) = "0000" then 
                    DO <= (others => '1');
                else 
                    DO <= (others => '0');
                end if;
            end if;
        end if;
    end process;
end rtl;
