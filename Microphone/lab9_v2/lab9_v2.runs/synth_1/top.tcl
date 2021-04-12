# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/hamas/Documents/Carleton/ELEC3500/Lab9/Microphone/lab9_v2/lab9_v2.cache/wt [current_project]
set_property parent.project_path C:/Users/hamas/Documents/Carleton/ELEC3500/Lab9/Microphone/lab9_v2/lab9_v2.xpr [current_project]
set_property XPM_LIBRARIES XPM_CDC [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part digilentinc.com:nexys-a7-100t:part0:1.0 [current_project]
set_property ip_output_repo c:/Users/hamas/Documents/Carleton/ELEC3500/Lab9/Microphone/lab9_v2/lab9_v2.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files -quiet c:/Users/hamas/Documents/Carleton/ELEC3500/Lab9/Microphone/lab9_v2/lab9_v2.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.dcp
set_property used_in_implementation false [get_files c:/Users/hamas/Documents/Carleton/ELEC3500/Lab9/Microphone/lab9_v2/lab9_v2.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.dcp]
read_verilog -library xil_defaultlib C:/Users/hamas/Documents/Carleton/ELEC3500/Lab9/Microphone/lab9_v2/lab9_v2.srcs/sources_1/imports/hdl/top.v
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/hamas/Documents/Carleton/ELEC3500/Lab9/Microphone/lab9_v2/lab9_v2.srcs/constrs_1/imports/constraints/Nexys-A7-100T-Master.xdc
set_property used_in_implementation false [get_files C:/Users/hamas/Documents/Carleton/ELEC3500/Lab9/Microphone/lab9_v2/lab9_v2.srcs/constrs_1/imports/constraints/Nexys-A7-100T-Master.xdc]


synth_design -top top -part xc7a100tcsg324-1


write_checkpoint -force -noxdef top.dcp

catch { report_utilization -file top_utilization_synth.rpt -pb top_utilization_synth.pb }
