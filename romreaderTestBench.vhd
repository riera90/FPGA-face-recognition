--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   01:20:23 11/23/2020
-- Design Name:   
-- Module Name:   C:/code/FPGA-face-recognition/romreaderTestBench.vhd
-- Project Name:  FPGA-face-recognition
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: romReader
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
 
ENTITY romreaderTestBench IS
END romreaderTestBench;
 
ARCHITECTURE behavior OF romreaderTestBench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT romReader
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         bussy : OUT  std_logic;
         addr : OUT  std_logic_vector(4 downto 0);
         data : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal bussy : std_logic;
   signal addr : std_logic_vector(4 downto 0);
   signal data : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: romReader PORT MAP (
          rst => rst,
          clk => clk,
          bussy => bussy,
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
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		rst <= '1';
      wait for clk_period*10;
		rst <= '0';

      -- insert stimulus here 

      wait;
   end process;

END;
