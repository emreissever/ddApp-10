
# Clock signal
#Bank = 34, Pin name = ,					Sch name = CLK100MHZ
set_property PACKAGE_PIN W5 [get_ports CLOCK]
set_property IOSTANDARD LVCMOS33 [get_ports CLOCK]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports CLOCK]

 
 set_property PACKAGE_PIN V17 [get_ports HIZLANDIR] 
 set_property IOSTANDARD LVCMOS33 [get_ports HIZLANDIR]
 set_property PACKAGE_PIN V16 [get_ports DONDUR]
 set_property IOSTANDARD LVCMOS33 [get_ports DONDUR]
 
 
 ##Pmod Header JB
 #Bank = 15, Pin name = IO_L15N_T2_DQS_ADV_B_15,                Sch name = JB1
 set_property PACKAGE_PIN A14 [get_ports {BOBIN[3]}]
 set_property IOSTANDARD LVCMOS33 [get_ports {BOBIN[3]}]
 #Bank = 14, Pin name = IO_L13P_T2_MRCC_14,                    Sch name = JB2
 set_property PACKAGE_PIN A16 [get_ports {BOBIN[2]}]
 set_property IOSTANDARD LVCMOS33 [get_ports {BOBIN[2]}]
 #Bank = 14, Pin name = IO_L21N_T3_DQS_A06_D22_14,            Sch name = JB3
 set_property PACKAGE_PIN B15 [get_ports {BOBIN[1]}]
 set_property IOSTANDARD LVCMOS33 [get_ports {BOBIN[1]}]
 #Bank = CONFIG, Pin name = IO_L16P_T2_CSI_B_14,                Sch name = JB4
 set_property PACKAGE_PIN B16 [get_ports {BOBIN[0]}]
 set_property IOSTANDARD LVCMOS33 [get_ports {BOBIN[0]}]
 
 #Sch name = JB7
 set_property PACKAGE_PIN A15 [get_ports STOP]                    
     set_property IOSTANDARD LVCMOS33 [get_ports STOP]
 


