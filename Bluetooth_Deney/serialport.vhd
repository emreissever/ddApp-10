library ieee;
use ieee.std_logic_1164.all;

entity serialport is
   port (
      CLK           :  in std_logic;
      BT_UART_RXD   :  in std_logic;
      BT_UART_TXD   :  out std_logic;          
      LED           :  out std_logic
   );
end entity;

architecture behaviour of serialport is
    -- UART bileşenleri sadece Bluetooth için tanımlanır
    component UART_RX_CTRL
        port (
            UART_RX:    in  STD_LOGIC;
            CLK:        in  STD_LOGIC;
            DATA:       out STD_LOGIC_VECTOR (7 downto 0);
            READ_DATA:  out STD_LOGIC;
            RESET_READ: in  STD_LOGIC
        );
    end component;
    
    -- Bluetooth UART için sinyaller
    signal uart_data_in_bt: std_logic_vector(7 downto 0);
    signal data_available_bt: std_logic;
    signal reset_read_bt: std_logic := '0';

    -- LED sinyali için başlangıç değeri
    signal LED_reg : std_logic := '0';

begin
    -- UART RX bileşeninin Bluetooth için instansı
    inst_UART_RX_CTRL_BT: UART_RX_CTRL
        port map(
          UART_RX => BT_UART_RXD,
          CLK => CLK,
          DATA => uart_data_in_bt,
          READ_DATA => data_available_bt,
          RESET_READ => reset_read_bt
        );

    -- LED çıkışını LED_reg sinyaline bağlayın
    LED <= LED_reg;

    -- Gelen veriyi okuyup LED'i kontrol eden process
    process(CLK)
    begin
      if rising_edge(CLK) then
        if data_available_bt = '1' then
          -- Gelen veriyi kontrol edin
          if uart_data_in_bt = x"31" then  -- ASCII '1'
            LED_reg <= '1';
          elsif uart_data_in_bt = x"30" then  -- ASCII '0'
            LED_reg <= '0';
          end if;
          -- Veriyi işledikten sonra reset_read_bt'yi tetikleyin
          reset_read_bt <= '1';
        else
          reset_read_bt <= '0';
        end if;
      end if;
    end process;
end architecture;
