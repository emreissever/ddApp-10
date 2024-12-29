# Clock signal
set_property PACKAGE_PIN W5 [get_ports CLK]							
	set_property IOSTANDARD LVCMOS33 [get_ports CLK]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports CLK]

# LEDs
set_property PACKAGE_PIN U16 [get_ports {LED}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED}]
 
# Sch name = JC9
set_property PACKAGE_PIN P17 [get_ports {BT_UART_RXD}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {BT_UART_RXD}]
# Sch name = JC10
set_property PACKAGE_PIN R18 [get_ports {BT_UART_TXD}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {BT_UART_TXD}]
