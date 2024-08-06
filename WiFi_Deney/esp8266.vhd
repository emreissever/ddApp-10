---------------------------------------------------------
-- WifiTopLevel.vhd 
--
-- Top level for the ESP8266 demo project
--
-- Author: Mike Field <hamster@snap.net.nz>
-----------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity WifiTopLevel is
    Port ( clk100        : in  STD_LOGIC;
           led           : out STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
           sw            : in  STD_LOGIC_VECTOR( 0 downto 0) := (others => '0');
           wifi_enable   : out STD_LOGIC;
           wifi_rx       : in  STD_LOGIC;
           wifi_tx       : out STD_LOGIC);
end WifiTopLevel;

architecture Behavioral of WifiTopLevel is

    component esp8266_driver is
    Port ( clk100           : in  STD_LOGIC;
           powerdown        : in  STD_LOGIC;
           status_active    : out STD_LOGIC;
           status_wifi_up   : out STD_LOGIC;
           status_connected : out STD_LOGIC;
           status_sending   : out STD_LOGIC;
           status_error     : out STD_LOGIC;
           status_led_1     : out STD_LOGIC;
           status_led_2     : out STD_LOGIC;
           status_led_3     : out STD_LOGIC;
           status_led_4     : out STD_LOGIC;
           payload0         : in  std_logic_vector(7 downto 0) := x"00";
           payload1         : in  std_logic_vector(7 downto 0) := x"00";
           payload2         : in  std_logic_vector(7 downto 0) := x"00";
           payload3         : in  std_logic_vector(7 downto 0) := x"00";
           wifi_enable      : out STD_LOGIC;
           wifi_rx          : in  STD_LOGIC;
           wifi_tx          : out STD_LOGIC);
    end component;


    signal char0 : std_logic_vector(7 downto 0) := x"00";
    signal char1 : std_logic_vector(7 downto 0) := x"00";
    signal char2 : std_logic_vector(7 downto 0) := x"00";
    signal char3 : std_logic_vector(7 downto 0) := x"00";
begin

i_esp8226: esp8266_driver Port map (
           clk100           => clk100,
           powerdown        => sw(0),
           status_active    => led(0),
           status_wifi_up   => led(1),
           status_connected => led(2),
           status_sending   => led(3),
           status_error     => led(4),
           status_led_1     => led(15),
           status_led_2     => led(14),
           status_led_3     => led(13),
           status_led_4     => led(12),
           payload0         => x"41", -- ASCII A
           payload1         => x"42", -- ASCII B
           payload2         => x"43", -- ASCII C
           payload3         => x"44", -- ASCII D
           wifi_enable      => wifi_enable,
           wifi_rx          => wifi_rx,
           wifi_tx          => wifi_tx);

end Behavioral;
