set_property SRC_FILE_INFO {cfile:c:/Users/hamas/Documents/Carleton/ELEC3500/Lab9/Audio/lab9_v2/lab9_v2.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc rfile:../../../lab9_v2.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc id:1 order:EARLY scoped_inst:inst} [current_design]
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1]] 0.1
