library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity STEPPER_MOTOR is
    Port (
        CLOCK     : in  STD_LOGIC;                -- 100MHz
        HIZLANDIR : in  STD_LOGIC;
        STOP      : in  STD_LOGIC;
        DONDUR    : in  STD_LOGIC;
        BOBIN     : out STD_LOGIC_VECTOR (3 downto 0)
    );
end STEPPER_MOTOR;

architecture Behavioral of STEPPER_MOTOR is
    signal A : STD_LOGIC;
    signal B : STD_LOGIC;
    signal C : STD_LOGIC;
begin
    process(CLOCK, HIZLANDIR, A, B, C, DONDUR, STOP)
        variable counter   : unsigned(19 downto 0);
        variable counter_v : unsigned(1 downto 0);
    begin
        if rising_edge(CLOCK) then                 -- Eğer clock sinyali 0'dan 1'e geçiyorsa
            counter := counter + 1;                -- counter'ın değerini 1 artırır.
        end if;
        A <= counter(17);                          -- Hızlı clock olarak A sinyalini atar.
        C <= counter(19);                          -- Yavaş clock olarak C sinyalini atar.

        if HIZLANDIR = '1' then                    -- Eğer hızlandırma anahtarı açıksa,
            B <= A;                                -- hızlı clock aktif olur (A sinyali),
        elsif HIZLANDIR = '0' then                 -- yoksa normal clock aktif olur.
            B <= C;
        end if;

        if rising_edge(B) and STOP = '0' then      -- Normal clock sinyali 0'dan 1'e geçiyorsa
            counter_v := counter_v + 1;            -- counter_v 1 artar.
        end if;

        if DONDUR = '0' then                       -- Döndürme anahtarının durumuna göre
            case counter_v is                      -- motorun hangi yönde döneceği belli olur.
               when "00" => BOBIN <="0011";
               when "01" => BOBIN <="1010";
               when "10" => BOBIN <="1100";
               when "11" => BOBIN <="0101";
            end case;
        elsif DONDUR = '1' then
            case counter_v is
               when "11" => BOBIN <="0011";
               when "10" => BOBIN <="1010";
               when "01" => BOBIN <="1100";
               when "00" => BOBIN <="0101";
            end case;
        end if;
    end process;
end Behavioral;
