UART_TX---FPGA
UART Transmitter - VHDL Implementation
Overview
This project is a VHDL-based UART (Universal Asynchronous Receiver-Transmitter) transmitter designed to send serial data at a specific baud rate. The design includes both the implementation of the UART transmitter and a corresponding test bench for functional verification.

The transmitter follows the UART protocol, which includes:

1 Start Bit: Marks the beginning of data transmission.
8 Data Bits: The actual payload data.
1 Optional Parity Bit: (Currently not implemented but can be extended).
2 Stop Bits: Marks the end of the transmission.

Features
Customizable Baud Rate: Configure the transmitter for various baud rates.
Stop Bits: The design uses 2 stop bits for synchronization.
Generic Clock Support: Configurable for different FPGA clock frequencies.
Test Bench Included: A detailed test bench validates the transmitter.
Files and Structure
1. Main UART Transmitter (TX_UART)
The TX_UART module implements the UART transmitter logic. It includes:

State machine (TX_IDLE, TX_START, TX_DATA, TX_STOP) for UART operations.
Shift register to send bits serially.
Configurable parameters for clock frequency, baud rate, and stop bit time.
2. Test Bench (tb_TX_UART)
The test bench is designed to simulate and verify the transmitter functionality:

It sends multiple data values sequentially.
The transmitted data is validated against expected timing and output.
How It Works
1. Finite State Machine (FSM)
The transmitter operates in the following states:

TX_IDLE: Waits for a tx_start_in signal to begin transmission.
TX_START: Sends the start bit (0).
TX_DATA: Serially shifts and transmits 8 data bits.
TX_STOP: Sends the stop bits (1).
2. Shift Register Operation
During the TX_DATA state:

Data bits are shifted out one by one, starting from the least significant bit (LSB).
The process is synchronized to the clock and baud rate.

3. Timing Diagram
The following waveform shows the complete transmission of a byte, including start, data, and stop bits:


Simulation and Testing
Running the Simulation
Open the project in Vivado or your preferred VHDL simulator.
Compile both TX_UART and tb_TX_UART.
Run the test bench (tb_TX_UART) to verify the transmitter functionality.
Observe the waveforms in the simulator.
Expected Output
The test bench sends a sequence of bytes (0x51, 0xA3, 0xFF, 0x12) through the UART transmitter. The simulation should match the expected UART protocol waveform:


Configuration Parameters
The TX_UART module is configurable via generic parameters:

Parameter	Description	Default Value
CLOCK_FREQ	Clock frequency of the FPGA	100_000_000 (100 MHz)
BAUD_RATE	Transmission baud rate	115_200 (115200 bps)
Stop_bit_time	Stop bit duration (number of bits)	2
Usage
1. Include in Your Project
Add the TX_UART module to your VHDL project.
Connect the input signals:
clk: System clock.
tx_start_in: Signal to start data transmission.
tx_data_in: 8-bit data to be transmitted.
2. Simulation
Use the test bench (tb_TX_UART) to verify functionality.
Modify tx_data_in and observe the tx_output waveform.
