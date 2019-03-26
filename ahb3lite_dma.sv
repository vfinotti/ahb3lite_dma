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
  input                 rst_n_i,

  // --------------------------------------
  // WISHBONE INTERFACE 0
  // Slave Interface
  input                 s0HSEL,
  input  [31:0]         s0HADDR,
  input  [31:0]         s0HWDATA,
  output [31:0]         s0HRDATA,
  input                 s0HWRITE,
  input  [ 2:0]         s0HSIZE,
  input  [ 2:0]         s0HBURST,
  input  [ 3:0]         s0HPROT,
  input  [ 1:0]         s0HTRANS,
  output                s0HREADYOUT,
  input                 s0HREADY,
  output                s0HRESP,

  // Master Interface
  output                m0HSEL,
  output [31:0]         m0HADDR,
  output [31:0]         m0HWDATA,
  input  [31:0]         m0HRDATA,
  output                m0HWRITE,
  output [ 2:0]         m0HSIZE,
  output [ 2:0]         m0HBURST,
  output [ 3:0]         m0HPROT,
  output [ 1:0]         m0HTRANS,
  output                m0HREADYOUT,
  input                 m0HREADY,
  input                 m0HRESP,

  // --------------------------------------
  // WISHBONE INTERFACE 1
  // Slave Interface
  input                 s1HSEL,
  input  [31:0]         s1HADDR,
  input  [31:0]         s1HWDATA,
  output [31:0]         s1HRDATA,
  input                 s1HWRITE,
  input  [ 2:0]         s1HSIZE,
  input  [ 2:0]         s1HBURST,
  input  [ 3:0]         s1HPROT,
  input  [ 1:0]         s1HTRANS,
  output                s1HREADYOUT,
  input                 s1HREADY,
  output                s1HRESP,

  // Master Interface
  output                m1HSEL,
  output [31:0]         m1HADDR,
  output [31:0]         m1HWDATA,
  input  [31:0]         m1HRDATA,
  output                m1HWRITE,
  output [ 2:0]         m1HSIZE,
  output [ 2:0]         m1HBURST,
  output [ 3:0]         m1HPROT,
  output [ 1:0]         m1HTRANS,
  output                m1HREADYOUT,
  input                 m1HREADY,
  input                 m1HRESP,

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
  logic rst;

  logic [31 : 0] to_wb0_dat_i;
  logic [31 : 0] to_wb0_adr_i;
  logic [ 3 : 0] to_wb0_sel_i;
  logic          to_wb0_we_i;
  logic          to_wb0_cyc_i;
  logic          to_wb0_stb_i;
  logic          from_wb0_dat_o;
  logic [31 : 0] from_wb0_ack_o;
  logic          from_wb0_err_o;

  logic [31 : 0] to_wb1_dat_i;
  logic [31 : 0] to_wb1_adr_i;
  logic [ 3 : 0] to_wb1_sel_i;
  logic          to_wb1_we_i;
  logic          to_wb1_cyc_i;
  logic          to_wb1_stb_i;
  logic          from_wb1_dat_o;
  logic [31 : 0] from_wb1_ack_o;
  logic          from_wb1_err_o;

  logic [31 : 0] from_m_wb0_adr_o;
  logic [ 3 : 0] from_m_wb0_sel_o;
  logic          from_m_wb0_we_o;
  logic [31 : 0] from_m_wb0_dat_o;
  logic          from_m_wb0_cyc_o;
  logic          from_m_wb0_stb_o;
  logic          to_m_wb0_ack_i;
  logic          to_m_wb0_err_i;
  logic [31 : 0] to_m_wb0_dat_i;
  // logic [ 2 : 0] from_m_wb0_cti_o;
  // logic [ 1 : 0] from_m_wb0_bte_o;

  logic [31 : 0] from_m_wb1_adr_o;
  logic [ 3 : 0] from_m_wb1_sel_o;
  logic          from_m_wb1_we_o;
  logic [31 : 0] from_m_wb1_dat_o;
  logic          from_m_wb1_cyc_o;
  logic          from_m_wb1_stb_o;
  logic          to_m_wb1_ack_i;
  logic          to_m_wb1_err_i;
  logic [31 : 0] to_m_wb1_dat_i;
  // logic [ 2 : 0] from_m_wb1_cti_o;
  // logic [ 1 : 0] from_m_wb1_bte_o;



  //////////////////////////////////////////////////////////////////
  //
  // Module Body
  //
  assign rst = !rst_n_i;
    
  ahb3lite_to_wb ahb3lite_to_wb_0 (
    .clk_i         ( clk_i          ),
    .rst_n_i       ( rst_n_i        ),

    // ahb3lite
    .sHADDR        ( s0HADDR        ),
    .sHWDATA       ( s0HWDATA       ),
    .sHWRITE       ( s0HWRITE       ),
    .sHREADYOUT    ( s0HREADYOUT    ),
    .sHSIZE        ( s0HSIZE        ),
    .sHBURST       ( s0HBURST       ),
    .sHSEL         ( s0HSEL         ),
    .sHTRANS       ( s0HTRANS       ),
    .sHRDATA       ( s0HRDATA       ),
    .sHRESP        ( s0HRESP        ),
    .sHREADY       ( s0HREADY       ),
    .sHPROT        ( s0HPROT        ),

    // to wishbone
    .to_wb_dat_i   ( to_wb0_dat_i   ),
    .to_wb_adr_i   ( to_wb0_adr_i   ),
    .to_wb_sel_i   ( to_wb0_sel_i   ),
    .to_wb_we_i    ( to_wb0_we_i    ),
    .to_wb_cyc_i   ( to_wb0_cyc_i   ),
    .to_wb_stb_i   ( to_wb0_stb_i   ),
    .from_wb_dat_o ( from_wb0_dat_o ),
    .from_wb_ack_o ( from_wb0_ack_o ),
    .from_wb_err_o ( from_wb0_err_o ) );


  wb_to_ahb3lite wb_to_ahb3lite_0 (
    .clk_i           ( clk_i            ),
    .rst_n_i         ( rst_n_i          ),

    //// wishbone
    .from_m_wb_adr_o ( from_m_wb0_adr_o ),
    .from_m_wb_sel_o ( from_m_wb0_sel_o ),
    .from_m_wb_we_o  ( from_m_wb0_we_o  ),
    .from_m_wb_dat_o ( from_m_wb0_dat_o ),
    .from_m_wb_cyc_o ( from_m_wb0_cyc_o ),
    .from_m_wb_stb_o ( from_m_wb0_stb_o ),
    .to_m_wb_ack_i   ( to_m_wb0_ack_i   ),
    .to_m_wb_err_i   ( to_m_wb0_err_i   ),
    .to_m_wb_dat_i   ( to_m_wb0_dat_i   ),

    .from_m_wb_cti_o ( 3'b000           ), // Cycle Type Identifier ( 3'b000 - Classic cycle, 3'b111 - End-of-cycle)
    .from_m_wb_bte_o (                  ),

    //// to ahb3lite
    .mHSEL           ( m0HSEL           ),
    .mHSIZE          ( m0HSIZE          ),
    .mHRDATA         ( m0HRDATA         ),
    .mHRESP          ( m0HRESP          ),
    .mHREADY         ( m0HREADY         ),
    .mHREADYOUT      ( m0HREADYOUT      ),
    .mHWRITE         ( m0HWRITE         ),
    .mHBURST         ( m0HBURST         ),
    .mHADDR          ( m0HADDR          ),
    .mHTRANS         ( m0HTRANS         ),
    .mHWDATA         ( m0HWDATA         ),
    .mHPROT          ( m0HPROT          ) );


  ahb3lite_to_wb ahb3lite_to_wb_1 (
    .clk_i         ( clk_i          ),
    .rst_n_i       ( rst_n_i        ),

    // ahb3lite
    .sHADDR        ( s1HADDR        ),
    .sHWDATA       ( s1HWDATA       ),
    .sHWRITE       ( s1HWRITE       ),
    .sHREADYOUT    ( s1HREADYOUT    ),
    .sHSIZE        ( s1HSIZE        ),
    .sHBURST       ( s1HBURST       ),
    .sHSEL         ( s1HSEL         ),
    .sHTRANS       ( s1HTRANS       ),
    .sHRDATA       ( s1HRDATA       ),
    .sHRESP        ( s1HRESP        ),
    .sHREADY       ( s1HREADY       ),
    .sHPROT        ( s1HPROT        ),

    // to wishbone
    .to_wb_dat_i   ( to_wb1_dat_i   ),
    .to_wb_adr_i   ( to_wb1_adr_i   ),
    .to_wb_sel_i   ( to_wb1_sel_i   ),
    .to_wb_we_i    ( to_wb1_we_i    ),
    .to_wb_cyc_i   ( to_wb1_cyc_i   ),
    .to_wb_stb_i   ( to_wb1_stb_i   ),
    .from_wb_dat_o ( from_wb1_dat_o ),
    .from_wb_ack_o ( from_wb1_ack_o ),
    .from_wb_err_o ( from_wb1_err_o ) );


  wb_to_ahb3lite wb_to_ahb3lite_1 (
    .clk_i           ( clk_i            ),
    .rst_n_i         ( rst_n_i          ),

    //// wishbone
    .from_m_wb_adr_o ( from_m_wb1_adr_o ),
    .from_m_wb_sel_o ( from_m_wb1_sel_o ),
    .from_m_wb_we_o  ( from_m_wb1_we_o  ),
    .from_m_wb_dat_o ( from_m_wb1_dat_o ),
    .from_m_wb_cyc_o ( from_m_wb1_cyc_o ),
    .from_m_wb_stb_o ( from_m_wb1_stb_o ),
    .to_m_wb_ack_i   ( to_m_wb1_ack_i   ),
    .to_m_wb_err_i   ( to_m_wb1_err_i   ),
    .to_m_wb_dat_i   ( to_m_wb1_dat_i   ),

    .from_m_wb_cti_o ( 3'b000           ), // Cycle Type Identifier ( 3'b000 - Classic cycle, 3'b111 - End-of-cycle)
    .from_m_wb_bte_o (                  ),

    //// to ahb3lite
    .mHSEL           ( m1HSEL           ),
    .mHSIZE          ( m1HSIZE          ),
    .mHRDATA         ( m1HRDATA         ),
    .mHRESP          ( m1HRESP          ),
    .mHREADY         ( m1HREADY         ),
    .mHREADYOUT      ( m1HREADYOUT      ),
    .mHWRITE         ( m1HWRITE         ),
    .mHBURST         ( m1HBURST         ),
    .mHADDR          ( m1HADDR          ),
    .mHTRANS         ( m1HTRANS         ),
    .mHWDATA         ( m1HWDATA         ),
    .mHPROT          ( m1HPROT          ) );


  wb_dma_top #(
    // chXX_conf = { CBUF, ED, ARS, EN }
    .rf_addr     ( rf_addr          ),
    .pri_sel     ( pri_sel          ),
    .ch_count    ( ch_count         ),
    .ch0_conf    ( ch0_conf         ),
    .ch1_conf    ( ch1_conf         ),
    .ch2_conf    ( ch2_conf         ),
    .ch3_conf    ( ch3_conf         ),
    .ch4_conf    ( ch4_conf         ),
    .ch5_conf    ( ch5_conf         ),
    .ch6_conf    ( ch6_conf         ),
    .ch7_conf    ( ch7_conf         ),
    .ch8_conf    ( ch8_conf         ),
    .ch9_conf    ( ch9_conf         ),
    .ch10_conf   ( ch10_conf        ),
    .ch11_conf   ( ch11_conf        ),
    .ch12_conf   ( ch12_conf        ),
    .ch13_conf   ( ch13_conf        ),
    .ch14_conf   ( ch14_conf        ),
    .ch15_conf   ( ch15_conf        ),
    .ch16_conf   ( ch16_conf        ),
    .ch17_conf   ( ch17_conf        ),
    .ch18_conf   ( ch18_conf        ),
    .ch19_conf   ( ch19_conf        ),
    .ch20_conf   ( ch20_conf        ),
    .ch21_conf   ( ch21_conf        ),
    .ch22_conf   ( ch22_conf        ),
    .ch23_conf   ( ch23_conf        ),
    .ch24_conf   ( ch24_conf        ),
    .ch25_conf   ( ch25_conf        ),
    .ch26_conf   ( ch26_conf        ),
    .ch27_conf   ( ch27_conf        ),
    .ch28_conf   ( ch28_conf        ),
    .ch29_conf   ( ch29_conf        ),
    .ch30_conf   ( ch30_conf        ) )
  wb_dma0 (
    // Common signals
    .clk_i       ( clk_i            ),
    .rst_i       ( rst              ),

    // --------------------------------------
    // WISHBONE INTERFACE 0
    // Slave Interface
    .wb0s_data_i ( to_wb0_dat_i     ),
    .wb0s_data_o ( from_wb0_dat_o   ),
    .wb0_addr_i  ( to_wb0_adr_i     ),
    .wb0_sel_i   ( to_wb0_sel_i     ),
    .wb0_we_i    ( to_wb0_we_i      ),
    .wb0_cyc_i   ( to_wb0_cyc_i     ),
    .wb0_stb_i   ( to_wb0_stb_i     ),
    .wb0_ack_o   ( from_wb0_ack_o   ),
    .wb0_err_o   ( from_wb0_err_o   ),
    .wb0_rty_o   (                  ),

    // Master Interface
    .wb0m_data_i ( to_m_wb0_dat_i   ),
    .wb0m_data_o ( from_m_wb0_dat_o ),
    .wb0_addr_o  ( from_m_wb0_adr_o ),
    .wb0_sel_o   ( from_m_wb0_sel_o ),
    .wb0_we_o    ( from_m_wb0_we_o  ),
    .wb0_cyc_o   ( from_m_wb0_cyc_o ),
    .wb0_stb_o   ( from_m_wb0_stb_o ),
    .wb0_ack_i   ( to_m_wb0_ack_i   ),
    .wb0_err_i   ( to_m_wb0_err_i   ),
    .wb0_rty_i   ( 1'b0             ),

    // --------------------------------------
    // WISHBONE INTERFACE 1
    // Slave Interface
    .wb1s_data_i ( to_wb1_dat_i     ),
    .wb1s_data_o ( from_wb1_dat_o   ),
    .wb1_addr_i  ( to_wb1_adr_i     ),
    .wb1_sel_i   ( to_wb1_sel_i     ),
    .wb1_we_i    ( to_wb1_we_i      ),
    .wb1_cyc_i   ( to_wb1_cyc_i     ),
    .wb1_stb_i   ( to_wb1_stb_i     ),
    .wb1_ack_o   ( from_wb1_ack_o   ),
    .wb1_err_o   ( from_wb1_err_o   ),
    .wb1_rty_o   (                  ),

    // Master Interface
    .wb1m_data_i ( to_m_wb1_dat_i   ),
    .wb1m_data_o ( from_m_wb1_dat_o ),
    .wb1_addr_o  ( from_m_wb1_adr_o ),
    .wb1_sel_o   ( from_m_wb1_sel_o ),
    .wb1_we_o    ( from_m_wb1_we_o  ),
    .wb1_cyc_o   ( from_m_wb1_cyc_o ),
    .wb1_stb_o   ( from_m_wb1_stb_o ),
    .wb1_ack_i   ( to_m_wb1_ack_i   ),
    .wb1_err_i   ( to_m_wb1_err_i   ),
    .wb1_rty_i   ( 1'b0             ),

    // --------------------------------------
    // Misc Signals
    .dma_req_i   ( dma_req_i        ),
    .dma_nd_i    ( dma_nd_i         ),
    .dma_ack_o   ( dma_ack_o        ),
    .dma_rest_i  ( dma_rest_i       ),
    .inta_o      ( inta_o           ),
    .intb_       ( intb_o           ) );
