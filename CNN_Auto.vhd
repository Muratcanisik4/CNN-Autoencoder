----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/30/2022 01:40:59 PM
-- Design Name: 
-- Module Name: CNN_Auto - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CNN_Auto is
  Port ( input : in std_logic;
         output : out std_logic
  
  );
end CNN_Auto;

architecture Behavioral of CNN_Auto is
component output_controller is
        port(       
                    enable : OUT std_logic;
                    reqx : OUT std_logic;
                    reqy : OUT std_logic;
                    write: OUT std_logic;
                    x_write : OUT std_logic;
                    y_write : OUT std_logic;
                    available : IN std_logic;
                    clk : IN std_logic;
                    data_in : IN std_ulogic_vector(7 DOWNTO 0);
                    gntx : IN std_logic;
                    gnty : IN std_logic;
                    reset : IN std_logic;
                    header_LSB : IN std_logic
                      
        );
   
        end component;
        
        signal reqx, reqy, write, x_write, y_write, clk, gntx, gnty, reset, header_LSB : std_logic;
        signal data_in : std_ulogic_vector(7 DOWNTO 0);

begin



output_cont: output_controller port map(enable => output, available=> input, reqx=> reqx, reqy=> reqy, write=> write, x_write=> x_write, y_write=> y_write, clk =>clk, data_in => data_in, gntx => gntx, gnty => gnty, header_LSB => header_LSB, reset=>reset);
end Behavioral;
