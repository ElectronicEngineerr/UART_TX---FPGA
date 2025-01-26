UART_TX---FPGA
1. TX_IDLE
This is the default state where the transmitter remains idle until a start signal (tx_start_in) is received.

vhdl
Kopyala
Düzenle
when TX_IDLE => 					
    tx_output 	 <= '1';         -- Line is idle (high state)
    tx_done_tick <= '0';         -- Transmission not complete
    data_bit_counter <= 0;       -- Bit counter reset

    if (tx_start_in = '1') then
        state 		<= TX_START; -- Transition to TX_START
        tx_output   <= '0';     -- Start bit
        shifter_reg <= tx_data_in; -- Load input data to the shift register
    end if;
2. TX_START
In this state, the start bit is transmitted to indicate the beginning of data transmission.

vhdl
Kopyala
Düzenle
when TX_START =>
    if (clock_per_counter = clock_per_bit - 1) then
        state 		<= TX_DATA;              -- Transition to TX_DATA
        tx_output 	<= shifter_reg(0);       -- Send LSB of the data
        shifter_reg <= '0' & shifter_reg(7 downto 1); -- Shift the register
        clock_per_counter <= 0;              -- Reset counter
    else
        clock_per_counter <= clock_per_counter + 1; -- Increment counter
    end if;
3. TX_DATA
In this state, the 8 bits of data are transmitted sequentially, one bit at a time.

vhdl
Kopyala
Düzenle
when TX_DATA =>
    if (data_bit_counter = 7) then
        if (clock_per_counter = clock_per_bit - 1) then
            state <= TX_STOP;                -- Transition to TX_STOP
            clock_per_counter <= 0;          -- Reset counter
            data_bit_counter <= 0;           -- Reset bit counter
            tx_output <= '1';                -- Stop bit
        else
            clock_per_counter <= clock_per_counter + 1; -- Increment counter
        end if;								
    else									
        if (clock_per_counter = clock_per_bit -1) then
            shifter_reg <= '0' & shifter_reg(7 downto 1); -- Shift register
            tx_output 	<= shifter_reg(0);   -- Send current bit
            clock_per_counter <= 0;          -- Reset counter
            data_bit_counter <= data_bit_counter + 1; -- Increment bit counter
        else
            clock_per_counter <= clock_per_counter + 1; -- Increment counter
        end if;											
    end if;
4. TX_STOP
In this state, the stop bit(s) are transmitted to signal the end of the data frame.

vhdl
Kopyala
Düzenle
when TX_STOP => 				
    if (clock_per_counter = stop_limit - 1) then
        state 		 <= TX_IDLE; -- Transition to TX_IDLE
        tx_done_tick <= '1';     -- Indicate transmission complete
        clock_per_counter <= 0;  -- Reset counter
    else
        clock_per_counter <= clock_per_counter + 1; -- Increment counter
    end if;
