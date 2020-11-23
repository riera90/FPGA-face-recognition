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
	 constant N: integer := 5; -- memsize
	 constant M: integer := 8; -- wordsize RRRGGGBB for VGA word
	 
    signal vgaclk : std_logic;
    signal von    : std_logic;
    signal hc     : std_logic_vector(9 downto 0);
    signal vc     : std_logic_vector(9 downto 0);
    signal ramAddrin: std_logic_vector(N-1 downto 0);
    signal ramAddroutRom: std_logic_vector(N-1 downto 0);
    signal ramAddroutVga: std_logic_vector(N-1 downto 0);
    signal ramDo  : std_logic_vector(M-1 downto 0);
    signal ramDi  : std_logic_vector(M-1 downto 0);
    signal ramEn  : std_logic;
    signal ramWe  : std_logic;
    signal readerBussy: std_logic; 
begin

    clkdiv : entity work.clkdiv port map(
        clkdiv=> vgaclk,
        clk   => clk,
		rst   => rst
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

    vgaPainter : entity work.vgaPainter generic map (N) port map(
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
    
    ram : entity work.ram generic map (N, M) port map(
        CLK   => vgaclk,
        EN    => ramEn,
        WE    => ramWe,
        RST   => rst,
        ADDRIN=> ramAddroutRom,
        ADDROUT=>ramAddroutVga,
        DI    => ramDi,
        DO    => ramDo
    );
    
    romReader : entity work.romReader generic map (N, M) port map(
        rst   => rst,
        clk   => vgaclk,
        bussy => ramWe,
        addr  => ramAddroutRom,
        data  => ramDi
    );

    ramEn <= '1';

end rtl;

