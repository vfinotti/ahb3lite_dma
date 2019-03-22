///////////////////////////////////////////////////////////////////////////////
// Vitor Finotti
//
// <project-url>
///////////////////////////////////////////////////////////////////////////////
//
// unit name:     AHB3-Lite DMA core
//
// description: DMA core compatible with AHB3-Lite protocol. For simplicity, an
// already existing (and tested) wishbone DMA core was used, and properly
// wrapped with bridges to AHB3-Lite. For the instructions on how to use the
// core, please refer to the original documentation in the DMA submodule.
//
//
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019 Vitor Finotti
///////////////////////////////////////////////////////////////////////////////
// MIT
///////////////////////////////////////////////////////////////////////////////
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is furnished to do
// so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
///////////////////////////////////////////////////////////////////////////////

module ahb3lite_dma #(
  // chXX_conf = { CBUF, ED, ARS, EN }
  parameter         rf_addr  = 0,
  parameter [1:0]   pri_sel  = 2'h0,
  parameter         ch_count = 1,
  parameter [3:0]   ch0_conf = 4'h1,
  parameter [3:0]   ch1_conf = 4'h0,
  parameter [3:0]   ch2_conf = 4'h0,
  parameter [3:0]   ch3_conf = 4'h0,
  parameter [3:0]   ch4_conf = 4'h0,
  parameter [3:0]   ch5_conf = 4'h0,
  parameter [3:0]   ch6_conf = 4'h0,
  parameter [3:0]   ch7_conf = 4'h0,
  parameter [3:0]   ch8_conf = 4'h0,
  parameter [3:0]   ch9_conf = 4'h0,
  parameter [3:0]   ch10_conf = 4'h0,
  parameter [3:0]   ch11_conf = 4'h0,
  parameter [3:0]   ch12_conf = 4'h0,
  parameter [3:0]   ch13_conf = 4'h0,
  parameter [3:0]   ch14_conf = 4'h0,
  parameter [3:0]   ch15_conf = 4'h0,
  parameter [3:0]   ch16_conf = 4'h0,
  parameter [3:0]   ch17_conf = 4'h0,
  parameter [3:0]   ch18_conf = 4'h0,
  parameter [3:0]   ch19_conf = 4'h0,
  parameter [3:0]   ch20_conf = 4'h0,
  parameter [3:0]   ch21_conf = 4'h0,
  parameter [3:0]   ch22_conf = 4'h0,
  parameter [3:0]   ch23_conf = 4'h0,
  parameter [3:0]   ch24_conf = 4'h0,
  parameter [3:0]   ch25_conf = 4'h0,
  parameter [3:0]   ch26_conf = 4'h0,
  parameter [3:0]   ch27_conf = 4'h0,
  parameter [3:0]   ch28_conf = 4'h0,
  parameter [3:0]   ch29_conf = 4'h0,
  parameter [3:0]   ch30_conf = 4'h0
)
(

  // Common signals
  input                 clk_i,
  input                 rst_i,

  // --------------------------------------
  // WISHBONE INTERFACE 0
  // Slave Interface
  input  [31:0]         wb0s_data_i,
  output [31:0]         wb0s_data_o,
  input  [31:0]         wb0_addr_i,
  input  [ 3:0]         wb0_sel_i,
  input                 wb0_we_i,
  input                 wb0_cyc_i,
  input                 wb0_stb_i,
  output                wb0_ack_o,
  output                wb0_err_o,
  output                wb0_rty_o,

  // Master Interface
  input  [31:0]         wb0m_data_i,
  output [31:0]         wb0m_data_o,
  output [31:0]         wb0_addr_o,
  output [ 3:0]         wb0_sel_o,
  output                wb0_we_o,
  output                wb0_cyc_o,
  output                wb0_stb_o,
  input                 wb0_ack_i,
  input                 wb0_err_i,
  input                 wb0_rty_i,

  // --------------------------------------
  // WISHBONE INTERFACE 1
  // Slave Interface
  input  [31:0]         wb1s_data_i,
  output [31:0]         wb1s_data_o,
  input  [31:0]         wb1_addr_i,
  input  [ 3:0]         wb1_sel_i,
  input                 wb1_we_i,
  input                 wb1_cyc_i,
  input                 wb1_stb_i,
  output                wb1_ack_o,
  output                wb1_err_o,
  output                wb1_rty_o,

  // Master Interface
  input  [31:0]         wb1m_data_i,
  output [31:0]         wb1m_data_o,
  output [31:0]         wb1_addr_o,
  output [ 3:0]         wb1_sel_o,
  output                wb1_we_o,
  output                wb1_cyc_o,
  output                wb1_stb_o,
  input                 wb1_ack_i,
  input                 wb1_err_i,
  input                 wb1_rty_i,

  // --------------------------------------
  // Misc Signal,
  input  [ch_count-1:0] dma_req_i,
  input  [ch_count-1:0] dma_nd_i,
  output [ch_count-1:0] dma_ack_o,
  input  [ch_count-1:0] dma_rest_i,
  output                inta_o,
  output                intb_o
);
  //////////////////////////////////////////////////////////////////
  //
  // Constants
  //


  //////////////////////////////////////////////////////////////////
  //
  // Variables
  //


  //////////////////////////////////////////////////////////////////
  //
  // Module Body
  //
