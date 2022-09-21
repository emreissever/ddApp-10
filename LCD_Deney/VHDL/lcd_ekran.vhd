----------------------------------------------------------------------------------
-- Company: Beti Elektronik
-- Engineer: Emre İŞSEVER
-- 
-- Create Date: 24/09/2021 10:57:06 PM
-- Design Name: Karakter LCD Uygulaması
-- Module Name: Karakter LCD Modülü
-- Project Name: Karakter LCD Uygulama
-- Target Devices: Basys3
-- Description: 8x2 Karakter LCD üzerine "FPGA ddApp-10" yazdıran kod.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LCDController is
generic(
    initial_delay  : integer  :=  4000000;  --40 ms gecikme
    delay1  : integer  :=  200000;  --2  ms gecikme
    delay2  : integer  :=  5000 ); --50 us gecikme 
port(
    clk : in std_logic;
    LCD_DB	: inout unsigned(3 downto 0);    
    LCD_E	: out std_logic;
    LCD_RS	: out std_logic;
    LCD_RW	: out std_logic );
end LCDController;

architecture Behavioral of LCDController is
    type tip_mesaj is array (0 to 12) of unsigned(7 downto 0);   
    constant mesaj : tip_mesaj :=(
    (X"46"),(X"50"),(X"47"),(X"41"), (X"20"),   (X"64"),(X"64"),(X"41"),(X"70"),(X"70"),(X"2d"),(X"31"),(X"30"));
--     F       P       G       A     (bosluk)      d       d       A       p       p       -       1       0     
              
    signal  lcd : unsigned(6 downto 0) := "1111111";   
    
begin
    LCD_DB <= lcd(3 downto 0);
    LCD_E <= lcd(6);
    LCD_RS <= lcd(5);
    LCD_RW <= lcd(4);
 
process(clk)
    variable	adim	:	integer range 0 to 27		:=	0;
    variable	sayac	:	integer range 0 to 5000000	:=	0;
    variable	i	:	integer range 0 to 14		:=	0;
begin
    if(rising_edge(clk)) then
        sayac:=sayac+1;
        case adim is
---------------Acilis Gecikmesi, 40 ms-----------------------------
	       when	0 => if (sayac=initial_delay) then
                            sayac := 0;
                            adim :=	1;
					 end if;			
---------------Acilis Ayarlari, 2x8 biciminde calis----------------
		   when	1 => lcd <= "1000010";
					 if (sayac=delay2/20) then
						sayac := 0;
						adim :=	2;
					 end if;
		   when	2	=>	lcd <= "0000010";
					if (sayac=delay2/20) then
						adim :=	3;
					end if;
		   when	3	=>	lcd <= "1001110";
					if (sayac=delay2/10) then
						adim :=	4;
					end if;
		   when	4	=>	lcd <= "0001110";
					if (sayac=3*delay2/20) then
						adim :=	5;
					end if;
		   when	5	=>	lcd <= "1001000";
					if (sayac=delay2/5) then
						adim :=	6;
					end if;
		   when	6	=>	lcd <= "0000010";
					if (sayac=delay2) then
						adim :=	7;
						sayac := 0;
					end if;
---------------Ekrani Acma, Imlec ayarlari, Yanip/sonme---------------
		   when	7	=>	lcd <= "1000000";
					if (sayac=delay2/20) then
						adim :=	8;
					end if;
		   when	8	=>	lcd <= "0000000";
					if (sayac=delay2/10) then
						adim :=	9;
					end if;
		   when	9	=>	lcd <= "1001100";
					if (sayac=3*delay2/20) then
						adim :=	10;
					end if;
		   when	10	=>	lcd <= "0001100";
					if (sayac=delay2) then
						adim :=11;
						sayac := 0;
					end if;
---------------Ekrani Temizle, Baslangic Adresine Git-----------------
		   when	11	=>	lcd <= "1000000";
					if (sayac=delay1/800) then
						adim :=	12;
					end if;
		   when	12	=>	lcd <= "0000000";
					if (sayac=delay1/400) then
						adim :=	13;
					end if;
		   when	13	=>	lcd <= "1000001";
					if (sayac=3*delay1/800) then
						adim :=	14;
					end if;
		   when	14	=>	lcd <= "0000001";
					if (sayac=delay1) then
						adim :=	15;
						sayac := 0;
					end if;					
---------------Adresleme Ayarlari Adres Arttirici---------------------
		   when	15	=>	lcd <= "1000000";
					if (sayac=delay2/20) then
						adim :=	16;
						end if;
		   when	16	=>	lcd <= "0000000";
					if (sayac=delay2/10) then
						adim :=	17;
					end if;
		   when	17	=>	lcd <= "1000110";
					if (sayac=3*delay2/20) then
						adim :=	18;
					end if;
		   when	18	=>	lcd <= "0000110";
					if (sayac=delay2) then
						adim :=	19;
						sayac :=	0;
					end if;				
---------------Ekrana Karakter Basma işlemi--------------------------
		   when	19	=>	lcd <= "110"&mesaj(i)(7 downto 4);
					if (sayac=delay2/20) then
						adim :=	20;
					end if;
		   when	20	=>	lcd <= "010"&mesaj(i)(7 downto 4);
		  			if (sayac=delay2/10) then
						adim :=	21;
					end if;
		   when	21	=>	lcd <= "110"&mesaj(i)(3 downto 0);
					if (sayac=3*delay2/20) then
						adim :=	22;
					end if;
		   when	22	=>	lcd <= "010"&mesaj(i)(3 downto 0);
					if (sayac=delay2) then
						adim :=	23;
						sayac:= 0;
					end if;						
        --Alt Satıra Geçme işlemi
           when 23  => if (i=4) then
                            lcd <= "100"&"1100";
                            if (sayac=delay2/20) then
                                adim := 24;
                            end if;
                        else
                            adim := 27;
                        end if;                       
           when 24 => lcd <= "000"&"1100";
                        if (sayac=delay2/10) then
                            adim := 25;
                        end if;                 
           when 25 => lcd <= "100"&"0000";
                        if(sayac=3*delay2/20) then
                            adim := 26;
                            end if;   
           when 26 => lcd <= "000"&"0000";
                        if(sayac=delay2) then
                            adim := 27;
                            end if;       
		   when 27 => if (i<12) then 
		                  i := i+1;
						  adim := 19;
						  sayac := 0;
					  else
						  adim := 27;
						  sayac := 0;
					  end if;
        end case;
    end if;
end process;
end Behavioral;