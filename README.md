# AHB3-Lite DMA core

This repository contains a soft DMA adapted to the  [AMBA 3 AHB-Lite v1.0 ](http://infocenter.arm.com/help/topic/com.arm.doc.ihi0033a/index.html) bus protocol. For simplicity, it uses an open-source DMA originally compatible with [Wishbone Version B4](http://cdn.opencores.org/downloads/wbspec_b4.pdf). This cores is, therefore, a wrapper to that one with the addition of AHB3-lite/Wishbone bridges.

## Documentation

The documentation for reference should be the one of the original DMA core, given that the registers and behaviour are the same.

- [PDF Format](https://github.com/freecores/wb_dma/blob/master/doc/dma_doc.pdf)


## Features

<!-- - Tested through simulation and synthesis -->
- Support for AMBA 3 AHB-Lite protocol
- 32-bit width address bus
- 32-bit width data bus
- Common clock and reset (active low) signals

## Interfaces
- AHB3-Lite master and slave interfaces

## Dependencies

Requires the [AHB3-Lite to Wishbone bridge](https://github.com/vfinotti/ahb3lite_wb_bridge) and the [WISHBONE DMA/Bridge IP Core ](https://github.com/freecores/wb_dma) These are included as submodules.
After cloning the git repository, perform a 'git submodule init' and a 'git submodule update' to download the submodule.
