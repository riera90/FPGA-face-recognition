library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity vgaPainter is
    generic (
	    N: integer := 32
    );
    Port (
        rst  : in  std_logic;
        clk  : in  std_logic;
        von  : in  std_logic;                      -- Tells whether or not its ok to display data
        hc   : in  std_logic_vector(9 downto 0);   -- horizontal counter
        vc   : in  std_logic_vector(9 downto 0);   -- vertical counter
        rdata: in  std_logic_vector(7 downto 0);   -- ram data
        raddr: out std_logic_vector(N-1 downto 0); -- ram addr 
        vgaR : out std_logic_vector(3 downto 1);
        vgaG : out std_logic_vector(3 downto 1);
        vgaB : out std_logic_vector(3 downto 2)
);
end vgaPainter;

architecture rtl of vgaPainter is
    signal ip  : std_logic_vector(N-1 downto 0); -- image pointer for ram
    signal ihc : std_logic_vector(5 downto 0); -- image horizontal counter for line
    signal firstPixel: std_logic;
    signal firstRow: std_logic;
    signal rowActive: std_logic;
    signal frameActive: std_logic;
    constant hStart: std_logic_vector(9 downto 0) := "0010110000";	-- Horizontal front porch
    constant vStart: std_logic_vector(9 downto 0) := "0001000000";	-- Vertical front porch
    constant lineWidth: std_logic_vector(5 downto 0) := (others => '1');
    constant imageSize: std_logic_vector(N-1 downto 0) := (others => '1');

begin
    -- the painter
    process(clk, rst)
    begin
        if rst = '1' then
            vgaR <= (others => '0');
            vgaG <= (others => '0');
            vgaB <= (others => '0');
            ip   <= (others => '0');
            ihc  <= (others => '0');
        elsif clk = '1' and clk'EVENT then
            vgaR <= (others => '0');
            vgaG <= (others => '0');
            vgaB <= (others => '0');

            if hc = "0000000000" then -- start of new line
                rowActive <= '1';
                ihc <= (others => '0');
            end if;
            if vc = "0000000000" then -- start of new screen
                frameActive <= '1';
                ip <= (others => '0');
            end if;
            
            if ihc = lineWidth then
                rowActive <= '0';
            end if;
            if ip = imageSize then
                frameActive <= '0';
            end if;

            if von = '1' and frameActive = '1' and rowActive = '1' and hc > hStart and vc > vStart then
                -- go to next pixel in the line
                ip <= ip + 1;
                -- add one to line pixel counter
                ihc <= ihc + 1;

                vgaR <= rdata(7 downto 5);
                vgaG <= rdata(4 downto 2);
                vgaB <= rdata(1 downto 0);
            end if;    
        end if;
    end process;
    raddr <= ip;
end rtl;

