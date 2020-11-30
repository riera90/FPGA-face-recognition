library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity altys_main is
    Port (
        RST	 : in  std_logic;
        CLK	 : in  std_logic;
        hdmi_out_0_TMDS_pin: out std_logic_vector(3 downto 0);
        hdmi_out_0_TMDSB_pin: out std_logic_vector(3 downto 0)
    );
end altys_main;

architecture rtl of altys_main is
    signal VFBC_CMD_DATA: std_logic_vector(31 downto 0) := (others => '1'); --
    signal VFBC_CMD_RESET: std_logic;
    signal VFBC_CMD_CLK: std_logic;
    signal VFBC_CMD_WRITE: std_logic;
    signal VFBC_CMD_END: std_logic;

    signal VFBC_RD_DATA: std_logic_vector(15 downto 0) := (others => '1'); --
    signal VFBC_RD_CLK: std_logic;
    signal VFBC_RD_RESET: std_logic;
    signal VFBC_RD_FLUSH: std_logic;
    signal VFBC_RD_READ: std_logic;
    signal VFBC_RD_END_BURST: std_logic;
begin
    hdmi_out : entity work.hdmi_out port map(
		locked_i => '0',
        PXLCLK_I => CLK,
        PXLCLK_2X_I => CLK,
        PXLCLK_10X_I => '0',

        TMDS => hdmi_out_0_TMDS_pin,
        TMDSB => hdmi_out_0_TMDSB_pin,

        VFBC_CMD_CLK => VFBC_CMD_CLK,
        VFBC_CMD_IDLE => '0',
        VFBC_CMD_RESET => VFBC_CMD_RESET,
        VFBC_CMD_DATA => VFBC_CMD_DATA,
        VFBC_CMD_WRITE => VFBC_CMD_WRITE,
        VFBC_CMD_END => VFBC_CMD_END,
        VFBC_CMD_FULL => '0',
        VFBC_CMD_ALMOST_FULL => '0',

        VFBC_RD_CLK => VFBC_RD_CLK,
        VFBC_RD_RESET => VFBC_RD_RESET,
        VFBC_RD_FLUSH => VFBC_RD_FLUSH,
        VFBC_RD_READ => VFBC_RD_READ,
        VFBC_RD_END_BURST => VFBC_RD_END_BURST,
        VFBC_RD_DATA => VFBC_RD_DATA,
        VFBC_RD_EMPTY => '0',
        VFBC_RD_ALMOST_EMPTY => '0'
    );

end rtl;

