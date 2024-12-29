
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_SIGNED;
use IEEE.STD_LOGIC_UNSIGNED; 
use ieee.std_logic_unsigned.all;
entity main is
port(

rst   :in std_logic;
clk  	:in std_logic;


rst_lcd		:out std_logic;
d_c			:out std_logic;
led         : out std_logic_vector(15 downto 0);
spi_data_out       : out std_logic;
spi_clk				 : out std_logic;
spi_ce				 : out std_logic


);
end main;

architecture Behavioral of main is

component spi_sender
port(
rst   :in std_logic;
clk  :in std_logic;


gonderilecek_data_8  : in std_logic_vector(7 downto 0);
gonderilecek_data_16  : in std_logic_vector(15 downto 0);
data_16_bit  : in std_logic;
gonder_komutu_aktif_rising_edge  : in std_logic;

spi_data_out       : out std_logic;
spi_clk				 : out std_logic;
spi_ce				 : out std_logic

);
end component;

signal state :integer ;
signal sayici : unsigned(4 downto 0);

signal paralel_data_8 : std_logic_vector(7 downto 0);
signal paralel_data_16 : std_logic_vector(15 downto 0);
signal data_16_bit  : std_logic;
signal spi_gonder  : std_logic;

signal clk_sayici : unsigned (11 downto 0);
signal clk_yavas: std_logic;

constant GRAMWIDTH, GRAMHEIGH: std_logic_vector(15 downto 0):= X"0080";
constant GRAMSIZE: unsigned(15 downto 0):= X"4000";
signal piksel_state :integer ;
signal piksel_count: unsigned(15 downto 0):= X"0000";
signal piksel_x_max: unsigned(15 downto 0):= X"0080";
signal piksel_y_max: unsigned(15 downto 0):= X"0080";
signal dummy_piksel_x: unsigned(31 downto 0):= X"00000000";
signal piksel_x: unsigned(15 downto 0):= X"0000";
signal piksel_y: unsigned(15 downto 0):= X"0000";



constant BLACK: std_logic_vector(15 downto 0):= X"0000";
constant BLUE: std_logic_vector(15 downto 0):= X"001F";
constant RED: std_logic_vector(15 downto 0):= X"00F8";
constant GREEN: std_logic_vector(15 downto 0):= X"07E0";
constant CYAN: std_logic_vector(15 downto 0):= X"07FF";
constant MAGENTA: std_logic_vector(15 downto 0):= X"F81F";
constant YELLOW: std_logic_vector(15 downto 0):= X"E0FF";
constant WHITE: std_logic_vector(15 downto 0):= X"FFFF";

type COLOR_T is array (0 to 7) of std_logic_vector(15 downto 0);
signal color : COLOR_T := (BLACK, BLUE, RED, GREEN, CYAN, MAGENTA, YELLOW,WHITE);
--color(0) <= BLACK;
--color(1) <= BLUE;
--color(2) <= RED;
--color(3) <= GREEN;
--color(4) <= CYAN;
--color(5) <= MAGENTA;
--color(6) <= YELLOW;
--color(7) <= WHITE;
signal color_count :integer := 0;
begin


rst_lcd<=  rst;

spi :spi_sender
port map(
rst => rst,
clk  => clk_yavas,

gonderilecek_data_8  => paralel_data_8,
gonderilecek_data_16  => paralel_data_16,
data_16_bit => data_16_bit,
gonder_komutu_aktif_rising_edge  => spi_gonder,

spi_data_out       => spi_data_out,
spi_clk				 => spi_clk,
spi_ce				 => spi_ce

);
process(rst,clk)
begin
	if rst='0' then
			clk_sayici<=(others=>'0');
	elsif rising_edge(clk)then
			clk_sayici<=clk_sayici+1;
			
	end if;

end process;

clk_yavas<=clk_sayici(11);

