library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TOP_UART_TX is
    Port ( 
        clk       : in  std_logic;
        button    : in  std_logic;
        tx_output : out std_logic
    );
end TOP_UART_TX;

architecture Behavioral of TOP_UART_TX is

    COMPONENT TX_UART is
        GENERIC (
            CLOCK_FREQ     : INTEGER := 100_000_000; -- 100MHz
            BAUD_RATE      : INTEGER := 115_200;     -- 115200 Bps
            Stop_bit_time  : INTEGER := 2           -- 2 Sec / Stop bit transmit time
        );
        PORT (
            clk            : in std_logic;
            tx_start_in    : in std_logic;          -- Start bit for starting protocol
            tx_data_in     : in std_logic_vector(7 downto 0); -- 8 bit data input
            tx_done_tick   : out std_logic;
            tx_output      : out std_logic          -- 8 bit data transmit wire
        );
    end COMPONENT;

    signal tx_start_in  : std_logic := '0';
    signal tx_data_in   : std_logic_vector(7 downto 0) := (others => '0');
    signal tx_done_tick : std_logic;
    signal counter      : integer range 0 to 4 := 0;  -- Sınırlı aralık
    signal button_prev  : std_logic := '0';           -- Önceki buton durumu

begin

    -- TX_UART modülüne bağlanma
    DUT : TX_UART
        generic map (
            CLOCK_FREQ     => 100_000_000,
            BAUD_RATE      => 115_200,
            Stop_bit_time  => 2
        )
        port map (
            clk            => clk,
            tx_start_in    => tx_start_in,
            tx_data_in     => tx_data_in,
            tx_done_tick   => tx_done_tick,
            tx_output      => tx_output
        );

    -- UART gönderim süreci
    process(clk)
    begin
        if rising_edge(clk) then
            -- Buton yükselen kenarı algılama
            if (button = '1' and button_prev = '0') then
                counter <= counter + 1;  -- Sayaç artırma
                tx_start_in <= '1';

                case counter is
                    when 1 => tx_data_in <= "11111111";
                    when 2 => tx_data_in <= "11110000";
                    when 3 => tx_data_in <= "11001100";
                    when 4 => tx_data_in <= "10101010";
                    when others =>
                        counter <= 0;     -- Sayaç sıfırlama
                        tx_start_in <= '0';
                end case;
            else
                tx_start_in <= '0';
            end if;

            -- Buton durumunu güncelle
            button_prev <= button;
        end if;
    end process;

end Behavioral;
