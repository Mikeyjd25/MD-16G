# MD-16G

The MD-16G is a homebrew CPU & computer system.

## Getting Started

## Prerequisites
#### Software

To run the compiler and emulator you will need:
```
Python 2.7
Processing 3
```

#### Hardware

(Please note, this is not yet implemented)

To get the system running on hardware, you will need an FPGA. This project is optimised for the
[Arty a-7  Artix-35T](http://store.digilentinc.com/arty-a7-artix-7-fpga-development-board-for-makers-and-hobbyists/)
but could be tweaked to run on most FPGAs with enough block ram.


### Installing

How to get it up and going.

Install prerequisite software

[Python 2.7](https://www.python.org/)

[Processing 3](https://processing.org/)


Download repo
```
git clone https://github.com/Mikeyjd25/MD-16G.git
```

Run Compile
```
python Compile.py
```

Launch emulator
```
Open Emulator/emulator.pde in processing, click run.
```

A window will open and a console with text should appear.


## Built With

* [Python 2.7](https://www.python.org/) - Compiler and Assembler
* [Processing 3](https://processing.org/) - Emulator
* [Xlinix Vivado](https://www.xilinx.com/products/design-tools/vivado.html) - FPGA development


## Authors

* **Michael Duthie** - *Lead Developer* - [Mikeyjd25](https://github.com/Mikeyjd25)
* **Jacob Ernst** - *Odds, ends, [Rubber Ducky](https://en.wikipedia.org/wiki/Rubber_duck_debugging), & moral support* - [JacobErnst98](https://github.com/JacobErnst98)

## License

GNU General Public License v3.0

## Acknowledgments

Stack overflow