process(clk_yavas,rst)
begin
	if rst='0' then
	       color_count <= 0;
		   state<=0;
		   piksel_state<=0;
		   data_16_bit <= '0';
			paralel_data_8<=X"00";
			paralel_data_16<=X"0000";
			spi_gonder<='0';
			D_C<='0';		
			sayici<=(others=>'0');
			
	elsif rising_edge(clk_yavas) then
	
	  case(state) is
		
		when 0 =>
		      data_16_bit <= '0';
			paralel_data_8<=X"11"; --EXIT_SLEEP_MODE
			spi_gonder<='1';
			D_C<='0';	
			
			if (sayici< "01111") then--bekleme suresi
				sayici<=sayici+1;
			else
				sayici<=(others=>'0');
				state<=state+1;
				spi_gonder<='0';
			end if;
				
		when 1 =>
		data_16_bit <= '0';
			paralel_data_8<=X"3A"; --SET_PIXEL_FORMAT
			spi_gonder<='1';
			D_C<='0';	
			
			if (sayici< "01111") then--bekleme suresi
				sayici<=sayici+1;
			else
				sayici<=(others=>'0');
				state<=state+1;
				spi_gonder<='0';
			end if;	

		when 2 =>
		data_16_bit <= '0';
			paralel_data_8<=X"05"; --16 bits per pixel
			spi_gonder<='1';
			D_C<='1';	
			
			if (sayici< "01111") then--bekleme suresi
				sayici<=sayici+1;
			else
				sayici<=(others=>'0');
				state<=state+1;
				spi_gonder<='0';
			end if;		

		when 3 =>
		data_16_bit <= '0';
			paralel_data_8<=X"26"; --SET_GAMMA_CURVE
			spi_gonder<='1';
			D_C<='0';	
			
			if (sayici< "01111") then--bekleme suresi
				sayici<=sayici+1;
			else
				sayici<=(others=>'0');
				state<=state+1;
				spi_gonder<='0';
			end if;				

		when 4 =>
		data_16_bit <= '0';
			paralel_data_8<=X"04"; --Select gamma curve 3
			spi_gonder<='1';
			D_C<='1';	
			
			if (sayici< "01111") then--bekleme suresi
				sayici<=sayici+1;
			else
				sayici<=(others=>'0');
				state<=state+1;
				spi_gonder<='0';
			end if;				
			
		when 5 =>
		data_16_bit <= '0';
			paralel_data_8<=X"29"; --SET_DISPLAY_ON
			spi_gonder<='1';
			D_C<='0';	
			
			if (sayici< "01111") then--bekleme suresi
				sayici<=sayici+1;
			else
				sayici<=(others=>'0');
				state<=state+1;
				spi_gonder<='0';
			end if;	
			
        when 6 =>
        data_16_bit <= '0';
            paralel_data_8<=X"2C"; --WRITE_MEMORY_START
            spi_gonder<='1';
            D_C<='0';    
            
            if (sayici< "01111") then--bekleme suresi
                sayici<=sayici+1;
            else
                sayici<=(others=>'0');
                state<=state+1;
                spi_gonder<='0';
            end if;    
