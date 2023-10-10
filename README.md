# Simple RISC-V 32-bits core
This project has the objective to build a functional RISC-V core implementation on a FPGA. The Hardware objective will be the [Nexys-A7](https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual) which use the Artix-7 FPGA core. 
To build this core is intended to be written on Verilog/SystemVerilog. This choose in bounded by the requirements and facility to achieve this project. First because is needed a program to convert the synthesize map to bitstream and can be only achivied with Vivado. And second because the most mature open source toolchain are made to use Verilog like Verilator which is probably the tool I will use to model and testbench. Because of that I will only keep here the model testbenches, documentation and some diagrams here.

## Roadmap?
The project is intended to be a long term work. Always trying to improve, compare and extend the microarchitecture of this core

