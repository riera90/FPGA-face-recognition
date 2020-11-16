--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:44:06 11/16/2020
-- Design Name:   
-- Module Name:   C:/code/FPGA-face-recognition/testbench.vhd
-- Project Name:  FPGA-face-recognition
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: main
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
 
ENTITY testbench IS
END testbench;
 
ARCHITECTURE behavior OF testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT main
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         Hsync : OUT  std_logic;
         Vsync : OUT  std_logic;
         vgaR : OUT  std_logic_vector(3 downto 1);
         vgaG : OUT  std_logic_vector(3 downto 1);
         vgaB : OUT  std_logic_vector(3 downto 2)
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal Hsync : std_logic;
   signal Vsync : std_logic;
   signal vgaR : std_logic_vector(3 downto 1);
   signal vgaG : std_logic_vector(3 downto 1);
   signal vgaB : std_logic_vector(3 downto 2);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: main PORT MAP (
          rst => rst,
          clk => clk,
          Hsync => Hsync,
          Vsync => Vsync,
          vgaR => vgaR,
          vgaG => vgaG,
          vgaB => vgaB
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
      wait for 20 ns;	
		rst <= '1';
      wait for clk_period;
		rst <= '0';
      -- insert stimulus here 

      wait;
   end process;

END;
