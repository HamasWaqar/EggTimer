-- Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2016.3 (win64) Build 1682563 Mon Oct 10 19:07:27 MDT 2016
-- Date        : Wed Apr 14 00:53:44 2021
-- Host        : DESKTOP-V2DGADJ running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub {c:/Users/hamas/Documents/Carleton/ELEC3500/Lab9/Microphone -
--               v2/lab9_v2/lab9_v2.srcs/sources_1/ip/dft_0/dft_0_stub.vhdl}
-- Design      : dft_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dft_0 is
  Port ( 
    CLK : in STD_LOGIC;
    XN_RE : in STD_LOGIC_VECTOR ( 7 downto 0 );
    XN_IM : in STD_LOGIC_VECTOR ( 7 downto 0 );
    FD_IN : in STD_LOGIC;
    FWD_INV : in STD_LOGIC;
    SIZE : in STD_LOGIC_VECTOR ( 5 downto 0 );
    RFFD : out STD_LOGIC;
    XK_RE : out STD_LOGIC_VECTOR ( 7 downto 0 );
    XK_IM : out STD_LOGIC_VECTOR ( 7 downto 0 );
    BLK_EXP : out STD_LOGIC_VECTOR ( 3 downto 0 );
    FD_OUT : out STD_LOGIC;
    DATA_VALID : out STD_LOGIC
  );

end dft_0;

architecture stub of dft_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "CLK,XN_RE[7:0],XN_IM[7:0],FD_IN,FWD_INV,SIZE[5:0],RFFD,XK_RE[7:0],XK_IM[7:0],BLK_EXP[3:0],FD_OUT,DATA_VALID";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "dft_v4_0_12,Vivado 2016.3";
begin
end;