--ÝLKLENDÝRME TAMAMLANDI.			
--ekran alanýný belirle
		when 7 =>
        data_16_bit <= '0';
            paralel_data_8<=X"2A"; --SET_COLUMN_ADDRESS
            spi_gonder<='1';
            D_C<='0';    
            
            if (sayici< "01111") then--bekleme suresi
                sayici<=sayici+1;
            else
                sayici<=(others=>'0');
                state<=state+1;
                spi_gonder<='0';
            end if; 

		when 8 =>
        data_16_bit <= '1';
            paralel_data_16<=X"0000"; --SEND X0
            spi_gonder<='1';
            D_C<='1';    
            
            if (sayici< "11111") then--bekleme suresi
                sayici<=sayici+1;
            else
                sayici<=(others=>'0');
                state<=state+1;
                spi_gonder<='0';
            end if; 

		when 9 =>
        data_16_bit <= '1';
            paralel_data_16<=GRAMWIDTH; --SEND X1
            spi_gonder<='1';
            D_C<='1';    
            
            if (sayici< "11111") then--bekleme suresi
                sayici<=sayici+1;
            else
                sayici<=(others=>'0');
                state<=state+1;
                spi_gonder<='0';
            end if; 
            
		when 10 =>
            data_16_bit <= '0';
                paralel_data_8<=X"2B"; --SET_PAGE_ADDRESS
                spi_gonder<='1';
                D_C<='0';    
                
                if (sayici< "01111") then--bekleme suresi
                    sayici<=sayici+1;
                else
                    sayici<=(others=>'0');
                    state<=state+1;
                    spi_gonder<='0';
                end if; 			
		when 11 =>
                data_16_bit <= '1';
                    paralel_data_16<=X"0000"; --SEND Y0
                    spi_gonder<='1';
                    D_C<='1';    
                    
                    if (sayici< "11111") then--bekleme suresi
                        sayici<=sayici+1;
                    else
                        sayici<=(others=>'0');
                        state<=state+1;
                        spi_gonder<='0';
                    end if; 
        
            when 12 =>
                data_16_bit <= '1';
                paralel_data_16<=GRAMHEIGH; --SEND Y1
                spi_gonder<='1';
                D_C<='1';    
                
                if (sayici< "11111") then--bekleme suresi
                    sayici<=sayici+1;
                else
                    sayici<=(others=>'0');
                    state<=state+1;
                    spi_gonder<='0';
                end if; 
		when 13 =>
                data_16_bit <= '0';
                    paralel_data_8<=X"2C"; --WRITE_MEMORY_START
                    spi_gonder<='1';
                    D_C<='0';    
                    
                    if (sayici< "01111") then--bekleme suresi
                        sayici<=sayici+1;
                    else
                        sayici<=(others=>'0');
                        state<=state+1;
                        spi_gonder<='0';
                    end if; 
--ekran alanýný belirle tamamlandý
--ekraný renk ile doldur	
        when 14 =>   
            data_16_bit <= '1';
            piksel_y <= shift_right(piksel_count,7);
            led <= std_logic_vector(shift_left(piksel_y,8));
            dummy_piksel_x <= (piksel_y*piksel_x_max);
            piksel_x <= piksel_count - dummy_piksel_x(15 downto 0);
            if( (0 <= piksel_x ) and (piksel_x < shift_right(unsigned(piksel_x_max),1))) then
                if ((0 <= piksel_y ) and (piksel_y < shift_right(unsigned(piksel_y_max),1))) then
                    led <= "0000000000001000";
                    paralel_data_16<=color(color_count);
                else
                    led <= "0000000000000100";
                    paralel_data_16<=color(color_count+1);
                end if;
            else 
                if ((0 <= piksel_y ) and (piksel_y < shift_right(unsigned(piksel_y_max),1))) then
                    led <= "0000000000000010";
                    paralel_data_16<=color(color_count+2);
                else
                    led <= "0000000000000001";
                    paralel_data_16<=color(color_count+3);
                end if;

            end if;
             
            spi_gonder<='1';
            D_C<='1';    
            
            if (sayici< "11111") then--bekleme suresi
                sayici<=sayici+1;
            else
                sayici<=(others=>'0');
                if (piksel_count < GRAMSIZE) then
                    piksel_count <= piksel_count + 1;
                    state <= state;
                else
                    piksel_count <= X"0000";
                    if color_count < 4 then
                        color_count <= color_count + 1;
                    else
                        color_count <= 0;
                    end if;
                    state<=7;
                end if;
                spi_gonder<='0';
            end if; 
            
--         when 15 =>
--            state<=0;
--             data_16_bit <= '0';
--              paralel_data_8<=X"00";
--              paralel_data_16<=X"0000";
--              spi_gonder<='0';
--              D_C<='0';        
--              sayici<=(others=>'0');
--            state <= 15;   
		 when others=>
			state<=0;
				
		end case;
	end if;
	
end process;
end Behavioral;
