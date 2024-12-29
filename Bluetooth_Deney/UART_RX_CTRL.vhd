library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UART_RX_CTRL is
    port (
        UART_RX:    in  STD_LOGIC;
        CLK:        in  STD_LOGIC;
        DATA:       out STD_LOGIC_VECTOR (7 downto 0);
        READ_DATA:  out STD_LOGIC := '0';
        RESET_READ: in  STD_LOGIC
    );
end UART_RX_CTRL;

architecture behavioral of UART_RX_CTRL is

    constant FREQ : integer := 100_000_000;  -- 100MHz Nexys4 CLK
    constant BAUD : integer := 9_600;        -- Bit rate of serial comms

    -- Baud rate için saat bölme faktörü
    constant BAUD_TICK_COUNT : integer := FREQ / BAUD;

    -- Durum makinesi durumları
    type state_type is (IDLE, START_BIT, DATA_BITS, STOP_BIT);
    signal state : state_type := IDLE;

    -- Sayaç ve bit indeksleri
    signal baud_counter : integer range 0 to BAUD_TICK_COUNT - 1 := 0;
    signal bit_index    : integer range 0 to 7 := 0;

    -- Veri depolama
    signal rx_shift_reg : std_logic_vector(7 downto 0) := (others => '0');

    -- Okuma sinyali kontrolü
    signal read_data_reg : std_logic := '0';

begin

    -- READ_DATA çıkışını güncelle
    READ_DATA <= read_data_reg;

    process(CLK)
    begin
        if rising_edge(CLK) then

            -- RESET_READ sinyali ile READ_DATA'yı sıfırla
            if RESET_READ = '1' then
                read_data_reg <= '0';
            end if;

            case state is

                when IDLE =>
                    read_data_reg <= '0';
                    baud_counter <= 0;
                    bit_index <= 0;
                    if UART_RX = '0' then  -- Start bit algılandı
                        state <= START_BIT;
                    end if;

                when START_BIT =>
                    if baud_counter = BAUD_TICK_COUNT / 2 then  -- Orta noktada örnekleme
                        if UART_RX = '0' then
                            baud_counter <= 0;
                            state <= DATA_BITS;
                        else
                            state <= IDLE;  -- Hatalı start bit, tekrar bekle
                        end if;
                    else
                        baud_counter <= baud_counter + 1;
                    end if;

                when DATA_BITS =>
                    if baud_counter = BAUD_TICK_COUNT - 1 then
                        baud_counter <= 0;
                        -- Veri bitini kaydırma registerına al
                        rx_shift_reg(bit_index) <= UART_RX;
                        if bit_index = 7 then
                            bit_index <= 0;
                            state <= STOP_BIT;
                        else
                            bit_index <= bit_index + 1;
                        end if;
                    else
                        baud_counter <= baud_counter + 1;
                    end if;

                when STOP_BIT =>
                    if baud_counter = BAUD_TICK_COUNT - 1 then
                        baud_counter <= 0;
                        if UART_RX = '1' then  -- Geçerli stop bit
                            DATA <= rx_shift_reg;
                            read_data_reg <= '1';
                        end if;
                        state <= IDLE;
                    else
                        baud_counter <= baud_counter + 1;
                    end if;

            end case;

        end if;
    end process;

end behavioral;
