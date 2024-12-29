
# Clock signal
set_property PACKAGE_PIN W5 [get_ports CLOCK]							
	set_property IOSTANDARD LVCMOS33 [get_ports CLOCK]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports CLOCK]
	


#Sch name = JB1
set_property PACKAGE_PIN A14 [get_ports {KATOT[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {KATOT[7]}]
#Sch name = JB2
set_property PACKAGE_PIN A16 [get_ports {KATOT[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {KATOT[6]}]
#Sch name = JB3
set_property PACKAGE_PIN B15 [get_ports {KATOT[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {KATOT[5]}]
#Sch name = JB4
set_property PACKAGE_PIN B16 [get_ports {KATOT[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {KATOT[4]}]


#Sch name = JB7
set_property PACKAGE_PIN A15 [get_ports {KATOT[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {KATOT[3]}]
#Sch name = JB8
set_property PACKAGE_PIN A17 [get_ports {KATOT[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {KATOT[2]}]
#Sch name = JB9
set_property PACKAGE_PIN C15 [get_ports {KATOT[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {KATOT[1]}]
#Sch name = JB10 
set_property PACKAGE_PIN C16 [get_ports {KATOT[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {KATOT[0]}]


#Pmod Header JC
#Sch name = JC1
set_property PACKAGE_PIN K17 [get_ports {DS}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {DS}]
#Sch name = JC2
set_property PACKAGE_PIN M18 [get_ports {OE}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {OE}]
#Sch name = JC3
set_property PACKAGE_PIN N17 [get_ports {ST_CP}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {ST_CP}]
#Sch name = JC4
set_property PACKAGE_PIN P18 [get_ports {SH_CP}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SH_CP}]
#Sch name = JC7
set_property PACKAGE_PIN L17 [get_ports {reset}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {reset}]


