# This file is intended to be used with the HDLMAKE tool for HDL generator. If
# you don't use it, please ignore

files = [
    "./wb_dma/rtl/verilog/wb_dma_ch_arb.v",
    "./wb_dma/rtl/verilog/wb_dma_ch_pri_enc.v",
    "./wb_dma/rtl/verilog/wb_dma_ch_rf.v",
    "./wb_dma/rtl/verilog/wb_dma_ch_sel.v",
    "./wb_dma/rtl/verilog/wb_dma_defines.v",
    "./wb_dma/rtl/verilog/wb_dma_de.v",
    "./wb_dma/rtl/verilog/wb_dma_inc30r.v",
    "./wb_dma/rtl/verilog/wb_dma_pri_enc_sub.v",
    "./wb_dma/rtl/verilog/wb_dma_rf.v",
    "./wb_dma/rtl/verilog/wb_dma_top.v",
    "./wb_dma/rtl/verilog/wb_dma_wb_if.v",
    "./wb_dma/rtl/verilog/wb_dma_wb_mast.v",
    "./wb_dma/rtl/verilog/wb_dma_wb_slv.v",
]

modules = {
    "local" : [ "./ahb3lite_wb_bridge"],

}
