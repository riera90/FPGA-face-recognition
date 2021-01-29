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
        LED     : out std_logic_vector(7 downto 0);
        SEG     : out std_logic_vector(7 downto 0);
        AN      : out std_logic_vector(3 downto 0);
        CLKOUT  : out std_logic
    );
end nexys_main;

architecture rtl of nexys_main is
	constant N: integer := 8; -- memsize
	constant M: integer := 8; -- wordsize RRRGGGBB for VGA word
	 
    signal clk25mhz      : std_logic;
    signal von         : std_logic;
    signal hc          : std_logic_vector(9 downto 0);
    signal vc          : std_logic_vector(9 downto 0);

    signal ram0Addr    : std_logic_vector(N-1 downto 0);
    signal ram0Do      : std_logic_vector(M-1 downto 0);
    signal ram0Di      : std_logic_vector(M-1 downto 0);
    signal ram0En      : std_logic;
    signal ram0We      : std_logic;

    signal ram1Addr    : std_logic_vector(N-1 downto 0);
    signal ram1Do      : std_logic_vector(M-1 downto 0);
    signal ram1Di      : std_logic_vector(M-1 downto 0);
    signal ram1En      : std_logic;
    signal ram1We      : std_logic;

    signal readRamSel  : std_logic;

    signal readRamAddr : std_logic_vector(N-1 downto 0);
    signal readRamDo   : std_logic_vector(M-1 downto 0);

    signal writeRamAddr: std_logic_vector(N-1 downto 0);
    signal writeRamDi  : std_logic_vector(M-1 downto 0);

    signal lastSyncFstatus: std_logic;
    
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
        rst     => rst,
        clk     => clk25mhz,
        piD     => PID,
        piS     => PIS,
        addr    => writeRamAddr, 
        data    => writeRamDi
    );
   
    
    ram0 : entity work.ram generic map (N, M) port map(
        CLK   => clk25mhz,
        EN    => ram0En,
        WE    => ram0We,
        RST   => rst,
        ADDR  => ram0Addr,
        DI    => ram0Di,
        DO    => ram0Do
    );
    ram1 : entity work.ram generic map (N, M) port map(
        CLK   => clk25mhz,
        EN    => ram1En,
        WE    => ram1We,
        RST   => rst,
        ADDR  => ram1Addr,
        DI    => ram1Di,
        DO    => ram1Do
    );

    


    clkout <= clk25mhz;

    

    --SEG <= writeRamDi;
    AN <= "0000";
    led(7 downto 2) <= (others => '0');
    LED(1 downto 0) <= PIS;
    --LED(2) <= readRamSel;
    --LED(7 downto 3) <= readRamDo(7 downto 3);
    --LED(4 downto 3) <= (others => '1');-- readRamDo;
    SEG <= (others => '1');-- readRamDo;
end rtl;

