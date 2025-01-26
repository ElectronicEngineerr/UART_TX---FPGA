# UART_TX---FPGA

UART Transmitter Design in VHDL
This repository contains a VHDL implementation of a UART (Universal Asynchronous Receiver Transmitter) transmitter module. The transmitter is designed to send 8-bit serial data using a state machine. Below is an explanation of the states and their functionality.

State Descriptions
1. TX_IDLE
This is the default state where the transmitter remains idle until a start signal (tx_start_in) is received.

Actions:
tx_output <= '1'; → The line is idle (high) to indicate no transmission.
tx_done_tick <= '0'; → Transmission is not complete.
data_bit_counter <= 0; → Bit counter is reset.
Transition:
If tx_start_in = '1', the state transitions to TX_START to begin the transmission process.
shifter_reg <= tx_data_in; → Loads the input data into the shift register.
2. TX_START
In this state, the start bit is transmitted to indicate the beginning of data transmission.

Actions:
The start bit ('0') is sent via tx_output.
The clock_per_counter begins counting to determine the duration of the start bit.
Transition:
If clock_per_counter reaches clock_per_bit - 1 (one bit time has elapsed), the state transitions to TX_DATA.
3. TX_DATA
In this state, the 8 bits of data are transmitted sequentially, one bit at a time.

Actions:
The least significant bit (LSB) of the shift register (shifter_reg(0)) is sent via tx_output.
The shift register is updated to shift out the next bit (shifter_reg <= '0' & shifter_reg(7 downto 1);).
data_bit_counter keeps track of the number of bits transmitted.
Transition:
If all 8 bits (data_bit_counter = 7) are transmitted and clock_per_counter equals clock_per_bit - 1, the state transitions to TX_STOP.
Otherwise, it continues to transmit the remaining bits.
4. TX_STOP
In this state, the stop bit(s) are transmitted to signal the end of the data frame.

Actions:
The line is set to high ('1') for the duration of the stop bit(s).
The clock_per_counter counts the duration of the stop bit(s).
Transition:
If the stop duration (stop_limit) is reached, the state transitions back to TX_IDLE.
tx_done_tick <= '1'; → Indicates the transmission is complete.
State Machine Flow
The transmitter follows this sequence of states during operation:

TX_IDLE → Waits for a start signal (tx_start_in).
TX_START → Sends the start bit.
TX_DATA → Sequentially transmits 8 bits of data.
TX_STOP → Sends the stop bit(s) and completes the transmission.
Key Features
Configurable Baud Rate: The CLOCK_FREQ and BAUD_RATE generics allow you to set the desired transmission rate.
State Machine Implementation: Ensures reliable and sequential data transmission.
Modular Design: Easily integrates with other VHDL modules in your system.
Usage Instructions
Instantiate the UART transmitter in your VHDL design.
Connect the tx_start_in and tx_data_in signals to your data source.
Monitor the tx_done_tick signal to detect when the transmission is complete.
Configure the generics (CLOCK_FREQ, BAUD_RATE, and Stop_bit_time) as needed.
