--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:41:13 12/14/2020
-- Design Name:   
-- Module Name:   C:/code/FPGA-face-recognition/piReaderTestBench.vhd
-- Project Name:  FPGA-face-recognition
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: piReader
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY piReaderTestBench IS
END piReaderTestBench;
 
ARCHITECTURE behavior OF piReaderTestBench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT piReader
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         piR : IN  std_logic_vector(3 downto 1);
         piG : IN  std_logic_vector(3 downto 1);
         piB : IN  std_logic_vector(3 downto 2);
         pisyncF : IN  std_logic;
         pisyncP : IN  std_logic;
         addr : OUT  std_logic_vector(7 downto 0);
         data : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal piR : std_logic_vector(3 downto 1) := (others => '0');
   signal piG : std_logic_vector(3 downto 1) := (others => '0');
   signal piB : std_logic_vector(3 downto 2) := (others => '0');
   signal pisyncF : std_logic := '0';
   signal pisyncP : std_logic := '0';

 	--Outputs
   signal addr : std_logic_vector(7 downto 0);
   signal data : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: piReader PORT MAP (
          clk => clk,
          rst => rst,
          piR => piR,
          piG => piG,
          piB => piB,
          pisyncF => pisyncF,
          pisyncP => pisyncP,
          addr => addr,
          data => data
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;

   syncp_process :process
   begin
		pisyncP <= '0';
		wait for clk_period;
		pisyncP <= '1';
		wait for clk_period;
   end process;
   
   syncf_process :process
   begin
      pisyncF <= '1';
      wait for clk_period*8*8;
      pisyncF <= '0';
      wait for clk_period;
   end process;
   

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      rst <= '1';

      wait for clk_period;

      rst <= '0';

      -- insert stimulus here 

      wait;
   end process;

END;
