----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/07/2018 01:18:16 PM
-- Design Name: 
-- Module Name: dc_motor_encoder - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dc_motor_encoder is
generic(
    init_d : integer  :=  4000000;  --40 ms gecikme
    com_dl : integer  :=  200000;   --2  ms gecikme
    com_ds : integer  :=  5000    --50 us gecikme
);	   

port(			
    USER_CLK:in std_logic;--50MHz.
    input:in std_logic;
    
    duty:in unsigned(3 downto 0);
    
    YON:in std_logic;
    motor_control:out std_logic_vector(1 downto 0);
    
    LCD_DB	: inout   unsigned(3 downto 0);   
    LCD_E	: out	  std_logic;
    LCD_RS	: out	  std_logic;
    LCD_RW	: out	  std_logic);
       
end dc_motor_encoder;

architecture Behavioral of dc_motor_encoder is

type tip_mesaj is array (0 to 7) of unsigned(7 downto 0);
signal  lcd  :  unsigned(6 downto 0):="1111111";

signal adim: integer range 0 to 35:=0;
signal D: unsigned(15 downto 0):="0000000000000000";

signal pwm:std_logic;

signal input_gecmis:std_logic:='1';
signal input_gecmis_b:std_logic:='1';

signal period: unsigned (3 downto 0):="0000";
signal count: unsigned(3 downto 0):="0000";
signal clock_1khz:std_logic;--test amacýyla üretiliyor.

signal counter5:unsigned(15 downto 0):="0000000000000000";--bir zaman birimi için(5sn) motorun tur sayýsýný sayýyor.

begin
-----------------MOTOR CONTROL-----------
period<="1010";--10

PROCESS(USER_CLK)
variable counter:integer range 0 to 100000:=0;
BEGIN

if rising_edge(USER_CLK)then

if counter=50000 then

counter:=0;
clock_1khz<=not clock_1khz;
else
counter:=counter+1;
end if;
end if;
end process;

process(clock_1KHZ)
begin
	if falling_edge(clock_1KHZ)then
		if (count=(period-1)) then
			count<="0000";
		else	
			count<=count+1;
		end if;
	end if;	
end process;

process(count,duty)
begin
			if count<duty then
				pwm<='1';
			else
				pwm<='0';
			end if;
			
end process;


PROCESS(YON,PWM)
begin
if yon='1' then
motor_control(1)<=pwm;
motor_control(0)<='0';
else
motor_control(1)<='0';
motor_control(0)<=pwm;
end if;
end process;
-----------------LCD YAZDIRMA--------------------
LCD_DB	<=	lcd(3 downto 0);
LCD_E	<=	lcd(6);
LCD_RS	<=	lcd(5);
LCD_RW	<=	lcd(4);

process(USER_CLK)

    variable mesaj : tip_mesaj;
    variable	adim_lcd	:	integer range 0 to 23		:=	0;
    variable	sayac	:	integer range 0 to 50000000	:=	0;
    variable	m	:	integer range 0 to 8		:=	0;
    
    variable butun_vector: unsigned(35 downto 0):="000000000000000000000000000000000000";
    
    alias data_final:unsigned(15 downto 0) is butun_vector(15 downto 0);
    
    alias ten_thousands:unsigned(3 downto 0) is butun_vector(35 downto 32);--BCD converter
    alias thousands:unsigned(3 downto 0) is butun_vector(31 downto 28);--BCD converter
    alias hundreds :unsigned(3 downto 0) is butun_vector(27 downto 24);--BCD converter
    alias tens:unsigned(3 downto 0) is butun_vector(23 downto 20);--BCD converter
    alias unit:unsigned(3 downto 0) is butun_vector(19 downto 16);--BCD converter
    variable counter:integer range 0 to 100000000:=0;--genel devrede kullanýlýyor.   
    --counter 3 ve 4 ün yardýmýyla 5 sn zaman tutuluyor.
    variable counter4:integer range 0 to 100000000:=0;--1s hesaplamak için
    variable counter3:integer range 0 to 5:=0;
    
    variable i:integer range 0 to 3:=0;--tasarýmýn 4 basamaðý arasýnda geçisi saðlýyor.
begin

--motorun tur sayýsý sayýlýyor.
if rising_edge(USER_CLK) then
input_gecmis<=input;
input_gecmis_b<=input_gecmis;
end if;


