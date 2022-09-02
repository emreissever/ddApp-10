library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity UltrasonicController is
	Port( clk : in std_logic; -- Clock sinyali
	      trig_pin : out  std_logic;-- Modülün Tetikleme (Trigger) pini.	
	      echo_pin : in std_logic; -- Modülün Yankı (Echo) pini.
	      seg : inout std_logic_vector (7 downto 0); -- 7 Segment Display'in (A,B,C,D,E,F,G) 7 bit pinleri
	      an : inout std_logic_vector (3 downto 0); -- 7 Segment Display'in Anot Bacakları
	      led : out std_logic_vector (11 downto 0) ); -- LED
end UltrasonicController;

architecture Behavioral of UltrasonicController is
    signal trigger : std_logic ;
    signal echo : std_logic ; 
begin
	
	process(clk,trigger,echo,echo_pin)
        variable counter_trig:integer range 0 to 100000000:=0; -- 10us Tetikleme Sinyali Sayacı
        variable counter_timer:integer range 0 to 100000000:=0;-- Echo bacağının high seviyede kalma süresini ölçmeye yarayan sayaç.
        variable anot_counter: unsigned (16 downto 0):=(others=>'0'); --7 Segment Anot Tarama için clock bölücü
        variable i: unsigned (11 downto 0):=(others=>'0'); -- Uzaklık için her 1 cm'de artan sayaç.
        variable i_temp: unsigned (11 downto 0):=(others=>'0'); -- Geçici olarak uzaklığı kaydeden değişken.   
        variable i_bcd: unsigned (11 downto 0):=(others=>'0'); -- 7 Parçalı Göstergede uzaklığı BCD olarak tutmaya yarayan değişken.
	begin

		if rising_edge(clk) then
			echo<=echo_pin;
		end if;

		-- 7 Parçalı Göstergenin Anot Bacakları
		if rising_edge(clk) then
			anot_counter:=anot_counter+1;
		end if;
		case (std_logic_vector'(anot_counter(16),anot_counter(15))) is
			when"00"=> an<="1110";
			when"01"=> an<="1101";
			when"10"=> an<="1011";
			when others=> an<="0111";
		end case;

        -- Tetikleme sinyali için periyot oluşturuluyor.
		if rising_edge (clk) then
			if(counter_trig=6000000) then 
				counter_trig:=0;
			else
				counter_trig:=counter_trig+1;
			end if;
		end if;
		
        -- 10us Tetikleme Sinyali Oluşturuluyor.
		if rising_edge (clk) then
			if (counter_trig<1000) then 
				trig_pin<='1';
			else
				trig_pin<='0';
			end if;
		end if;
			
		if rising_edge (clk) then
			if ( echo='1') then
				if (counter_timer=5882) then -- Ses hızının 2 Cm yol alması için gerekli süre = 58,824 µs.
					counter_timer:=0;
					i:=i+1; -- Her 58,824 µs için mesafe +1 Cm yapılır. 
					i_temp:=i; -- 7 Parçalı Göstergeye yazdırmak için uzaklık geçici olarak tutulur.
				else
					counter_timer:=counter_timer+1;
				end if;
			end if;
						
			if( echo='0') then
				i:="000000000000"; 
			end if;
		end if;
		
		if rising_edge (clk) then					
			-- Uzaklığa göre kademeli olarak LEDler yakılır. 
				if i_temp<"000000000101" then     --5
					led<="000000000001";
				elsif i_temp<"000000001010" then  --10
					led<="000000000011";
				elsif i_temp<"000000001111" then  --15
					led<="000000000111";
				elsif i_temp<"000000010100" then  --20
					led<="000000001111";
				elsif i_temp<"000000011001" then  --25
					led<="000000011111";
				elsif i_temp<"000000011110" then  --30
					led<="000000111111";
				elsif i_temp<"000000100011" then  --35
					led<="000001111111";
				elsif i_temp<"000000101000" then  --40
					led<="000011111111";
				elsif i_temp<"000000101101" then  --45
                    led<="000111111111";
                elsif i_temp<"000000110010" then  --50
                    led<="001111111111";
                elsif i_temp<"000000110111" then  --55
                    led<="011111111111";
                elsif i_temp<"000000111100" then  --60
                    led<="111111111111";
				else 
					led<="111111111111"; -- Farklı bir ölçümde bütün ledler yakılır. (Aynı zamanda hata tespiti olarak kullanılabilir.)
				end if;			
		end if;	
			
		-- Binary To BCD Algoritması Kullanıldı. (Double dabble Algoritması)
        if i_temp<"000000001010" then -- <10
        i_bcd:=i_temp;
        elsif i_temp<"000000010100" then -- <20
        i_bcd:=i_temp+6;
        elsif i_temp<"000000011110" then -- <30
        i_bcd:=i_temp+12;
        elsif i_temp<"000000101000"then -- <40
        i_bcd:=i_temp+18;
        elsif i_temp<"000000110010"then -- <50
        i_bcd:=i_temp+24;
        elsif i_temp<"000000111100" then -- <60
        i_bcd:=i_temp+30;
        elsif i_temp<"000001000110" then -- <70
        i_bcd:=i_temp+36;
        elsif i_temp<"000001010000" then -- <80
        i_bcd:=i_temp+42;
        elsif i_temp<"000001011010"then -- <90
        i_bcd:=i_temp+48;
        elsif i_temp<"000001100100"then -- <100 
        i_bcd:=i_temp+54;
        else
        i_bcd:="100010001000";
        end if;

		-- 7 Parçalı Gösterge Yazdırma İşemi
		if an="1110" then --anot0
			case (i_bcd(3 downto 0)) is
		  		when"0000"=> seg<="11000000";
		  		when"0001"=> seg<="11111001";
				when"0010"=> seg<="10100100";
				when"0011"=> seg<="10110000";
				when"0100"=> seg<="10011001";
				when"0101"=> seg<="10010010";
				when"0110"=> seg<="10000010";
				when"0111"=> seg<="11111000";
				when"1000"=> seg<="10000000";
				when others=>seg<="10010000";
			end case;
		end if;

		if an="1101" then --anot1 
			case (i_bcd(7 downto 4)) is
				when"0000"=> seg<="11000000";
				when"0001"=> seg<="11111001";
				when"0010"=> seg<="10100100";
				when"0011"=> seg<="10110000";
				when"0100"=> seg<="10011001";
				when"0101"=> seg<="10010010";
				when"0110"=> seg<="10000010";
				when"0111"=> seg<="11111000";
				when"1000"=> seg<="10000000";
				when others=>seg<="10010000";
			end case;
		end if;

		if an="1011" then --anot2 
			case (i_bcd(11 downto 8)) is
				when"0000"=> seg<="11000000";
				when"0001"=> seg<="11111001";
				when"0010"=> seg<="10100100";
				when"0011"=> seg<="10110000";
				when"0100"=> seg<="10011001";
				when"0101"=> seg<="10010010";
				when"0110"=> seg<="10000010";
				when"0111"=> seg<="11111000";
				when"1000"=> seg<="10000000";
				when others=>seg<="10010000";
			end case;
		end if;

		--Zaten en fazla 3 basamaklı bir sayı olabilir. 
		if an="0111" then -- anot3  
			seg<="11111111"; 
		end if;

	end process;
end Behavioral;

