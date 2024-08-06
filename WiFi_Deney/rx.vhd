-----------------------------------------
-- rx.vhd - Receive serial data from an ESP8266
--
-- Author: Mike Field <hamster@snap.net.nz>
--
-- Designed for 9600 baud and 100MHz clock
--
------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rx is
    Port ( clk : in STD_LOGIC;
           rx_in : in STD_LOGIC;
           data : out STD_LOGIC_VECTOR (7 downto 0);
           data_enable : out STD_LOGIC);
end rx;

architecture Behavioral of rx is
    signal baud_count       : unsigned(13 downto 0) := (others => '0');
    constant baud_count_max : unsigned(13 downto 0) := to_unsigned(100000000/115200, 14);
    signal busy                : std_logic:= '0';
    signal receiving           : std_logic_vector(7 downto 0) := (others => '0');
    signal rx_in_last          : std_logic:= '1';
    signal rx_in_synced        : std_logic:= '1';
    signal rx_in_almost_synced : std_logic:= '1';

    signal bit_count           : unsigned(3 downto 0) := (others => '0');
begin
    
process(clk)
    begin
        if rising_edge(clk) then
            data_enable <= '0';
            if busy = '1' then
            
                if baud_count = 0 then
                    if bit_count = 9 then
                        -- We've got all the bits we need
                        busy        <= '0';
                        data        <= receiving(7 downto 0);
                        data_enable <= '1';
                    end if;
                    
                    -- receive this bit
                    receiving  <= rx_in_synced & receiving(7 downto 1);
                    -- Set timer for the next bit
                    bit_count  <= bit_count + 1;        
                    baud_count <= baud_count_max;
                else
                    baud_count <= baud_count-1;
                end if; 
            else
                -- Is this the falling edge of the start bit?
               if rx_in_last = '1' and rx_in_synced = '0' then
                    -- Load it up with half the count so we sample in the middle of the bit
                    baud_count <= '0' & baud_count_max(13 downto 1);
                    bit_count  <= (others => '0');
                    busy       <= '1';
               end if;   
            end if;

            rx_in_last   <= rx_in_synced;
            -- Synchronise the RX signal
            rx_in_synced        <= rx_in_almost_synced;
            rx_in_almost_synced <= rx_in;
        end if;
    end process;
end Behavioral;