if rising_edge(USER_CLK) then
case (i) is
when 0=>	--moturun tur sayýsýnýn okunmasý
if input_gecmis_b='0' and input_gecmis='1'  then--yükselen kenarda
counter5<=counter5+1;
end if;

counter4:=counter4+1;
if counter4=50000000 then--1sn geçtiðinde counter3 1 arttýrýlýyor.
counter3:=counter3+1;
counter4:=0;
end if;

if counter3=5 then
D<=counter5;
counter4:=0;
counter3:=0;
counter5<="0000000000000000";
i:=1;
end if;

when 1=>	--ilgili hesaplamalarýn yapýlmasý

data_final:=D;
adim<=0;

i:=2;

when 2=>--bcd converter

--BCD converter
case adim is

when 0=>
unit:="0000";
tens:="0000";
hundreds:="0000";
thousands:="0000";
ten_thousands:="0000";
adim<=1;

when 1=>

butun_vector:=butun_vector+butun_vector;--shift left
adim<=2;

when 2=>

if ten_thousands>"0100" then
ten_thousands:=ten_thousands+"0011";
end if;
if thousands>"0100" then
thousands:=thousands+"0011";
end if;
if hundreds>"0100" then
hundreds:=hundreds+"0011";
end if;
if tens>"0100" then
tens:=tens+"0011";
end if;
if unit>"0100" then
unit:=unit+"0011";
end if;

adim<=3;

when 3=>

butun_vector:=butun_vector+butun_vector;--shift left
adim<=4;

when 4=>
if ten_thousands>"0100" then
ten_thousands:=ten_thousands+"0011";
end if;
if thousands>"0100" then
thousands:=thousands+"0011";
end if;
if hundreds>"0100" then
hundreds:=hundreds+"0011";
end if;
if tens>"0100" then
tens:=tens+"0011";
end if;
if unit>"0100" then
unit:=unit+"0011";
end if;

adim<=5;

when 5=>

butun_vector:=butun_vector+butun_vector;--shift left
adim<=6;

when 6=>

if ten_thousands>"0100" then
ten_thousands:=ten_thousands+"0011";
end if;
if thousands>"0100" then
thousands:=thousands+"0011";
end if;
if hundreds>"0100" then
hundreds:=hundreds+"0011";
end if;
if tens>"0100" then
tens:=tens+"0011";
end if;
if unit>"0100" then
unit:=unit+"0011";
end if;

adim<=7;

when 7=>

butun_vector:=butun_vector+butun_vector;--shift left
adim<=8;

when 8=>
if ten_thousands>"0100" then
ten_thousands:=ten_thousands+"0011";
end if;
if thousands>"0100" then
thousands:=thousands+"0011";
end if;
if hundreds>"0100" then
hundreds:=hundreds+"0011";
end if;
if tens>"0100" then
tens:=tens+"0011";
end if;
if unit>"0100" then
unit:=unit+"0011";
end if;

adim<=9;

when 9=>

butun_vector:=butun_vector+butun_vector;--shift left
adim<=10;

when 10=>
if ten_thousands>"0100" then
ten_thousands:=ten_thousands+"0011";
end if;
if thousands>"0100" then
thousands:=thousands+"0011";
end if;
if hundreds>"0100" then
hundreds:=hundreds+"0011";
end if;
if tens>"0100" then
tens:=tens+"0011";
end if;
if unit>"0100" then
unit:=unit+"0011";
end if;

adim<=11;

when 11=>

butun_vector:=butun_vector+butun_vector;--shift left
adim<=12;

when 12=>
if ten_thousands>"0100" then
ten_thousands:=ten_thousands+"0011";
end if;
if thousands>"0100" then
thousands:=thousands+"0011";
end if;
if hundreds>"0100" then
hundreds:=hundreds+"0011";
end if;
if tens>"0100" then
tens:=tens+"0011";
end if;
if unit>"0100" then
unit:=unit+"0011";
end if;

adim<=13;

when 13=>

butun_vector:=butun_vector+butun_vector;--shift left
adim<=14;
when 14=>
if ten_thousands>"0100" then
ten_thousands:=ten_thousands+"0011";
end if;
if thousands>"0100" then
thousands:=thousands+"0011";
end if;
if hundreds>"0100" then
hundreds:=hundreds+"0011";
end if;
if tens>"0100" then
tens:=tens+"0011";
end if;
if unit>"0100" then
unit:=unit+"0011";
end if;

adim<=15;

when 15=>

butun_vector:=butun_vector+butun_vector;--shift left
adim<=16;
when 16=>

