library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- N x M ram module

entity ram is
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
end ram;

architecture rtl of ram is
    type ram_type is array(2**(N-1) downto 0) of std_logic_vector(M-1 downto 0);
    signal ramMem : ram_type;
begin
    process (RST, CLK)
    begin
        if RST = '1' then
            --ramMem <= (others => (others => '0'));
            DO <= (others => '0');
        elsif CLK'event and CLK = '1' then
            if EN = '1' and  ADDR <= 2**(N-1) then
                if WE = '1' then
                    ramMem(conv_integer(ADDR)) <= DI;
                end if;
                DO <= ramMem(conv_integer(ADDR));
            end if;
        end if;
    end process;

end rtl;
