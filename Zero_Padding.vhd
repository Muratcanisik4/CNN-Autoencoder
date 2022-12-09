        LIBRARY ieee; 
        USE ieee.std_logic_1164.all; 
        USE ieee.std_logic_unsigned.all; 
        ENTITY matrix IS 
            PORT ( 
                RESET_F : IN STD_LOGIC; 
                CLK  : IN STD_LOGIC; 
                WRITE   : IN STD_LOGIC; 
                INPUT   : IN STD_LOGIC; 
                ROW     : IN NATURAL RANGE 0 TO 7; 
                COLUMN  : IN NATURAL RANGE 0 TO 7; 
                OUTPUT  : OUT STD_LOGIC
            ); 
        END matrix; 
        ARCHITECTURE rtl OF matrix IS 
            TYPE matrix_type IS ARRAY (7 DOWNTO 0) OF 
                                STD_LOGIC_VECTOR(7 DOWNTO 0); 
            SIGNAL current_matrix : matrix_type; 
            SIGNAL next_matrix    :   matrix_type; 
            
            
        BEGIN 
        
    
        
            OUTPUT <= current_matrix(ROW)(COLUMN); 
            P0 : PROCESS (RESET_F, clk) 
            BEGIN 
                IF (RESET_F = '0') THEN 
                    current_matrix <= (others => (others => '0')); 
                ELSIF rising_edge(clk) THEN 
                    current_matrix <= next_matrix; 
                END IF; 
            END PROCESS P0; 
            P1 : PROCESS (current_matrix, WRITE, INPUT) 
            BEGIN 
                next_matrix <= current_matrix; 
                IF (WRITE = '1') THEN 
                    next_matrix(ROW)(COLUMN) <= INPUT; 
                END IF; 
            END PROCESS P1; 
        END rtl;
