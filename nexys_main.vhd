library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity nexys_main is
    Port (
        RST	    : in  std_logic;
        CLK	    : in  std_logic;
        Hsync   : out std_logic;
        Vsync   : out std_logic;
        vgaR    : out std_logic_vector(3 downto 1);
        vgaG    : out std_logic_vector(3 downto 1);
        vgaB    : out std_logic_vector(3 downto 2);
        PID     : in  std_logic_vector(7 downto 0);
        PIS     : in  std_logic_vector(1 downto 0);
        testProbe:out std_logic_vector(7 downto 0)
    );
end nexys_main;

architecture rtl of nexys_main is
	constant N: integer := 8; -- memsize
	constant M: integer := 8; -- wordsize RRRGGGBB for VGA word
	 

    signal clk25mhz      : std_logic;
    
    -- vga signals
    signal von         : std_logic;
    signal hc          : std_logic_vector(9 downto 0);
    signal vc          : std_logic_vector(9 downto 0);

    -- ram signals
    signal readRamSel  : std_logic;
    signal readRamAddr : std_logic_vector(N-1 downto 0);
    signal readRamDo   : std_logic_vector(M-1 downto 0);
    signal writeRamAddr: std_logic_vector(N-1 downto 0);
    signal writeRamDi  : std_logic_vector(M-1 downto 0);
    signal writeRamWe  : std_logic;

    -- end of file signal flag
    signal eofSig: std_logic;
    
begin

    clkdiv : entity work.clkdiv port map(
        clkdiv=> clk25mhz,
        clk   => clk,
		rst   => rst
    );

    vgaDriver : entity work.vgaDriver port map(
        rst   => rst,
        clk   => clk25mhz,
        Hsync => Hsync,
        Vsync => Vsync,
        von   => von,
        hc    => hc,
        vc    => vc
    );

    vgaPainter : entity work.vgaPainter generic map (N) port map(
        rst   => rst,
        clk   => clk25mhz,
        von   => von,
        hc    => hc,
        vc    => vc,
        vgaR  => vgaR,
        vgaG  => vgaG,
        vgaB  => vgaB,
        raddr => readRamAddr,
        rdata => readRamDo
    );

    piReader : entity work.piReader generic map (N) port map(
        CLK	    => clk25mhz,
        RST	    => rst,
        WE      => writeRamWe,
        EOF     => eofSig,
        PID     => PID,
        PIS     => PIS,
        ADDR    => writeRamAddr,
        DATA    => writeRamDi
    );

    ramBank2x1 : entity work.ramBank2x1 generic map (N, M) port map(
        CLK   => clk25mhz,
        EN    => '1',
        RST   => RST,
        SEL   => readRamSel,
        WADDR => writeRamAddr,
        WE    => writeRamWe,
        RADDR => readRamAddr,
        DI    => writeRamDi,
        DO    => readRamDo
    );
    
    ramSelectorProcess : process(clk25mhz, RST)
    begin
        if RST = '1' then
            readRamSel <= '0';
        elsif clk25mhz'event and clk25mhz = '1' then
            if eofSig = '1' then
                readRamSel <= not readRamSel;
            end if;
        end if;
    end process ;

    testProbe <= readRamDo;
end rtl;

