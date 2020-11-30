library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity hdmiDriver is
    Port (
       RST:         in std_logic;
       CLK:         in std_logic;
       HDMIOUTCLKP: out std_logic;
       HDMIOUTCLKN: out std_logic;
       HDMIOUTDP:   out std_logic_vector(2 downto 0);
       HDMIOUTDN:   out std_logic_vector(2 downto 0);
       HDMIOUTSCL:  out std_logic;
       HDMIOUTSDA:  out std_logic
    );
end hdmiDriver;

architecture rtl of hdmiDriver is
    signal dummy: std_logic;
    signal hdmi_data: std_logic_vector(2 downto 0);
begin
    HDMIOUTCLKP <= CLK;
    HDMIOUTCLKN <= not CLK;
    HDMIOUTSCL <= CLK;
    HDMIOUTDP <= hdmi_data;
    HDMIOUTDN <= not hdmi_data;
    
    process (RST, CLK)
    begin
        if RST = '1' then
            hdmi_data <= "100";
            dummy <= '0';
        elsif CLK'event and CLK = '1' then
            dummy <= not dummy;
        end if;
    end process;

    HDMIOUTSDA <= dummy;

end rtl;

