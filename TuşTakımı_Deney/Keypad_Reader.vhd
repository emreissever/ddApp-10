library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity Keypad_Reader is
port (
   clock       : in  std_logic;
   RST         : in  std_logic;

   sutun       : out std_logic_vector(3 downto 0);
   satir       : in  std_logic_vector(3 downto 0);

   anot        : out std_logic_vector(3 downto 0);
   led         : out std_logic_vector(6 downto 0)
);
end Keypad_Reader;

architecture Behavioral of Keypad_Reader is
   signal okunan_karakter  :  std_logic_vector(3 downto 0);
   signal counter          :  unsigned(26 downto 0);

   signal hata             : std_logic;  

   signal satir_data_buf   : std_logic_vector(3 downto 0);
   signal satir_data_buf2  : std_logic_vector(3 downto 0);
   signal satir_data_buf3  : std_logic_vector(3 downto 0);
   signal satir_data_buf4  : std_logic_vector(3 downto 0);
   signal satir_data_temiz : std_logic_vector(3 downto 0);
begin

PROCESS(rst,clock)
BEGIN
   if rst='0' then
      counter           <= (OTHERS=>'0');
      okunan_karakter   <= (OTHERS=>'0');
      sutun			      <= (OTHERS=>'0');
      led				   <= (OTHERS=>'0');
      anot				   <= (OTHERS=>'0');

      satir_data_buf	   <= (OTHERS=>'0');
      satir_data_buf2	<= (OTHERS=>'0');
      satir_data_buf3	<= (OTHERS=>'0');
      satir_data_buf4	<= (OTHERS=>'0');
      satir_data_temiz	<= (OTHERS=>'0');

   elsif rising_edge(clock) then
      counter           <= counter+1;
      satir_data_buf	   <= satir;
      satir_data_buf2	<= satir_data_buf;	
      satir_data_buf3	<= satir_data_buf2;	
      satir_data_buf4	<= satir_data_buf3;
      
      -- Debouncing Algoritması, Mekanik Gürültüler İçin
      if (satir_data_buf4  = 	satir_data_buf3   and 
         satir_data_buf4   =	satir_data_buf2   and 
         satir_data_buf4   =	satir_data_buf    and 
         satir_data_buf4   =	satir)
      then
         satir_data_temiz<=satir_data_buf4;
      end if;

      case (std_logic_vector'(counter(16),counter(15), counter(14))) is
      when"000" => sutun<="0001"; --Sütün 1 Araması
         case(satir_data_temiz) is
            when"0001"  => hata<='0'; okunan_karakter<="0001"; --1
            when"0010"  => hata<='0'; okunan_karakter<="0100"; --4
            when"0100"  => hata<='0'; okunan_karakter<="0111"; --7
            when"1000"  => hata<='0'; okunan_karakter<="1110"; --*
            when others => hata<='1';  
         end case;
      when"001" => sutun<="0000";	
      when"010" => sutun<="0010"; --Sütün 2 Araması
         case(satir_data_temiz) is
            when"0001" => hata<='0'; okunan_karakter<="0010";  --2
            when"0010" => hata<='0'; okunan_karakter<="0101";  --5
            when"0100" => hata<='0'; okunan_karakter<="1000";  --8
            when"1000" => hata<='0'; okunan_karakter<="0000";  --0
            when others =>hata<='1'; 
         end case;
      when"011" => sutun<="0000";		
      when"100" => sutun<="0100"; --Sütün 3 Araması
         case(satir_data_temiz) is
            when"0001" => hata<='0' ; okunan_karakter<="0011";  --3
            when"0010" => hata<='0' ; okunan_karakter<="0110";  --6
            when"0100" => hata<='0' ; okunan_karakter<="1001";  --9
            when"1000" => hata<='0' ; okunan_karakter<="1111";  --#
            when others =>hata<='1' ; 
         end case;
      when"101" => sutun<="0000";	
      when"110" => sutun<="1000"; --Sütün 4 Araması
         case(satir_data_temiz) is
            when"0001" => hata<='0' ; okunan_karakter<="1010";  --A
            when"0010" => hata<='0' ; okunan_karakter<="1011";  --B
            when"0100" => hata<='0' ; okunan_karakter<="1100";  --C
            when"1000" => hata<='0' ; okunan_karakter<="1101";  --D
            when others =>hata<='1' ;
         end case;
      when OTHERS => sutun<="0000";		
      end case;

      anot<="1110" ;

      if hata = '0' then
         case (okunan_karakter) is
            when "0000" => led   <="1000000"; -- 0
            when "0001" => led   <="1111001"; -- 1
            when "0010" => led   <="0100100"; -- 2
            when "0011" => led   <="0110000"; -- 3
            when "0100" => led   <="0011001"; -- 4
            when "0101" => led   <="0010010"; -- 5
            when "0110" => led   <="0000010"; -- 6
            when "0111" => led   <="1111000"; -- 7
            when "1000" => led   <="0000000"; -- 8
            when "1001" => led   <="0010000"; -- 9
            when "1010" => led   <="0001000"; -- A
            when "1011" => led   <="0000011"; -- b
            when "1100" => led   <="1000110"; -- C
            when "1101" => led   <="0100001"; -- d
            when "1111" => led   <="0000110"; -- E (#)
            when "1110" => led   <="0001110"; -- F (*)
            when others => led   <="0010000";
         end case;
      end if;
   end if;
END PROCESS;
end Behavioral;
