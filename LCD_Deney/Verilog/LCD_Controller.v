module LCDController
  (
    input           clk,
    output [3:0]    o_lcd_db,
    output          o_lcd_e,
    output          o_lcd_rs,
    output          o_lcd_rw
  );

    parameter 
    clock           =       100000000,
    ms_15           =       1500000, //0.015*clock
    us_50           =       5000,    // 0.000050*clock
    ms_2            =       200000;  //0.002*clock

  localparam [4:0]

             idle    =   5'b00000,
             step_01 =   5'b00001,
             step_02 =   5'b00010,
             step_03 =   5'b00011,
             step_04 =   5'b00100,
             step_05 =   5'b00101,
             step_06 =   5'b00110,
             step_07 =   5'b00111,
             step_08 =   5'b01000,
             step_09 =   5'b01001,
             step_10 =   5'b01010,
             step_11 =   5'b01011,
             step_12 =   5'b01100,
             step_13 =   5'b01101,
             step_14 =   5'b01110,
             step_15 =   5'b01111,
             step_16 =   5'b10000,
             step_17 =   5'b10001,
             step_18 =   5'b10010,
             step_19 =   5'b10011,
             step_20 =   5'b10100,
             step_21 =   5'b10101,
             step_22 =   5'b10110,
             step_23 =   5'b10111,
             step_24 =   5'b11000,
             step_25 =   5'b11001,
             step_26 =   5'b11010,
             step_27 =   5'b11011,
             step_28 =   5'b11100,
             step_29 =   5'b11101,
             step_30 =   5'b11110;

    reg [3:0]   cols=0;
    reg [4:0]   state=idle;
    reg [23:0]  counter=0;
    reg [6:0]   lcd_state=0;
    reg [7:0]   message [0:12];

    initial begin
        message[0] = 8'h46;  // F
        message[1] = 8'h50;  // P
        message[2] = 8'h47;  // G
        message[3] = 8'h41;  // A
        message[4] = 8'h20;  // 
        message[5] = 8'h64;  // d
        message[6] = 8'h64;  // d
        message[7] = 8'h41;  // A
        message[8] = 8'h70;  // p
        message[9] = 8'h70;  // p
        message[10] = 8'h2d; // -
        message[11] = 8'h31; // 1
        message[12] = 8'h30; // 0 
    end


    assign o_lcd_db = lcd_state[3:0];
    assign o_lcd_e  = lcd_state[6];
    assign o_lcd_rs = lcd_state[5];
    assign o_lcd_rw = lcd_state[4];

  always @(posedge clk)
  begin
    counter<=counter+1;
    case (state)
    //initial time 
    idle:
    begin
      if(counter==ms_15*2)
      begin
        counter<=0;
        state<=step_02;
      end
    end

//-----------------------Set LCD 2x8---------------------------
    
// 001011xx -> Function Set (step 1-4)
    step_01:
      begin
        lcd_state <= 7'b1000010;
        if(counter==ms_2*2)
        begin
          counter<=0;
          state<=step_02;
        end
      end

    step_02:
      begin
        lcd_state <= 7'b0000010;
        if(counter==ms_2*2)
        begin
          counter<=0;
          state<=step_03;
        end
      end

    step_03://
      begin
        lcd_state <= 7'b1001100;
        if(counter==us_50)
        begin
          counter<=0;
          state<=step_04;
        end
      end

    step_04:
      begin
        lcd_state <= 7'b0001100;
        if(counter==us_50)
        begin
          counter<=0;
          state<=step_05;
        end
      end
      
  step_05:
    begin
      lcd_state <= 7'b1001000;
      if(counter==us_50)
      begin
        counter<=0;
        state<=step_06;
      end
    end

  step_06:
      begin
        lcd_state <= 7'b0000010;
        if(counter==us_50)
        begin
          counter<=0;
          state<=step_07;
        end
      end


