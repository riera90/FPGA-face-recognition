library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity main is
    Port (
        rst	 : in  std_logic;
        clk	 : in  std_logic;
        Hsync: out std_logic;
        Vsync: out std_logic;
        vgaR : out std_logic_vector(3 downto 1);
        vgaG : out std_logic_vector(3 downto 1);
        vgaB : out std_logic_vector(3 downto 2)
    );
end main;

architecture rtl of main is
    signal vgaclk : std_logic;
    signal von    : std_logic;
    signal hc     : std_logic_vector(9 downto 0);
    signal vc     : std_logic_vector(9 downto 0);
    signal ramAddrin: std_logic_vector(4 downto 0);
    signal ramAddroutRom: std_logic_vector(4 downto 0);
    signal ramAddroutVga: std_logic_vector(4 downto 0);
    signal ramDo  : std_logic_vector(7 downto 0);
    signal ramDi  : std_logic_vector(7 downto 0);
    signal ramEn  : std_logic;
    signal ramWe  : std_logic;
    signal readerBussy: std_logic;

begin

    clkdiv : entity work.clkdiv port map(
        clkdiv=> vgaclk,
        clk   => clk
    );

    vgaDriver : entity work.vgaDriver port map(
        rst   => rst,
        clk   => vgaclk,
        Hsync => Hsync,
        Vsync => Vsync,
        von   => von,
        hc    => hc,
        vc    => vc
    );

    vgaPainter : entity work.vgaPainter port map(
        rst   => rst,
        clk   => vgaclk,
        von   => von,
        hc    => hc,
        vc    => vc,
        vgaR  => vgaR,
        vgaG  => vgaG,
        vgaB  => vgaB,
        raddr => ramAddroutVga,
        rdata => ramDo
    );
    
    ram : entity work.ram generic map (5, 8) port map(
        CLK   => vgaclk,
        EN    => ramEn,
        WE    => ramWe,
        RST   => rst,
        ADDR  => ramAddrin,
        DI    => ramDi,
        DO    => ramDo
    );
    
    romReader : entity work.romReader generic map (5, 8) port map(
        rst   => rst,
        clk   => vgaclk,
        bussy => readerBussy,
        addr  => ramAddroutRom,
        data  => ramDi
    );

    ramEn <= '1';
    ramWe <= '0';

    process(vgaclk, rst)
    begin
        if rst = '1' then
            
        elsif vgaclk'event and vgaclk = '1' then
            if readerBussy = '1' then
                ramAddrin <= ramAddroutRom;
                ramWe <= '1';
            else
                ramAddrin <= ramAddroutVga;
            end if;
        end if;
    end process;

end rtl;

