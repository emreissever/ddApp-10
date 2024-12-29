# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]
	
#sw15
set_property PACKAGE_PIN R2 [get_ports rst]					
    set_property IOSTANDARD LVCMOS33 [get_ports rst]
                
# LEDs
set_property PACKAGE_PIN U16 [get_ports {led[0]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
set_property PACKAGE_PIN E19 [get_ports {led[1]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
set_property PACKAGE_PIN U19 [get_ports {led[2]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
set_property PACKAGE_PIN V19 [get_ports {led[3]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
set_property PACKAGE_PIN W18 [get_ports {led[4]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}]
set_property PACKAGE_PIN U15 [get_ports {led[5]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}]
set_property PACKAGE_PIN U14 [get_ports {led[6]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {led[6]}]
set_property PACKAGE_PIN V14 [get_ports {led[7]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {led[7]}]
set_property PACKAGE_PIN V13 [get_ports {led[8]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {led[8]}]
set_property PACKAGE_PIN V3 [get_ports {led[9]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {led[9]}]
set_property PACKAGE_PIN W3 [get_ports {led[10]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {led[10]}]
set_property PACKAGE_PIN U3 [get_ports {led[11]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {led[11]}]
set_property PACKAGE_PIN P3 [get_ports {led[12]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {led[12]}]
set_property PACKAGE_PIN N3 [get_ports {led[13]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {led[13]}]
set_property PACKAGE_PIN P1 [get_ports {led[14]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {led[14]}]
set_property PACKAGE_PIN L1 [get_ports {led[15]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {led[15]}]
    
    
#Pmod Header JC
    #Sch name = JC1
    set_property PACKAGE_PIN K17 [get_ports {spi_ce}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {spi_ce}]
    #Sch name = JC2
    set_property PACKAGE_PIN M18 [get_ports {d_c}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {d_c}]
    #Sch name = JC3
    set_property PACKAGE_PIN N17 [get_ports {rst_lcd}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {rst_lcd}]
    #Sch name = JC4
    set_property PACKAGE_PIN P18 [get_ports {spi_data_out}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {spi_data_out}]
    #Sch name = JC7
    set_property PACKAGE_PIN L17 [get_ports {spi_clk}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {spi_clk}]
#    #Sch name = JC8
#    set_property PACKAGE_PIN M19 [get_ports {LCD_DB[1]}]                    
#        set_property IOSTANDARD LVCMOS33 [get_ports {LCD_DB[1]}]
#    #Sch name = JC9
#    set_property PACKAGE_PIN P17 [get_ports {LCD_DB[0]}]                    
#        set_property IOSTANDARD LVCMOS33 [get_ports {LCD_DB[0]}]
    ###Sch name = JC10
    #set_property PACKAGE_PIN R18 [get_ports {JC[7]}]                    
        #set_property IOSTANDARD LVCMOS33 [get_ports {JC[7]}]
