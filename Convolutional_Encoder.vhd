            library IEEE;
            use IEEE.STD_LOGIC_1164.ALL;
            use IEEE.NUMERIC_STD.ALL;
            USE ieee.std_logic_unsigned.all;
            use work.DigEng.ALL; 
        
        --------------------------------------------------
        ----------------------Encoder---------------------
        --------------------------------------------------
        entity convolutional_encoder_decoder is
       
            port (
                InBit: in std_logic;
                clk: in std_logic;
                OutBit1: inout std_logic_vector(1 downto 0);
                
                Data_Out : out  STD_LOGIC_VECTOR (7 downto 0);
                Data_In : in  std_logic_vector (log2(256)-1 downto 0)
            );
        end entity convolutional_encoder_decoder;
        
        architecture behav of convolutional_encoder_decoder is
        
       component Channel_Dist
Port ( data1: in std_logic_vector(7 downto 0); 
       data2: in std_logic_vector(7 downto 0); 
       data3: in std_logic_vector(7 downto 0); 
       data4: in std_logic_vector(7 downto 0);
       clk: in std_logic;
       rst: in std_logic;
       sel: in std_logic_vector(1 downto 0);
       sel_out: in std_logic_vector(1 downto 0);
       en: in std_logic;
       dout1: out std_logic_vector(7 downto 0); 
       dout2: out std_logic_vector(7 downto 0); 
       dout3: out std_logic_vector(7 downto 0); 
       dout4: out std_logic_vector(7 downto 0)
       
       
       
       );

           

 end component;

signal dout1,dout2,dout3,dout4: std_logic_vector (7 downto 0);
signal data1,data2,data3,data4: std_logic_vector (7 downto 0);
  signal rst: std_logic;      
  signal sel: std_logic_vector (1 downto 0);      
  signal  en: std_logic;      
        signal reg1: std_logic := '0';
        signal reg2: std_logic := '0';
        signal reg3: std_logic := '0';
        signal reg4: std_logic := '0';
        
        
        
        	signal output : std_logic_vector(7 downto 0);

        
        begin
        reg1 <= InBit;
        
        
        DECODE_PROC:
            process (Data_In, en, output)
             begin
                output <= (others => '0'); 
                output(to_integer(unsigned(Data_In))) <= '1';
                
                if (En = '1') then
                    Data_Out <= output;
                else
                    Data_Out <=	(others => '0');
                end if;
                end process;
        
        Encoder: process(clk) is
        begin
       
        if clk = '1' and clk'event then
     
        
        OutBit1(1) <= (reg1 xor reg2 xor reg3 xor reg4);
        OutBit1(0) <= (reg1 xor reg2 xor reg4);
        reg4<=reg3;
        reg3<=reg2;
        reg2<=reg1; 
   
        
        end if;
        end process Encoder;
        
        
     


        Channel_Dis: Channel_Dist port map(data1 => data1, data2 => data2, data3 => data3, data4 => data4, dout1 => dout1, dout2 => dout2, dout3 => dout3,dout4 => dout4, en => Inbit, clk => clk, rst => rst, sel=>sel, sel_out=>Outbit1);
        end behav;
