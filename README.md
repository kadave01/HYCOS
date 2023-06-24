# HYCOS (`Hy`drogen `CO`mbustion in `S`upercritical CO<sub>2</sub>)

## About
This repository contains a MATLAB   model developed at the Technische Universiteit Delft for thermodynamic assessment of the HYCOS cycle which is a transcritical/supercritical CO<sub>2</sub> Brayton cycle fueled by H<sub>2</sub>/O<sub>2</sub> combustion. This cycle is proposed for use in H<sub>2</sub> based energy storage and reconversion systems for distributed power generation/energy islands. 

More details about the HYCOS concept can be found in my [publication]()  and in my [MSc thesis report](https://repository.tudelft.nl/islandora/object/uuid%3Aaaa684ff-d22c-4482-bb2e-bbbd74336ab1) available at the TU Delft repository.    

## How to Cite

If you use this model in your work, I request you to acknowledge it in your research by citing my paper using the following BibTeX citation:

```bibtex
@article{citekey,
  author = {Last name, First initials},
  title = {Title of the paper},
  journal = {Journal Name},
  volume = {Volume},
  number = {Issue},
  pages = {Page numbers},
  year = {Year},
  doi = {DOI (if available)}
}
```

## Installation
To run the source code,following are the requisites:

### Minimum requisites
- Matlab 2021b
- [CoolProp](https://github.com/CoolProp/CoolProp) (Matlab wrapper)

A quick way to test if the installations are successful is to just run the `main.m` file.

## Model assumptions

1. Compression and expansions are adiabatic processes of specified isentropic efficiency.
2. Half of the turbine cooling flow is assumed to be mixed before expansion and the remaining half is mixed after expansion. The mixing process is assumed to cause no pressure loss to the main stream of flue gases. 

    ***NOTE: Thus, for TIT and TOT in conventional terms, use combustor outlet temperature and recuperator LP side inlet temperature respectively.***
3. Fuel/oxidizer are available at the site in pre-compressed state at ambient temperature.
4. Flue gas mixture is treated as an ideal mixture of real gases i.e. an ideal mixture of CO<sub>2</sub> and H<sub>2</sub>O and the real gas effects are included only for the individual components.


## I/O format
When executing `main.m` ensure a valid `input.dat` file is available in the source folder. The script then generates `output.dat` file containing the evaluated performance parameter of the HYCOS cycle for the defined configuration. Any desired configuration of the HYCOS cycle can be analyzed by editing the parameters in the `input.dat` file. 

## Input file
The `input.dat` should contain the following thermodynamic parameters as individual line items. 
```
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
```
### Important note
Ensure the order in which these parameters are provided is same as in the sample `input.dat` file in the source folder to avoid errors / generation of invalid results.   


## Output file
The `output.dat` contains the following cycle parameters

Line 1: Comma separated values of pressure in bar at the following locations

*Compressor inlet, compressor outlet, recuperator HP inlet, recuperator HP outlet, combustor inlet, combustor outlet, turbine inlet, turbine outlet, recuperator LP inlet, recuperator LP outlet, condenser inlet*

Line 2: Comma separated values of temperature in K at the following locations

*Compressor inlet, compressor outlet, recuperator HP inlet, recuperator HP outlet, combustor inlet, combustor outlet, turbine inlet, turbine outlet, recuperator LP inlet, recuperator LP outlet, condenser inlet*

Line 3: Comma separated values of key performance parameters

*Efficiency[%], net specific work output[kJ/kgCO<sub>2</sub>], PPTD[K], fuel flow rate [g/s]*

## Acronyms

| Acronym | Definition                   |
|---------|------------------------------|
| HYCOS   | Hydrogen Combustion in supercritical-CO<sub>2</sub> |
| PPTD    | Pinch Point Temperature Difference      |
| HEX     | Heat Exchanger|
| HP      | High pressure|
| LP      | Low pressure|
| LHV     | Lower heating value |
| HHV     | Higher heating value |

## Additional functionalities

The author have developed the following additional functionalities using the base code provided in this repository. 

1. Optimization module using the MATLAB Optimization Toolbox
2. Sensitivity module

Please contact the author @ [kaushal.atul.dave@gmail.com](kaushal.atul.dave@gmail.com) if your are interested in exploring these modules. 

## License

[MIT](https://choosealicense.com/licenses/mit/)

### Copyright notice

Technische Universiteit Delft hereby disclaims all copyright interest in the `HYCOS` model for thermodynamic assessment of transcritical/supercritical CO<sub>2</sub> Brayton cycles written by the Author(s). 

Henri Werij, Faculty of Aerospace Engineering, Technische Universiteit Delft.

© [2023], [Kaushal Dave]