//----------------------Open LCD set cursor blink----------------------------

    step_07:
      begin
        lcd_state <= 7'b1000000;
        if(counter==us_50)
        begin
          counter<=0;
          state<=step_08;
        end
      end

    step_08:
      begin
        lcd_state <= 7'b0000000;
        if(counter==us_50)
        begin
          counter<=0;
          state<=step_09;
        end
      end

    step_09:
      begin
        lcd_state <= 7'b1001100;
        if(counter==us_50)
        begin
          counter<=0;
          state<=step_10;
        end
      end

    step_10:
      begin
        lcd_state <= 7'b0001100;
        if(counter==us_50)
        begin
          counter<=0;
          state<=step_11;
        end
      end

//---------------------Clear LCD then goto base_addr---------------------

    step_11:
      begin
        lcd_state <= 7'b1000000;
        if(counter==us_50)
        begin
          counter<=0;
          state<=step_12;
        end
      end

    step_12:
      begin
        lcd_state <= 7'b0000000;
        if(counter==us_50)
        begin
          counter<=0;
          state<=step_13;
        end
      end

    step_13:
      begin
        lcd_state <= 7'b1000001;
        if(counter==ms_2)
        begin
          counter<=0;
          state<=step_14;
        end
      end

    step_14:
      begin
        lcd_state <= 7'b0000001;
        if(counter==ms_2)
        begin
          counter<=0;
          state<=step_15;
        end
      end
// ----------------------set adress----------------------------------

    step_15:
      begin
        lcd_state <= 7'b1000000;
        if(counter==us_50)
        begin
          counter<=0;
          state<=step_16;
        end
      end

    step_16:
      begin
        lcd_state <= 7'b0000000;
        if(counter==us_50)
        begin
          counter<=0;
          state<=step_17;
        end
      end

    step_17:
      begin
        lcd_state <= 7'b1000110;
        if(counter==us_50)
        begin
          counter<=0;
          state<=step_18;
        end
      end

    step_18:
      begin
        lcd_state <= 7'b0000110;
        if(counter==us_50)
        begin
          counter<=0;
          state<=step_19;
        end
      end

//-------Print Character-------------------------

    step_19:
      begin
        lcd_state <= {3'b110,message[cols][7:4]};
        if(counter==us_50)
        begin
          counter<=0;
          state<=step_20;
        end
      end

    step_20:
      begin
        lcd_state <= {3'b010,message[cols][7:4]};
        if(counter==us_50)
        begin
          counter<=0;
          state<=step_21;
        end
      end

    step_21:
      begin
        lcd_state <= {3'b110,message[cols][3:0]};
        if(counter==us_50)
        begin
          counter<=0;
          state<=step_22;
        end
      end

    step_22:
      begin
        lcd_state <= {3'b010,message[cols][3:0]};
        if(counter==us_50)
        begin
          counter<=0;
          state<=step_23;
        end
      end

//Rows

    step_23:
      begin
        if(cols==4)begin
          lcd_state<=7'b1001100;
          if(counter==us_50) begin
            state<=step_24;
          end
        end else begin
            state<=step_27;
        end
      end

    step_24:
      begin
        lcd_state <= 7'b0001100;
        if(counter==us_50)
        begin
          counter<=0;
          state<=step_25;
        end
      end

    step_25:
      begin
        lcd_state <= 7'b1000000;
        if(counter==us_50)
        begin
          counter<=0;
          state<=step_26;
        end
      end

    step_26:
      begin
        lcd_state <= 7'b0000000;
        if(counter==us_50)
        begin
          counter<=0;
          state<=step_27;
        end
      end

    step_27:
      begin
        if(cols<12) begin
          cols<=cols+1;
          state<=step_19;
          counter<=0;
        end else begin
          if(cols>14)
          begin
            cols<=0;
          end
          state<=step_27;
          counter<=0;
        end
      end

    endcase
  end

endmodule
