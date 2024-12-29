----------------------------------------------------------------------------------
-- Company: 



--DOT MATRIX DENEYÝ--UYGULAMA 2--
--8*8 RGB DOT MATRIX MODÜLÜ KULLANILARAK
--EKRANA GÖRÜNTÜ BASILMIÞTIR.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;


entity rgb is
port(
			  CLOCK : in  STD_LOGIC;--50 MHz
         
			  OE:inout std_logic;--output enable
			  
			  SH_CP:OUT STD_LOGIC;--shift register clock pulse
			  ST_CP:OUT STD_LOGIC;--store register clock pulse
			  
			  reset:OUT STD_LOGIC;--shift register için reset

			  
				DS : out  std_logic;--digital signal
			  
           KATOT : out  STD_LOGIC_VECTOR (7 downto 0));
end RGB;

architecture Behavioral of rgb is


signal mesaj:std_logic_vector(24 downto 1);
alias kýrmýzý : Std_Logic_Vector(7 downto 0) is mesaj(24 downto 17) ;
alias yesil : Std_Logic_Vector(7 downto 0) is mesaj(16 downto 9) ;
alias mavi : Std_Logic_Vector(7 downto 0) is mesaj(8 downto 1) ;

signal f:std_logic;
signal e:std_logic;

begin

process(clock)

variable counter: unsigned(7 downto 0);
variable i:integer range 410 downto 1:=1;--data signalin seri olarak iletilmesini kontrol eder.
variable a:integer range 7 downto 0:=0;
variable d:integer range 800 downto 0:=0;

begin


if rising_edge(clock) then--registerlar için clock üretmek için kullanýlýyor.
counter:=counter+1;
end if;


f<=counter(7);--shift register için saat sinyali
e<=not f;


if rising_edge(e) then--seri olarak datayý almak için her clock pulse tan sonra i bir arttýrýlýyor.
i:=i+1;
end if;


if i<4 then---baþlangýçta i 4'e gelene kadar sisteme reset atýlýr.
reset<='0';
else
reset<='1';
end if;


if i>3 and i<28 then--4'le 27 arasýnda data akýþý seri olarak.
DS<=mesaj(i-3);
else 
DS<='0';
end if;


if i<28 then--i 28'e geldiðinde data akýþý datamlanýyor.24 bit data alýnmýþ oluyor. bu sureden sonra clock durduluyor yeni data akýþýna kadar.
SH_CP<=f;             
ST_CP<=e;
else
SH_CP<='0';
ST_CP<='1';
end if;

if rising_edge(f) then--clock un durduðu surede OE=0 yani output registerin çýkýþýnda aktif durumda.
if (i>28 and i<409) then
oe<='0';
else
oe<='1';
end if;
end if;


if rising_edge(f) then--bir satýr tamamlandýðýnda a bir arttýrýlýyor 2. satýra geçmek için.
if i=410 then
a:=a+1;
end if;
end if;

if rising_edge(f) then--satrlar ve sutunlar tamamlandýðýnda yeni görüntü için(ful ekran) d bir arttýrýlýyor.
if i=410 then
if a=7 then
d:=d+1;
end if;
end if;
end if;

--a katotlarý taramak için kullanýlýyor.
		
