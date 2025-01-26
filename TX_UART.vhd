library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity TX_UART is
	GENERIC (
				CLOCK_FREQ 		: INTEGER := 100_000_000; -- 100MHz
				BAUD_RATE  		: INTEGER := 115_200; -- 115200 Bps
				Stop_bit_time	: INTEGER := 2 -- 2 Sec / Stop bit transmit time		
	);
	PORT    (
				clk 			: in std_logic;
				tx_start_in		: in std_logic; -- Start bit for starting protocol
				tx_data_in		: in std_logic_vector(7 downto 0); -- 8 bit data input
				tx_done_tick	: out std_logic;
				tx_output		: out std_logic -- 8 bit data transmit wire				
	);
end TX_UART;

architecture Behavioral of TX_UART is

type Tx_states is (TX_IDLE, TX_START, TX_DATA, TX_STOP);
signal state : Tx_states := TX_IDLE;

-- 100_000_000 / 115200 = ≈ 868
constant clock_per_bit 		: integer := CLOCK_FREQ/BAUD_RATE; -- 100_000_000/115200 ≈ 868
constant stop_limit			: integer := clock_per_bit*2;
signal   clock_per_counter	: integer range 0 to clock_per_bit := 0;  --   0-868 counter
signal 	 data_bit_counter   : integer range 0 to 7		       := 0;  --   0-7 bit counter
signal   shifter_reg		: std_logic_vector(7 downto 0) 	   := (others => '0');

begin
	process(clk)
		begin
			if (rising_edge(clk)) then		


				case state is	
----------------------------------------------------------------------------------------------------				
					when TX_IDLE => 					
							tx_output 	 <= '1';
							tx_done_tick <= '0';
							data_bit_counter <= 0;
							
							if (tx_start_in = '1') then
								state 		<= TX_START;
								tx_output   <= '0';
								shifter_reg <= tx_data_in;
								
							end if;
----------------------------------------------------------------------------------------------------											
					when TX_START =>
							if (clock_per_counter = clock_per_bit - 1) then
									state 		<= TX_DATA;
									tx_output 	<= shifter_reg(0);
									shifter_reg <= '0' & shifter_reg(7 downto 1);
									clock_per_counter <= 0;								
							else
								clock_per_counter <= clock_per_counter + 1;
							
							end if;
----------------------------------------------------------------------------------------------------
					when TX_DATA =>	
								if (data_bit_counter = 7) then									
										if (clock_per_counter = clock_per_bit - 1) then
										
												state <= TX_STOP;
												clock_per_counter <= 0;
												data_bit_counter <= 0;
												tx_output <= '1'; --stop bit	
										else
												clock_per_counter <= clock_per_counter + 1;
										end if;								
								else									
										if (clock_per_counter = clock_per_bit -1) then
													
													shifter_reg <= '0' & shifter_reg(7 downto 1);
													tx_output 	<= shifter_reg(0);													
													clock_per_counter <= 0;
													data_bit_counter <= data_bit_counter + 1;
										else
											clock_per_counter <= clock_per_counter + 1;
										end if;											
								end if;
----------------------------------------------------------------------------------------------------					
					when TX_STOP => 				
								if (clock_per_counter = stop_limit - 1) then
								
										state 		 <= TX_IDLE;
										tx_done_tick <= '1';
										clock_per_counter <= 0;								
								else
										clock_per_counter <= clock_per_counter + 1;
								end if;
----------------------------------------------------------------------------------------------------								
				end case;		
			end if;	
	end process;
end Behavioral;
