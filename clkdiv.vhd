library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity clkdiv is
    Port (
        clkdiv: out std_logic;                    -- Clock divider
        clk   : in  std_logic;
        rst   : in  std_logic
    );

end clkdiv;

architecture rtl of clkdiv is
	signal clkdivsig		: std_logic;      
begin
	 clkdiv <= clkdivsig;
    -- Half clock divider 50MHz (inboard clk) -> 25MHz (vga clk)
    process(rst, clk)
    begin
        if rst = '1' then
            clkdivsig <= '0';
        elsif clk = '1' and clk'EVENT then
            clkdivsig <= not clkdivsig;
        end if;
    end process;
end rtl;
