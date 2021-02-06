library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- N x M ram module

entity ramBank2x1 is
    generic (
	    N: integer := 32; -- mem addr size
        M: integer := 8   -- word size
    );
    port (CLK   : in std_logic;
          EN    : in std_logic;
          RST   : in std_logic;
          SEL   : in std_logic; -- ram selector
          WADDR : in std_logic_vector(N-1 downto 0); -- write addr
          WE    : in std_logic; -- write signal for writing ram
          RADDR : in std_logic_vector(N-1 downto 0); -- read addr
          DI    : in std_logic_vector(M-1 downto 0); -- data in
          DO    : out std_logic_vector(M-1 downto 0) -- data out
    );
end ramBank2x1;

architecture rtl of ramBank2x1 is
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
begin

    ram0 : entity work.ram generic map (N, M) port map(
        CLK   => CLK,
        EN    => EN,
        WE    => ram0We,
        RST   => RST,
        ADDR  => ram0Addr,
        DI    => ram0Di,
        DO    => ram0Do
    );

    ram1 : entity work.ram generic map (N, M) port map(
        CLK   => CLK,
        EN    => EN,
        WE    => ram1We,
        RST   => RST,
        ADDR  => ram1Addr,
        DI    => ram1Di,
        DO    => ram1Do
    );

    -- when sel is 1 read from ram0 else write on ram0
    ram0We <= '0' when SEL = '1' else WE;
    ram0Di <= (others => '0') when SEL = '1' else DI;
    ram0addr <= RADDR when SEL = '1' else WADDR;

    -- when sel is 0 read from ram1 else write on ram1
    ram1We <= '0' when SEL = '0' else WE;
    ram1Di <= (others => '0') when SEL = '0' else DI;
    ram1addr <= RADDR when SEL = '0' else WADDR;

    -- Data out selector
    DO <= ram0Do when SEL = '1' else ram1Do;    
end rtl;