if ten_thousands>"0100" then
ten_thousands:=ten_thousands+"0011";
end if;
if thousands>"0100" then
thousands:=thousands+"0011";
end if;
if hundreds>"0100" then
hundreds:=hundreds+"0011";
end if;
if tens>"0100" then
tens:=tens+"0011";
end if;
if unit>"0100" then
unit:=unit+"0011";
end if;

adim<=17;

when 17=>

butun_vector:=butun_vector+butun_vector;--shift left
adim<=18;
when 18=>

if ten_thousands>"0100" then
ten_thousands:=ten_thousands+"0011";
end if;
if thousands>"0100" then
thousands:=thousands+"0011";
end if;
if hundreds>"0100" then
hundreds:=hundreds+"0011";
end if;
if tens>"0100" then
tens:=tens+"0011";
end if;
if unit>"0100" then
unit:=unit+"0011";
end if;

adim<=19;

when 19=>

butun_vector:=butun_vector+butun_vector;--shift left
adim<=20;
when 20=>

if ten_thousands>"0100" then
ten_thousands:=ten_thousands+"0011";
end if;
if thousands>"0100" then
thousands:=thousands+"0011";
end if;
if hundreds>"0100" then
hundreds:=hundreds+"0011";
end if;
if tens>"0100" then
tens:=tens+"0011";
end if;
if unit>"0100" then
unit:=unit+"0011";
end if;

adim<=21;

when 21=>

butun_vector:=butun_vector+butun_vector;--shift left
adim<=22;
when 22=>

if ten_thousands>"0100" then
ten_thousands:=ten_thousands+"0011";
end if;
if thousands>"0100" then
thousands:=thousands+"0011";
end if;
if hundreds>"0100" then
hundreds:=hundreds+"0011";
end if;
if tens>"0100" then
tens:=tens+"0011";
end if;
if unit>"0100" then
unit:=unit+"0011";
end if;

adim<=23;

when 23=>

butun_vector:=butun_vector+butun_vector;--shift left
adim<=24;
when 24=>

if ten_thousands>"0100" then
ten_thousands:=ten_thousands+"0011";
end if;
if thousands>"0100" then
thousands:=thousands+"0011";
end if;
if hundreds>"0100" then
hundreds:=hundreds+"0011";
end if;
if tens>"0100" then
tens:=tens+"0011";
end if;
if unit>"0100" then
unit:=unit+"0011";
end if;

adim<=25;

when 25=>

butun_vector:=butun_vector+butun_vector;--shift left
adim<=26;
when 26=>

if ten_thousands>"0100" then
ten_thousands:=ten_thousands+"0011";
end if;
if thousands>"0100" then
thousands:=thousands+"0011";
end if;
if hundreds>"0100" then
hundreds:=hundreds+"0011";
end if;
if tens>"0100" then
tens:=tens+"0011";
end if;
if unit>"0100" then
unit:=unit+"0011";
end if;

adim<=27;

when 27=>

butun_vector:=butun_vector+butun_vector;--shift left
adim<=28;
when 28=>

if ten_thousands>"0100" then
ten_thousands:=ten_thousands+"0011";
end if;
if thousands>"0100" then
thousands:=thousands+"0011";
end if;
if hundreds>"0100" then
hundreds:=hundreds+"0011";
end if;
if tens>"0100" then
tens:=tens+"0011";
end if;
if unit>"0100" then
unit:=unit+"0011";
end if;

adim<=29;

when 29=>

butun_vector:=butun_vector+butun_vector;--shift left
adim<=30;
when 30=>

if ten_thousands>"0100" then
ten_thousands:=ten_thousands+"0011";
end if;
if thousands>"0100" then
thousands:=thousands+"0011";
end if;
if hundreds>"0100" then
hundreds:=hundreds+"0011";
end if;
if tens>"0100" then
tens:=tens+"0011";
end if;
if unit>"0100" then
unit:=unit+"0011";
end if;

adim<=31;

when others=>

butun_vector:=butun_vector+butun_vector;--shift left
i:=3;
end case;

when others=>--LCD'ye yazdýrma.

--LCD'ye yazdýrma

--YAZDIRILACAK VERI ASAGIDA TANIMLANIR----
  

mesaj(4 to 7):=((X"20"),(X"52"),(X"50"),(X"4D"));
-----------------        --R-------P-------M---

