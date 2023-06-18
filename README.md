# HYCOS (`Hy`drogen `CO`mbustion in `S`upercritical CO<sub>2</sub>)

## About
This repository contains a MATLAB model developed at the Delft University of Technology for thermodynamic assessment of transcritical and supercritical CO<sub>2</sub> fueled by H<sub>2</sub>/O<sub>2</sub> combustion.

## Citation


## Installation
To run the source code,following are the requisites:

### Requisites
- Matlab 2020b
- [CoolProp](https://github.com/CoolProp/CoolProp) (Matlab wrapper)

A quick way to test if the installations are successful is to just run the `main.m` file.

## Model assumptions


## I/O format
The script expects a set of user defined parameters in the `input.dat` file and generates `output.dat` file containing the evaluated performance parameter of for the given cycle configuration. The output files can be further analyzed by `utils/plot.m`. To run the model, ensure a valid `input.dat` file is provided and then execute `main.m` 

## Input file
The `input.dat` should contain the following thermodynamic parameters. 
### Main variables
- Lowest cycle pressure [bar] i.e. compressor inlet pressure 
- Highest cycle pressure [bar] i.e. compressor outlet pressure
- Highest cycle temperature [K] i.e. turbine inlet temperature
- Lowest cycle temperature [K] i.e. compressor inlet temperature
### Other constants 
- PPTD [K] i.e. minimum permissible temperature difference between the hot and cold lines in the recuperator
- HEX pressure recovery ratio HP side [-]
- HEX pressure recovery ratio LP side [-]
- Combustor pressure recovery ratio [-]
- Isentropic efficiency of compression process [%]
- Isentropic efficiency of expansion process [%]
- Combustion efficiency [%]
- Number of intercooled compression steps [-]
- Maximum allowable blade metal temperature for turbine cooling model [K]
- Molar mass of CO<sub>2</sub> [g/mol]
- Molar mass of H<sub>2</sub>O [g/mol]
- Molar mass of H<sub>2</sub>  [g/mol]
- Molar mass of O<sub>2</sub>  [g/mol]
- LHV of fuel (H<sub>2</sub>)  [MJ/kg]
- HHV of fuel (H<sub>2</sub>)  [MJ/kg]

### Exit criteria and other variables
- Permissible error in PPTD calculation [-]
- Permissible error in mixture composition calculation [-]

## Acronyms

| Acronym | Definition                   |
|---------|------------------------------|
| HYCOS   | Hydrogen Combustion in supercritical-CO<sub>2</sub> |
| PPTD    | Pinch Point Temperature Difference      |
| HEX     | Heat Exchanger|
| HP      | High pressure|
| LP      | Low pressure|
| LHV     | Lower heating value |
| HHV     | Hower heating value |


## References

