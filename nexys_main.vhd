library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity nexys_main is
    Port (
        rst	    : in  std_logic;
        clk	    : in  std_logic;
        Hsync   : out std_logic;
        Vsync   : out std_logic;
        vgaR    : out std_logic_vector(3 downto 1);
        vgaG    : out std_logic_vector(3 downto 1);
        vgaB    : out std_logic_vector(3 downto 2);
        PIR     : in  std_logic_vector(3 downto 1);
        PIG     : in  std_logic_vector(3 downto 1);
        PIB     : in  std_logic_vector(3 downto 2);
        PISYNCP : in  std_logic;
        PISYNCF : in  std_logic;
        LED     : out std_logic_vector(7 downto 0);
        SEG     : out std_logic_vector(7 downto 0);
        AN      : out std_logic_vector(3 downto 0)
    );
end nexys_main;

architecture rtl of nexys_main is
	constant N: integer := 8; -- memsize
	constant M: integer := 8; -- wordsize RRRGGGBB for VGA word
	 
    signal vgaclk      : std_logic;
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
        raddr => readRamAddr,
        rdata => readRamDo
    );
    
    ram0 : entity work.ram generic map (N, M) port map(
        CLK   => vgaclk,
        EN    => ram0En,
        WE    => ram0We,
        RST   => rst,
        ADDR  => ram0Addr,
        DI    => ram0Di,
        DO    => ram0Do
    );

    ram1 : entity work.ram generic map (N, M) port map(
        CLK   => vgaclk,
        EN    => ram1En,
        WE    => ram1We,
        RST   => rst,
        ADDR  => ram1Addr,
        DI    => ram1Di,
        DO    => ram1Do
    );
    
    romReader : entity work.piReader generic map (N) port map(
        rst     => rst,
        clk     => vgaclk,
        piR     => PIR,
        piG     => PIG,
        piB     => PIB,
        pisyncF => PISYNCF,
        pisyncP => PISYNCP,
        addr    => writeRamAddr, 
        data    => writeRamDi
    );

    ram0En <= '1';
    ram1En <= '1';

    ram0Addr <= readRamAddr when readRamSel = '0' else writeRamAddr;
    ram1Addr <= readRamAddr when readRamSel = '1' else writeRamAddr;
    
    ram0Do <= readRamDo       when readRamSel = '0' else (others => '0');
    ram1Do <= (others => '0') when readRamSel = '1' else readRamDo;

    ram0Di <= (others => '0') when readRamSel = '0' else writeRamDi;
    ram1Di <= writeRamDi      when readRamSel = '1' else (others => '0');

    ram0We <= not readRamSel;
    ram1We <= readRamSel;

    proc_name: process(vgaclk, rst)
    begin
        if rst = '1' then
            readRamSel <= '0';
            lastSyncFstatus <= '0';
        elsif vgaclk'event and vgaclk = '1' then
            if PISYNCF = '0' and lastSyncFstatus = '1' then
                lastSyncFstatus <= '0';
                readRamSel <= not readRamSel;
            elsif PISYNCF = '1' and lastSyncFstatus = '0' then
                lastSyncFstatus <= '1';
            end if;
        end if;
    end process proc_name;

    SEG <= pir & pig & pib;
    AN <= "0000";
    LED(0) <= PISYNCP;
    LED(1) <= PISYNCF;
    LED(2) <= readRamSel;
    LED(7 downto 3) <= (others => '0');
   
end rtl;

