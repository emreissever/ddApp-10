-----------------------------------------
-- tx.vhd - Transmit data to an ESP8266
--
-- Author: Mike Field <hamster@snap.net.nz>
--
-- Designed for 9600 baud and 100MHz clock
--
------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tx is
    Port ( clk         : in  STD_LOGIC;
           data        : in  STD_LOGIC_VECTOR (7 downto 0);
           data_enable : in  STD_LOGIC;
           busy        : out STD_LOGIC;
           tx_out      : out STD_LOGIC);
end tx;

architecture Behavioral of tx is
    signal baud_count       : unsigned(13 downto 0) := (others => '0');
    constant baud_count_max : unsigned(13 downto 0) := to_unsigned(100000000/115200, 14);
    signal busy_sr          : std_logic_vector(9 downto 0) := (others => '0');

    signal sending          : std_logic_vector(9 downto 0) := (others => '0');
begin
    busy <= busy_sr(0) or data_enable;
    
clk_proc: process(clk)
    begin
        if rising_edge(clk) then
            if baud_count = 0 then
                baud_count <= baud_count_max;
                tx_out     <= sending(0);
                sending    <= '1' & sending(sending'high downto 1);
                busy_sr    <= '0' & busy_sr(busy_sr'high downto 1);
            else
                baud_count  <= baud_count - 1;         
            end if;

            if busy_sr(0) = '0' and data_enable = '1' then
                baud_count <= baud_count_max;
                sending    <= "1" & data & "0";
                busy_sr    <= (others =>'1');
            end if;
            
        end if;
    end process;

end Behavioral;