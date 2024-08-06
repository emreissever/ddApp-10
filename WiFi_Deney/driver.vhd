		--------------------------------------------------
-- esp8266_driver - Session setup and sending
--                  packets of data using ESP8266
--
-- Author: Mike Field <hamster@snap.net.nz>
--
-- NOTE: You will need to edit the constants to put
-- your own SSID & password, and the IP address
-- and destination port number
--
-- This also has a watchdog, that resets the state
-- of the design if no state change has occurred 
-- in the last 10 seconds.
------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity esp8266_driver is
    Port ( clk100           : in  STD_LOGIC;
           status_active    : out STD_LOGIC := '0';
           status_wifi_up   : out STD_LOGIC := '0';
           status_connected : out STD_LOGIC := '0';
           status_sending   : out STD_LOGIC := '0';
           status_error     : out STD_LOGIC := '0';
           status_led_1     : out STD_LOGIC := '0';
           status_led_2     : out STD_LOGIC := '0';
           status_led_3     : out STD_LOGIC := '0';
           status_led_4     : out STD_LOGIC := '0';
           payload0         : in  std_logic_vector(7 downto 0) := x"00";
           payload1         : in  std_logic_vector(7 downto 0) := x"00";
           payload2         : in  std_logic_vector(7 downto 0) := x"00";
           payload3         : in  std_logic_vector(7 downto 0) := x"00";
           powerdown        : in  STD_LOGIC;
           wifi_enable      : out STD_LOGIC;
           wifi_rx          : in  STD_LOGIC;
           wifi_tx          : out STD_LOGIC);
end esp8266_driver;

