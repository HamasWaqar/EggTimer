// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.3 (win64) Build 1682563 Mon Oct 10 19:07:27 MDT 2016
// Date        : Wed Apr 14 00:53:44 2021
// Host        : DESKTOP-V2DGADJ running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub {c:/Users/hamas/Documents/Carleton/ELEC3500/Lab9/Microphone -
//               v2/lab9_v2/lab9_v2.srcs/sources_1/ip/dft_0/dft_0_stub.v}
// Design      : dft_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dft_v4_0_12,Vivado 2016.3" *)
module dft_0(CLK, XN_RE, XN_IM, FD_IN, FWD_INV, SIZE, RFFD, XK_RE, 
  XK_IM, BLK_EXP, FD_OUT, DATA_VALID)
/* synthesis syn_black_box black_box_pad_pin="CLK,XN_RE[7:0],XN_IM[7:0],FD_IN,FWD_INV,SIZE[5:0],RFFD,XK_RE[7:0],XK_IM[7:0],BLK_EXP[3:0],FD_OUT,DATA_VALID" */;
  input CLK;
  input [7:0]XN_RE;
  input [7:0]XN_IM;
  input FD_IN;
  input FWD_INV;
  input [5:0]SIZE;
  output RFFD;
  output [7:0]XK_RE;
  output [7:0]XK_IM;
  output [3:0]BLK_EXP;
  output FD_OUT;
  output DATA_VALID;
endmodule
