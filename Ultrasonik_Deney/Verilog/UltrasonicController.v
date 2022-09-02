`timescale 1ns / 1ps

module UltrasonicController
(
    input clk, 

    output reg us_trig_pin,
    input  us_echo_pin,

    output reg [6:0]  seg,
    output reg [3:0]  an,
    output reg [11:0] led 
);

reg echo ;
reg trigger ;

// Bu değerlerin maks min değerlerini yaz kardeşim 
reg [31:0] trig_counter = 0; 
reg [31:0] timer_counter = 0; 
reg [11:0] i = 0 ; 
reg [11:0] i_temp = 0;
reg [11:0] i_bcd ;

reg [16:0] anot_counter = 0; 
reg [1:0]  anot_indicator ; 

//assign led = i_temp; 

always @(posedge clk) begin

    anot_counter <= anot_counter + 1;

    case (anot_counter[16:15])
        2'b00 : an <= 4'b1110;
        2'b01 : an <= 4'b1101;
        2'b10 : an <= 4'b1011;
        default : an <= 4'b0111;
    endcase


    echo <= us_echo_pin;
    //
    if (trig_counter == 6000000) begin // Tetikleme Sinyali Periyot
        trig_counter <= 0;
    end
    else begin
        trig_counter <= trig_counter + 1; 
    end
        //
    if(trig_counter < 1000) begin // 10 us Tetikleme Sinyali
        us_trig_pin <= 1;
    end
    else begin
        us_trig_pin <= 0;
    end

    if(us_echo_pin == 1) begin
        if (timer_counter == 5882) begin
            timer_counter <= 0; 
            i <= i + 1; 
            i_temp <= i;
        end
        else begin
            timer_counter <= timer_counter + 1;
        end 
    end

    if(us_echo_pin == 0) begin
        i <= 0 ; 
    end

    // Uzaklık verisine göre kademeli olarak Basys3 üzerinde LED'ler yakılır
    if      (i_temp < 5)  led <= 12'b000000000001; 
    else if (i_temp < 10) led <= 12'b000000000011;
    else if (i_temp < 15) led <= 12'b000000000111;
    else if (i_temp < 20) led <= 12'b000000001111;
    else if (i_temp < 25) led <= 12'b000000011111;
    else if (i_temp < 30) led <= 12'b000000111111;
    else if (i_temp < 35) led <= 12'b000001111111;
    else if (i_temp < 40) led <= 12'b000011111111;
    else if (i_temp < 45) led <= 12'b000111111111;
    else if (i_temp < 50) led <= 12'b001111111111;
    else if (i_temp < 55) led <= 12'b011111111111;
    else                  led <= 12'b111111111111;
    
    // Uzaklık değerlerini 7 Parçalı Göstergeye (7 Segment Display) yazdırmak için
    // Binary sayıları BCD'ye çeviren algoritmanın uygulanması 
    if (i_temp < 10)       i_bcd <= i_temp; 
    else if (i_temp < 20)  i_bcd <= i_temp;
    else if (i_temp < 30)  i_bcd <= i_temp;
    else if (i_temp < 40)  i_bcd <= i_temp;
    else if (i_temp < 50)  i_bcd <= i_temp;
    else if (i_temp < 60)  i_bcd <= i_temp;
    else if (i_temp < 70)  i_bcd <= i_temp;
    else if (i_temp < 80)  i_bcd <= i_temp;
    else if (i_temp < 90)  i_bcd <= i_temp;
    else if (i_temp < 100) i_bcd <= i_temp;
    else                   i_bcd <= 12'b100010001000;

    // 7
    if (an == 4'b1110) begin
        case(i_bcd[3:0])
            4'b0000 : seg <= 7'b1000000;
            4'b0001 : seg <= 7'b1111001;
            4'b0010 : seg <= 7'b0100100;
            4'b0011 : seg <= 7'b0110000;
            4'b0100 : seg <= 7'b0011001;
            4'b0101 : seg <= 7'b0010010;
            4'b0110 : seg <= 7'b0000010;
            4'b0111 : seg <= 7'b1111000;
            4'b1000 : seg <= 7'b0000000;
            default : seg <= 7'b0010000;
        endcase
    end

    if (an == 4'b1101) begin
        case(i_bcd[7:4])
            4'b0000 : seg <= 7'b1000000;
            4'b0001 : seg <= 7'b1111001;
            4'b0010 : seg <= 7'b0100100;
            4'b0011 : seg <= 7'b0110000;
            4'b0100 : seg <= 7'b0011001;
            4'b0101 : seg <= 7'b0010010;
            4'b0110 : seg <= 7'b0000010;
            4'b0111 : seg <= 7'b1111000;
            4'b1000 : seg <= 7'b0000000;
            default : seg <= 7'b0010000;
        endcase
    end

    if (an == 4'b1011) begin
        case(i_bcd[11:8])
            4'b0000 : seg <= 7'b1000000;
            4'b0001 : seg <= 7'b1111001;
            4'b0010 : seg <= 7'b0100100;
            4'b0011 : seg <= 7'b0110000;
            4'b0100 : seg <= 7'b0011001;
            4'b0101 : seg <= 7'b0010010;
            4'b0110 : seg <= 7'b0000010;
            4'b0111 : seg <= 7'b1111000;
            4'b1000 : seg <= 7'b0000000;
            default : seg <= 7'b0010000;
        endcase
    end

    if (an == 4'b0111) begin
        seg <= 7'b1111111;
    end
end
endmodule
