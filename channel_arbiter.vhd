library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.DigEng.ALL;

entity round_robin_arbiter is
       

    port(
			clock	: in std_ulogic;
			reset_n	: in std_ulogic;
			
			cyc_i	: in std_logic_vector(7 downto 0);
			
			comcyc	: out std_ulogic;
			
			en_gnt_o: out std_ulogic_vector(7 downto 0);
			gnt_o	: out std_logic_vector(7 downto 0)
         );

end entity round_robin_arbiter;

     

architecture rtl of round_robin_arbiter is 

  component convolutional_encoder_decoder
            port (
                InBit: in std_logic;
                clk: in std_logic;
                OutBit1: inout std_logic_vector(1 downto 0);
                Data_Out : out  STD_LOGIC_VECTOR (7 downto 0);
                Data_In : in  std_logic_vector (log2(256)-1 downto 0)
            );
        end component;

	--signal lst_gnt_mas		: std_ulogic_vector(MASTER_MODULE_COUNT - 1 downto 0);
	signal l_gnt_o			: bit_vector(7 downto 0);
	signal l_gnt_nxt		: bit_vector(7 downto 0);
	signal usr_zero			: std_logic_vector(1 downto 0) := (others => '0');	


	signal en_gnt			: std_ulogic_vector(7 downto 0) := (others => '0');
	signal en_gnt_nxt		: std_ulogic_vector(7 downto 0) := (others => '0');
	signal l_cyc_i			: std_ulogic_vector(7 downto 0);
	
	signal l_comcyc			: std_ulogic;
	
	signal beg				: std_logic;
	--signal edge, edge_nxt	: std_ulogic := '0';
	signal lst_mst			: std_ulogic;--last master is granted
	signal lst_mst_nxt		: std_ulogic;
	
	signal n_bit_encoder			: std_logic;
begin
	-- encoder-----------
	
	l_cyc_i <= to_stdulogicvector (cyc_i);
	encoder_logic: process( l_gnt_o )
    begin
		en_gnt_o <= to_stdulogicvector (l_gnt_o);
    end process encoder_logic;
	
	 
	 arbiter_logic : process(reset_n,l_comcyc,en_gnt,cyc_i,l_gnt_o)
	 begin
		 l_gnt_nxt <= l_gnt_o;
		 if(reset_n = '0')then 
			 l_gnt_nxt <= (others => '0');
		 elsif(l_comcyc = '0') then
			 if(cyc_i = (cyc_i'range => '0')) then
				 l_gnt_nxt <= (others => '0');
			 else
			     --if(en_gnt = (en_gnt'range => '0')) then
					--l_gnt_nxt <= (others => '0');
					--l_gnt_nxt(priority_encoding((to_bitvector(cyc_i)))) <= '1'; 
			     --else
					l_gnt_nxt <= (others => '0');	
			     --end if;
				 
			 end if;
		 end if;
		
	  end process arbiter_logic;
	 

	------------------------------------------------------------------
    -- LASMAS state machine.
    ------------------------------------------------------------------
	begin_logic: process( cyc_i, l_comcyc)
    begin  
		if(l_comcyc = '0' and (cyc_i /= (cyc_i'range => '0'))) then
			beg <= '1';
		else
			beg <= '0';
		end if;

    end process begin_logic;

    
    lst_mas_state: process(beg,lst_mst)
    begin

		lst_mst_nxt <= (beg and not(lst_mst));
				
    end process lst_mas_state;
    
    state_reg : process(clock,reset_n)
    begin
		if(reset_n = '0') then
			lst_mst <= '0';
			--edge     <= '0';
		elsif(rising_edge(clock)) then
			lst_mst <= lst_mst_nxt;
			--edge    <= edge_nxt;
		end if;
	end process state_reg;
    
	
	 ------------------------------------------------------------------
    -- COMCYC logic.
    ------------------------------------------------------------------

	
	----------------------------------------------------------------------
	--encoder-------------------------------------------------------------
	----------------------------------------------------------------------
	
	register_syn: process(clock)
	begin
		
		if(rising_edge(clock)) then
			if(reset_n = '0') then
				l_gnt_o <= (others => '0');
				en_gnt <= (others => '0');
			else
				l_gnt_o <= l_gnt_nxt;
			end if;
			
			if(lst_mst = '1') then
				--lst_gnt_mas <= to_stdulogicvector(l_gnt_o);
				en_gnt <= en_gnt_nxt;
				
			end if;
		end if;
	end process register_syn;
	
	make_visiable: process(l_comcyc, l_gnt_o,en_gnt_nxt)
	begin
		comcyc	<= l_comcyc;
		gnt_o	<= to_stdlogicvector(l_gnt_o);
		en_gnt_o<= en_gnt_nxt;
	end process make_visiable;
convolutional: convolutional_encoder_decoder port map(clk =>clock, OutBit1 => usr_zero , Inbit => n_bit_encoder, Data_In =>cyc_i, Data_Out => gnt_o );

end rtl;