mesaj  (0 TO 3) := (("0011"&thousands(3 downto 0)),("0011"&hundreds(3 downto 0)), ("0011"&tens(3 downto 0)),("0011"&unit(3 downto 0))); 
----LCDye bastirma kismi----
 
       sayac:=sayac+1;
		  		 
       case	adim_lcd	is
---------------Acilis Gecikmesi, 40 ms -----------------------------
		when	0	=>	if (sayac=init_d)	then
						sayac	:=	0;
						adim_lcd	:=	1;
					end if;
---------------Acilis Ayarlari, 2x16 biciminde calis----------------
		when	1	=>	lcd <= "1000010";
					if (sayac=com_ds/20) then
						sayac	:=	0;
						adim_lcd	:=	2;
					end if;
		when	2	=>	lcd <= "0000010";
					if (sayac=com_ds/20) then
						adim_lcd	:=	3;
					end if;
		when	3	=>	lcd <= "1001110";
					if (sayac=com_ds/10) then
						adim_lcd	:=	4;
					end if;
		when	4	=>	lcd <= "0001110";
					if (sayac=3*com_ds/20) then
						adim_lcd	:=	5;
					end if;
		when	5	=>	lcd <= "1001000";
					if (sayac=com_ds/5) then
						adim_lcd	:=	6;
					end if;
		when	6	=>	lcd <= "0000010";
					if (sayac=com_ds) then
						adim_lcd	:=	7;
						sayac	:=	0;
					end if;
---------------Ekrani Acma, Imlec ayarlari, Yanip/sonme---------------
		when	7	=>	lcd <= "1000000";
					if (sayac=com_ds/20) then
						adim_lcd	:=	8;
					end if;
		when	8	=>	lcd <= "0000000";
					if (sayac=com_ds/10) then
						adim_lcd	:=	9;
					end if;
		when	9	=>	lcd <= "1001100";
					if (sayac=3*com_ds/20) then
						adim_lcd	:=	10;
					end if;
		when	10	=>	lcd <= "0001100";
					if (sayac=com_ds) then
						adim_lcd	:=	11;
						sayac	:=	0;
					end if;
---------------Ekrani Temizle, Baslangic Adresine Git-----------------
		when	11	=>	lcd <= "1000000";
					if (sayac=com_dl/800) then
						adim_lcd	:=	12;
					end if;
		when	12	=>	lcd <= "0000000";
					if (sayac=com_ds/400) then
						adim_lcd	:=	13;
					end if;
		when	13	=>	lcd <= "1000001";
					if (sayac=3*com_dl/800) then
						adim_lcd	:=	14;
					end if;
		when	14	=>	lcd <= "0000001";
					if (sayac=com_dl) then
						adim_lcd	:=	15;
						sayac	:=	0;
					end if;
---------------Adresleme Ayarlari Adres Arttirici---------------------
		when	15	=>	lcd <= "1000000";
					if (sayac=com_ds/20) then
						adim_lcd	:=	16;
						end if;
		when	16	=>	lcd <= "0000000";
					if (sayac=com_ds/10) then
						adim_lcd	:=	17;
					end if;
		when	17	=>	lcd <= "1000110";
					if (sayac=3*com_ds/20) then
						adim_lcd	:=	18;
					end if;
		when	18	=>	lcd <= "0000110";
					if (sayac=com_ds) then
						adim_lcd	:=	19;
						sayac	:=	0;
					end if;
---------------Ekrana Karakter Basma Islemi()--------------------------
		when	19	=>	lcd <= "110"&mesaj(m)(7 downto 4);
					if (sayac=com_ds/20) then
						adim_lcd	:=	20;
					end if;
		when	20	=>	lcd <= "010"&mesaj(m)(7 downto 4);
					if (sayac=com_ds/10) then
						adim_lcd	:=	21;
					end if;
		when	21	=>	lcd <= "110"&mesaj(m)(3 downto 0);
					if (sayac=3*com_ds/20) then
						adim_lcd	:=	22;
					end if;
		when	22	=>	lcd <= "010"&mesaj(m)(3 downto 0);
					if (sayac=com_ds) then
						adim_lcd	:=	23;
					end if;
		when	23	=>	if (m<7) then
						m:=m+1;
						adim_lcd	:=	19;
						sayac:=0;
						else
						m:=0;	
						adim_lcd:=11;
						sayac:=0;
						i:=0;
						counter3:=0;
						counter4:=0;
						counter5<="0000000000000000";
						end if;
	           end case;
	       end case;
        end if;
    end process;
end Behavioral;