architecture Behavioral of esp8266_driver is
    type a_mem is array(0 to 175) of std_logic_vector(7 downto 0);
    signal memory : a_mem := 
   (
-- Message 0 - chars 0-15 - change mode. 
   x"41",x"54",x"2b",x"43",x"57",x"4d",x"4f",x"44",x"45",x"3d",x"33",x"0d",x"0a",x"FF",x"FF",x"FF", 
--    A     T     +     C     W     M     O     D     E     =     3    \r    \n   EOM (14)
-- Message 1 - char 16-31 - single socket mode
   x"41",x"54",x"2b",x"43",x"49",x"50",x"4d",x"55",x"58",x"3d",x"30",x"0d",x"0a",x"FF",x"FF",x"FF",
--    A     T     +     C     I     P     M     U     X     =     0    \r    \n    EOM  (14)

-- Message 2 - char 32-47 send six characters
   x"41",x"54",x"2b",x"43",x"49",x"50",x"53",x"45",x"4e",x"44",x"3d",x"36",x"0d",x"0a",x"FF",x"FF", 
--    A     T     +     C     I     P     S     E     N     D     =     6    \r    \n  EOM  (15)

-- Message 4 - chars 48-63 - "ping\r\n" 
   x"50",x"49",x"4e",x"47",x"0d",x"0a",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF", 
--    P     I     N     G    \r    \n  EOM (6)
  
-- Message 5 - char 64-79 -  close connection
   x"41",x"54",x"2b",x"43",x"49",x"50",x"43",x"4c",x"4f",x"53",x"45",x"0d",x"0a",x"FF",x"FF",x"FF",
--    A     T     +     C     I     P     C     L     O     S     E    \r    \n  EOM (14)

-- Message 6 - chars 80-127  Connect to WIFI
-- Modem ismi ve Şifresini giriniz! 
   x"41",x"54",x"2b",x"43",x"57",x"4a",x"41",x"50",x"3d",x"22",x"45",x"72",x"6B",x"69",x"6E",x"2D",
   x"45",x"6D",x"72",x"65",x"22",x"2c",x"22",x"39",x"66",x"64",x"36",x"34",x"32",x"31",x"31",x"38",
   x"31",x"61",x"33",x"35",x"62",x"32",x"35",x"22",x"0d",x"0a",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",   
--    A     T     +     C     W     J     A     P     =     "     B     E     T     I     "     ,
--    "     B     b     0     4     0     5     2     0     0     2     "    \r    \n    EOM


-- Message 7 - chars 128-175
-- Serverin IP ve portunu giriniz!
    x"41",x"54",x"2b",x"43",x"49",x"50",x"53",x"54",x"41",x"52",x"54",x"3d",x"22",x"54",x"43",x"50",
    x"22",x"2c",x"22",x"31",x"39",x"32",x"2e",x"31",x"36",x"38",x"2e",x"30",x"2E",x"32",x"36",x"22",
    x"2c",x"31",x"31",x"32",x"35",x"0d",x"0a",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF"); 
--     A     T     +     C     I     P     S     T     A     R     T     =     "     T     C     P
--     "     ,     "     1     9     2     .     1     6     8     .     0     .     2     6     "
--     ,     1     1     2     5    \r    \n

    signal current_char  : unsigned(7 downto 0)  := (others => '0');
    signal delay_counter : unsigned(26 downto 0) := (others => '0');
    signal in_delay      : std_logic             := '0';

    component tx is
        Port ( clk         : in  STD_LOGIC;
               data        : in  STD_LOGIC_VECTOR (7 downto 0);
               data_enable : in  STD_LOGIC;
               busy        : out STD_LOGIC;
               tx_out      : out STD_LOGIC);
    end component;

    component rx is
        Port ( clk         : in  STD_LOGIC;
               data        : out STD_LOGIC_VECTOR (7 downto 0);
               data_enable : out STD_LOGIC;
               rx_in       : in  STD_LOGIC);
    end component;

    signal tx_data        : std_logic_vector(7 downto 0 ) := (others => '0');
    signal tx_busy        : std_logic                     := '0';
    signal tx_data_enable : std_logic                     := '0';

    signal rx_data        : std_logic_vector(7 downto 0 ) := (others => '0');
    signal rx_data_enable : std_logic                     := '0';
    signal sending        : std_logic                     := '0';
    signal state          : std_logic_vector(3 downto 0 ) := (others => '0');
    signal state_last     : std_logic_vector(3 downto 0 ) := (others => '0');
    signal last_rx_chars  : std_logic_vector(10*8-1 downto 0 ) := (others => '0');
    
    signal rx_seeing_ok     : std_logic                     := '0';
    signal rx_seeing_ready  : std_logic                     := '0';
    signal rx_seeing_change : std_logic                     := '0';
    signal rx_seeing_prompt : std_logic                     := '0';
    
    -- Watchdog timer for recovery.
    -- This has to count for the number of clock cycles in 1ms
    signal watchdog_low      : unsigned(16 downto 0) := (others => '0');
    -- This is high for one cycle every millisecond
    signal inc_wd_high       : std_logic := '0';
    -- This has to count to 9,9999, for the 10,000 ms timout
    signal watchdog_high     : unsigned(13 downto 0) := (others => '0');
begin
 
i_tx : tx port map (
       clk         => clk100,
       data        => tx_data,
       data_enable => tx_data_enable,
       busy        => tx_busy,
       tx_out      => wifi_tx);

i_rx : rx  port map (
       clk         => clk100,
       data        => rx_data,
       data_enable => rx_data_enable,
       rx_in       => wifi_rx);

send_chars: process(clk100)
    begin
        if rising_edge(clk100) then
            tx_data_enable <= '0'; -- Default to no character being sent
            if sending = '1' then
                if memory(to_integer(current_char)) = x"FF" then
                    sending <= '0';
                elsif tx_busy ='0' then
                    -- Send the next character
                    if current_char = 48 then
                        tx_data <= payload0;
                    elsif current_char = 49 then
                        tx_data <= payload1;
                    elsif current_char = 50 then
                        tx_data <= payload2;
                    elsif current_char = 51 then
                        tx_data <= payload3;
                    else
                        tx_data        <= memory(to_integer(current_char));
                    end if;
                    tx_data_enable <= '1';
                    current_char   <= current_char + 1;
                end if;
            elsif delay_counter /= 0 then                
                delay_counter <= delay_counter - 1;
            else
                case state is                  
                    when "0000" => 
                        -- Power down the module and delay 
                        status_connected <= '0';
                        status_sending   <= '0';
                        status_active    <= '0';
                        status_wifi_up   <= '0';
                        status_error     <= '0';
                        wifi_enable      <= '0'; 
                        if powerdown = '0' then
                            state <= "0001";
                        end if;
                        delay_counter <= (others => '1');
                    when "0001" => 
                        -- Power up the module and delay 
                        status_active  <= '1';
                        wifi_enable    <= '1'; 
                        delay_counter <= (others => '1');
                        state <= "0010";
                        
                    when "0010" =>
                        -- Power up the module and delay 
                        delay_counter <= (others => '1');
                        state <= "0011";
                        
                    when "0011" =>
                        -- Should be waiting for "ready"
                        if rx_seeing_ready = '1' then                    
                            -- Set wifi mode
                            current_char <= to_unsigned(0,8);
                            sending <= '1'; 
                            state <= "0100";
                            last_rx_chars(4 downto 0) <= (others => '0');
                        end if;                    
                    when "0100" =>
                        -- Should be waiting "OK" or "no change"
                        if rx_seeing_ok = '1' or rx_seeing_change = '1' then                    
                            -- Set to single connection mode
                            current_char  <= to_unsigned(16,8);
                            sending       <= '1'; 
                            state <= "0101";
                            last_rx_chars(4 downto 0) <= (others => '0');
                        end if;
                        
                    when "0101" =>
                        -- Should be waiting "OK" or "no change"
                        if rx_seeing_ok = '1' then                                        
                            -- Connect to the Wifi network
                            current_char  <= to_unsigned(80,8);
                            sending       <= '1'; 
                            state <= "0110";
                            last_rx_chars(4 downto 0) <= (others => '0');
                        end if;
                        
                    when "0110" =>
                        -- Should be waiting "OK"
                        if rx_seeing_ok = '1' then                                            
                            -- Open the socket
                            status_wifi_up   <= '1';
                            current_char  <= to_unsigned(128,8);
                            sending       <= '1'; 
                            state <= "0111";
                            last_rx_chars(4 downto 0) <= (others => '0');
                        end if;
                        
                    when "0111" =>
                        -- Should be waiting "linked" and "OK"
                        if rx_seeing_ok = '1' then                                                                    
                            -- Write the "send data command"
                            status_connected <= '1';
                            current_char  <= to_unsigned(32,8);
                            sending       <= '1'; 
                            state <= "1000";
                            last_rx_chars(4 downto 0) <= (others => '0');
                        end if;

                    when "1000" =>
                        -- Should be waiting "> " prompt
                        if rx_seeing_prompt = '1' then                                                                                            
                            -- Write the paylod "ping\r\n"
                            status_sending   <= '1';                        
                            current_char  <= to_unsigned(48,8);
                            sending       <= '1'; 
                            state <= "1001";
                            last_rx_chars(4 downto 0) <= (others => '0');
                        end if;

                    when "1001" =>
                        if rx_seeing_ok = '1' then -- Should really be looking for "SEND OK", but...                                                                    
                            -- Close the socket 
                            if rx_seeing_ok = '1' then
                                last_rx_chars(4 downto 0) <= (others => '0');
                            
                                if powerdown = '1' then     
                                    -- Jump to the shutdown state                                                               
                                    state         <= "1011";
                                else
                                    -- pause then resend the payload again
                                    delay_counter <= (others => '1');
                                    state         <= "1010";
                                end if;
                            end if;
                        end if;
                    when "1010" =>
                        current_char  <= to_unsigned(32,8);
                        sending       <= '1'; 
                        state <= "1000";
                        last_rx_chars(4 downto 0) <= (others => '0');
                        
                    when "1011" =>
                        status_sending <= '0';                        
                        current_char   <= to_unsigned(64,8);
                        sending        <= '1'; 
                        state          <= "1100";
                    
                    when "1100" =>  -- Power down the module.
                        if rx_seeing_ok = '1' then           
                             status_connected <= '0';
                            -- Wait a while before power down the module.                                                         
                            delay_counter <= (others => '1');
                            state <= "0000";
                            last_rx_chars(4 downto 0) <= (others => '0');

                        end if;

                    when "1111" =>  -- Error state
                        status_connected <= '0';
                        status_sending   <= '0';
                        status_active    <= '0';
                        status_wifi_up   <= '0';
                        status_error     <= '1';                        
                        delay_counter <= (others => '1');
                        -- Power down and hang here.
                        wifi_enable      <= '0';
                        state <= "0000"; -- restart
                         
                    when others =>
                        state <= "0000"; -- restart
                end case;
            end if;

            --==================================================================
            -- Sort of a watchdog  
            -- inc_wd_high is '1' every one millisecond.
            -- so if we don't see a state change for 10 seconds, then
            -- trigger the watchdog to reset everything
            --==================================================================
            if inc_wd_high = '1' then
                if watchdog_high = 10000 then
                    state <= "1111"; -- Flag error and restart
                end if;
                watchdog_high <= watchdog_high + 1;
            end if;

            -- reset the watchdog if the state changes
            if state_last /= state or state = "0000" then
               watchdog_high <= (others => '0');
            end if;
            state_last <= state;
            
            if watchdog_low = 99999 then
                watchdog_low <= (others => '0');
                inc_wd_high <= '1';
            else 
                watchdog_low <= watchdog_low + 1;
                inc_wd_high <= '0';
            end if;
            
            --==================================================================
            -- Processing the received bytes of data 
            --==================================================================             
            if rx_data_enable = '1' then
                last_rx_chars <= last_rx_chars(last_rx_chars'high-8 downto 0) & rx_data;
            end if;

            if last_rx_chars(63 downto 0) = x"6368616e67650d0a" then -- ASCII for "change\r\n"
                 rx_seeing_change <= '1';
             else
                 rx_seeing_change <= '0';
             end if;

            if last_rx_chars(55 downto 0) = x"72656164790d0a" then -- ASCII for "ready\r\n"
                rx_seeing_ready <= '1';
            else
                rx_seeing_ready <= '0';
            end if;
            
            if last_rx_chars(31 downto 0) = x"4f4b0d0a" then -- ASCII for "OK\r\n"
                rx_seeing_ok <= '1';
            else
                rx_seeing_ok <= '0';
            end if;

            if last_rx_chars(15 downto 0) = x"3e20" then -- ASCII for ""> " prompt
                rx_seeing_prompt <= '1';
            else
                rx_seeing_prompt <= '0';
            end if;
            
            if last_rx_chars(79 downto 0) = x"2b4950442c313a410d0a" then -- ASCII for "+IPD,1:A\r\n" prompt
                status_led_1 <= '1';
            end if;
            if last_rx_chars(79 downto 0) = x"2b4950442c313a610d0a" then -- ASCII for "+IPD,1:a\r\n" prompt
                status_led_1 <= '0';
            end if;

            if last_rx_chars(79 downto 0) = x"2b4950442c313a420d0a" then -- ASCII for "+IPD,1:B\r\n" prompt
                status_led_2 <= '1';
            end if;
            if last_rx_chars(79 downto 0) = x"2b4950442c313a620d0a" then -- ASCII for "+IPD,1:b\r\n" prompt
                status_led_2 <= '0';
            end if;
                        
            if last_rx_chars(79 downto 0) = x"2b4950442c313a430d0a" then -- ASCII for "+IPD,1:C\r\n" prompt
                status_led_3 <= '1';
            end if;
            if last_rx_chars(79 downto 0) = x"2b4950442c313a630d0a" then -- ASCII for "+IPD,1:c\r\n" prompt
                status_led_3 <= '0';
            end if;
            
            if last_rx_chars(79 downto 0) = x"2b4950442c313a440d0a" then -- ASCII for "+IPD,1:D\r\n" prompt
                status_led_4 <= '1';
            end if;
            if last_rx_chars(79 downto 0) = x"2b4950442c313a640d0a" then -- ASCII for "+IPD,1:d\r\n" prompt
                status_led_4 <= '0';
            end if;
        end if;
    end process;

end Behavioral;