# HYCOS ()

## About
This repository contains a MATLAB model developed at the Delft University of Technology for thermodynamic assessment of transcritical and supercritical CO<sub>2</sub> fueled by H<sub>2</sub>/O<sub>2</sub> combustion.

## Citation


## Installation
To run the source code,following are the requisites:

### Requisites
- Matlab 2020b
- [Coolprop](https://github.com/CoolProp/CoolProp) (Matlab wrapper)

A quick way to test if the installations are successful is to just run the `main.m` file.

## I/O format
The script expects a set of user defined parameters in the `input.dat` file and generates `output.dat` file containing the evaluated performance parameter of for the given cycle configuration. The output files can be further analyzed by `utils/plot.m`. To run the model, ensure a valid `input.dat` file is provided and then execute `main.m` 

## Input file
The `input.dat` should contain the following thermodynamic parameters. 

- Lowest cycle pressure [bar] i.e. compressor inlet pressure 
- Highest cycle pressure [bar] i.e. compressor outlet pressure
- Highest cycle temperature [K] i.e. turbine inlet temperature
- Lowest cycle temperature [K] i.e. compressor inlet temperature
 