if a=0 then
katot<="10000000";
elsif a=1 then
katot<="01000000";
elsif a=2 then
katot<="00100000";
elsif a=3 then
katot<="00010000";
elsif a=4 then
katot<="00001000";
elsif a=5 then
katot<="00000100";
elsif a=6 then
katot<="00000010";
else
katot<="00000001";
end if;


		if d<25 then--en dýþa mavi kare oluþturur.(d 50'ye gelene kadar ekranda gösterilecek þekil yaratýlýyor.

if a=0 then

kýrmýzý<="00000000";
mavi<="11111111";
yesil<="00000000";

elsif a=1 then

kýrmýzý<="00000000";
mavi<="10000001";
yesil<="00000000";

elsif a=2 then

kýrmýzý<="00000000";
mavi<="10000001";
yesil<="00000000";

elsif a=3 then

kýrmýzý<="00000000";
mavi<="10000001";
yesil<="00000000";

elsif a=4 then

kýrmýzý<="00000000";
mavi<="10000001";
yesil<="00000000";

elsif a=5 then

kýrmýzý<="00000000";
mavi<="10000001";
yesil<="00000000";

elsif a=6 then

kýrmýzý<="00000000";
mavi<="10000001";
yesil<="00000000";

else

kýrmýzý<="00000000";
mavi<="11111111";
yesil<="00000000";

end if;

		elsif d<50 then

if a=0 then

kýrmýzý<="00000000";
mavi<="11111111";
yesil<="00000000";

elsif a=1 then

kýrmýzý<="01111110";
mavi<="10000001";
yesil<="00000000";

elsif a=2 then

kýrmýzý<="01000010";
mavi<="10000001";
yesil<="00000000";

elsif a=3 then

kýrmýzý<="01000010";
mavi<="10000001";
yesil<="00000000";

elsif a=4 then

kýrmýzý<="01000010";
mavi<="10000001";
yesil<="00000000";

elsif a=5 then

kýrmýzý<="01000010";
mavi<="10000001";
yesil<="00000000";

elsif a=6 then

kýrmýzý<="01111110";
mavi<="10000001";
yesil<="00000000";

else

kýrmýzý<="00000000";
mavi<="11111111";
yesil<="00000000";

end if;
		
		elsif d<75 then
		
if a=0 then

kýrmýzý<="00000000";
mavi<="11111111";
yesil<="00000000";

elsif a=1 then

kýrmýzý<="01111110";
mavi<="10000001";
yesil<="00000000";

elsif a=2 then

kýrmýzý<="01000010";
mavi<="10000001";
yesil<="00111100";

elsif a=3 then

kýrmýzý<="01000010";
mavi<="10000001";
yesil<="00100100";

elsif a=4 then

kýrmýzý<="01000010";
mavi<="10000001";
yesil<="00100100";

elsif a=5 then

kýrmýzý<="01000010";
mavi<="10000001";
yesil<="00111100";

elsif a=6 then

kýrmýzý<="01111110";
mavi<="10000001";
yesil<="00000000";

else

kýrmýzý<="00000000";
mavi<="11111111";
yesil<="00000000";

end if;

		elsif d<100 then
		
if a=0 then

kýrmýzý<="00000000";
mavi<="11111111";
yesil<="00000000";

elsif a=1 then

kýrmýzý<="01111110";
mavi<="10000001";
yesil<="00000000";

elsif a=2 then

kýrmýzý<="01000010";
mavi<="10000001";
yesil<="00111100";

elsif a=3 then

kýrmýzý<="01011010";
mavi<="10011001";
yesil<="00111100";

elsif a=4 then

kýrmýzý<="01011010";
mavi<="10011001";
yesil<="00111100";

elsif a=5 then

kýrmýzý<="01000010";
mavi<="10000001";
yesil<="00111100";

elsif a=6 then

kýrmýzý<="01111110";
mavi<="10000001";
yesil<="00000000";

else

kýrmýzý<="00000000";
mavi<="11111111";
yesil<="00000000";

end if;




		elsif d<125 then--ortadaki kare sönük
	
if a=0 then

kýrmýzý<="00000000";
mavi<="11111111";
yesil<="00000000";

elsif a=1 then

kýrmýzý<="01111110";
mavi<="10000001";
yesil<="00000000";

elsif a=2 then

kýrmýzý<="01000010";
mavi<="10000001";
yesil<="00111100";

elsif a=3 then

kýrmýzý<="01000010";
mavi<="10000001";
yesil<="00100100";

elsif a=4 then

kýrmýzý<="01000010";
mavi<="10000001";
yesil<="00100100";

elsif a=5 then

kýrmýzý<="01000010";
mavi<="10000001";
yesil<="00111100";

elsif a=6 then

kýrmýzý<="01111110";
mavi<="10000001";
yesil<="00000000";

else

kýrmýzý<="00000000";
mavi<="11111111";
yesil<="00000000";

end if;

		elsif d<150 then--kýrmýzý+yeþil
	
if a=0 then

kýrmýzý<="00000000";
mavi<="11111111";
yesil<="00000000";

elsif a=1 then

kýrmýzý<="01111110";
mavi<="10000001";
yesil<="00000000";

elsif a=2 then

kýrmýzý<="01000010";
mavi<="10000001";
yesil<="00111100";

elsif a=3 then

kýrmýzý<="01011010";
mavi<="10000001";
yesil<="00111100";

elsif a=4 then

kýrmýzý<="01011010";
mavi<="10000001";
yesil<="00111100";

elsif a=5 then

kýrmýzý<="01000010";
mavi<="10000001";
yesil<="00111100";

elsif a=6 then

kýrmýzý<="01111110";
mavi<="10000001";
yesil<="00000000";

else

kýrmýzý<="00000000";
mavi<="11111111";
yesil<="00000000";

end if;

		elsif d<175 then--mavi+kýrmýzý
	
if a=0 then

kýrmýzý<="00000000";
mavi<="11111111";
yesil<="00000000";

elsif a=1 then

kýrmýzý<="01111110";
mavi<="10000001";
yesil<="00000000";

elsif a=2 then

kýrmýzý<="01000010";
mavi<="10000001";
yesil<="00111100";

elsif a=3 then

kýrmýzý<="01011010";
mavi<="10011001";
yesil<="00100100";

elsif a=4 then

kýrmýzý<="01011010";
mavi<="10011001";
yesil<="00100100";

elsif a=5 then

kýrmýzý<="01000010";
mavi<="10000001";
yesil<="00111100";

elsif a=6 then

kýrmýzý<="01111110";
mavi<="10000001";
yesil<="00000000";

else

kýrmýzý<="00000000";
mavi<="11111111";
yesil<="00000000";

end if;

		elsif d<200 then--yeþil+mavi
	
if a=0 then

kýrmýzý<="00000000";
mavi<="11111111";
yesil<="00000000";

elsif a=1 then

kýrmýzý<="01111110";
mavi<="10000001";
yesil<="00000000";

elsif a=2 then

kýrmýzý<="01000010";
mavi<="10000001";
yesil<="00111100";

elsif a=3 then

kýrmýzý<="01000010";
mavi<="10011001";
yesil<="00111100";

elsif a=4 then

kýrmýzý<="01000010";
mavi<="10011001";
yesil<="00111100";

elsif a=5 then

kýrmýzý<="01000010";
mavi<="10000001";
yesil<="00111100";

elsif a=6 then

kýrmýzý<="01111110";
mavi<="10000001";
yesil<="00000000";

else

kýrmýzý<="00000000";
mavi<="11111111";
yesil<="00000000";

end if;

		elsif ((d>400 and d<420) or (d>440 and d<460) or (d>440 and d<460) or (d>480 and d<500) or (d>520 and d<540)
or (d>560 and d<580) or (d>600))		then--gülen surat

if a=7 then--1.SUTUNU KONTROL EDER

kýrmýzý<="00000100";
mavi<="00000000";
yesil<="00000000";



elsif a=6 then

kýrmýzý<="00001000";
mavi<="00000100";
yesil<="00000000";

elsif a=5 then

kýrmýzý<="00000000";
mavi<="00000010";
yesil<="00100000";

elsif a=4 then

kýrmýzý<="00000001";
mavi<="00000010";
yesil<="00000000";

elsif a=3 then

kýrmýzý<="00000001";
mavi<="00000010";
yesil<="00000000";

elsif a=2 then

kýrmýzý<="00000000";
mavi<="00000010";
yesil<="00100000";

elsif a=1 then

kýrmýzý<="00001000";
mavi<="00000100";
yesil<="00000000";

else

kýrmýzý<="00000100";
mavi<="00000000";
yesil<="00000000";

end if;

		else
	
if a=7 then--1.SUTUNU KONTROL EDER

kýrmýzý<="00000000";
mavi<="00000000";
yesil<="00000000";



elsif a=6 then

kýrmýzý<="00000000";
mavi<="00000100";
yesil<="00000000";

elsif a=5 then

kýrmýzý<="00000000";
mavi<="00000010";
yesil<="00010000";

elsif a=4 then

kýrmýzý<="00000000";
mavi<="00000010";
yesil<="00000000";

elsif a=3 then

kýrmýzý<="00000000";
mavi<="00000010";
yesil<="00000000";

elsif a=2 then

kýrmýzý<="00000000";
mavi<="00000010";
yesil<="00010000";

elsif a=1 then

kýrmýzý<="00000000";
mavi<="00000100";
yesil<="00000000";

else

kýrmýzý<="00000000";
mavi<="00000000";
yesil<="00000000";

end if;
		end if;
		
end process;
end Behavioral;