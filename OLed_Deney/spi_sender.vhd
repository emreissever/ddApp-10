
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity spi_sender is
port(
    rst   :in std_logic;
    clk  	:in std_logic;
    gonderilecek_data_8  : in std_logic_vector(7 downto 0);
    gonderilecek_data_16  : in std_logic_vector(15 downto 0);
    data_16_bit  : in std_logic;
    gonder_komutu_aktif_rising_edge  : in std_logic;
    spi_data_out       : out std_logic;
    spi_clk				 : out std_logic;
    spi_ce				 : out std_logic );

end spi_sender;

architecture Behavioral of spi_sender is
    signal gonder_komutu_aktif_rising_edge_buf : std_logic;
    signal gonderilecek_data_buf_8 : std_logic_vector(7 downto 0);
    signal gonderilecek_data_buf_16 : std_logic_vector(15 downto 0);
    signal state : integer;
    signal data_sayisi_8 : unsigned (2 downto 0);
    signal data_sayisi_16 : unsigned (3 downto 0);
begin

    spi_clk <= not clk;
    
process(rst,clk)
begin
if rst='0' then
    spi_data_out<='0';
	spi_ce<='1';
	state<=0;
	gonder_komutu_aktif_rising_edge_buf<='0';	
	data_sayisi_8<=(others=>'1');
    data_sayisi_16<=(others=>'1');   
elsif rising_edge(clk) then
	gonder_komutu_aktif_rising_edge_buf<=gonder_komutu_aktif_rising_edge;
	case(state) is
        when 0 =>    
            data_sayisi_8<=(others=>'1');
            data_sayisi_16<=(others=>'1');
            spi_data_out<='0';
            spi_ce<='1';      
            if gonder_komutu_aktif_rising_edge_buf='0' and gonder_komutu_aktif_rising_edge='1' then 
                if data_16_bit = '0' then
                    state<=1;
                    gonderilecek_data_buf_8<=gonderilecek_data_8;
                else 
                    state<=2;
                    gonderilecek_data_buf_16<=gonderilecek_data_16;
                end if;
            end if;                   
        when 1 =>             
            if (data_sayisi_8 > "000") then
                data_sayisi_8<=data_sayisi_8-1;
            else 
                data_sayisi_8<=(others=>'1');
                state<=0;	
            end if;         
            spi_data_out<=gonderilecek_data_buf_8(to_integer(data_sayisi_8));
            spi_ce<='0';       
        when 2 =>               
            if (data_sayisi_16 > "0000") then
                data_sayisi_16<=data_sayisi_16-1;
            else 
                data_sayisi_16<=(others=>'1');
                state<=0;    
            end if;    
                spi_data_out<=gonderilecek_data_buf_16(to_integer(data_sayisi_16));
                spi_ce<='0';       
        when others=>
                state<=0;		 	
    end case;
end if;
end process;
end Behavioral;
