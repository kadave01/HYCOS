# HYCOS (`Hy`drogen `CO`mbustion in `S`upercritical CO<sub>2</sub>)

## About
This repository contains a MATLAB   model developed at the Technische Universiteit Delft (TU Delft) for thermodynamic assessment of the HYCOS cycle which is a transcritical/supercritical CO<sub>2</sub> Brayton cycle fueled by H<sub>2</sub>/O<sub>2</sub> combustion. This cycle is proposed for use in H<sub>2</sub> based energy storage and reconversion systems for distributed power generation/energy islands. 

More details about the HYCOS concept can be found in my [publication]()  and in my [MSc thesis report](https://repository.tudelft.nl/islandora/object/uuid%3Aaaa684ff-d22c-4482-bb2e-bbbd74336ab1) available at the TU Delft repository.    

## Author Contributions

| Name                                                  | Contact Details                                    | ORCID                                                        | Contributions                                                                                 |
|-------------------------------------------------------|----------------------------------------------------|--------------------------------------------------------------|-----------------------------------------------------------------------------------------------|
| Kaushal Dave [@kadave01](https://github.com/kadave01) | k.a.dave@tudelft.nl<br>kaushal.atul.dave@gmail.com | [0000-0002-5488-7909](https://orcid.org/0000-0002-5488-7909) | Conceptualization, Methodology, Software, Validation, Investigation, Writing – Original Draft | 
| Arvind Gangoli Rao                                    | A.GangoliRao@tudelft.nl                            | [0000-0002-9558-8171](https://orcid.org/0000-0002-9558-8171) | Conceptualization, Validation, Writing – Review & Editing, Supervision                        |

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

## External references
1. Publication
2. 4TU repository
3. MSc thesis

## Installation
The following are the minimum requisites based on the author's system configuration (using ***Windows 10***) :

#### Minimum requisites
- Matlab 2021b
- Python 3.8.x
- [CoolProp](https://github.com/CoolProp/CoolProp) 6.4.x (Matlab wrapper)

A quick way to test if the installations are successful is to just run the `..\source\main.m` file. Ensure that a valid `..\source\input.dat` is provided. A correct installation should enable successful compilation of the scripts and generate `..\source\output.dat`.  

## Repository Structure

```
.
├── source/
│   │
│   ├── functions/
│   │   └── *.m
│   │
│   │── utils/
│   │   │── output_map.dat
│   │   └── performance_map.m
│   │
│   │── input.dat
│   │
│   │── main.m
│   │
│   └── output.dat
│
├── LICENSE
│
├── README.md
│
└── .gitignore
```


## Model assumptions

1. Compression and expansions are adiabatic processes of specified isentropic efficiency.
2. Half of the turbine cooling flow is assumed to be mixed before expansion and the remaining half is mixed after expansion. The mixing process is assumed to cause no pressure loss to the main stream of flue gases. 

    ***NOTE: Thus, for TIT and TOT in conventional terms, use combustor outlet temperature and recuperator LP side inlet temperature respectively.***
3. Fuel/oxidizer are available at the site in pre-compressed state at ambient temperature.
4. Flue gas mixture is treated as an ideal mixture of real gases i.e. an ideal mixture of CO<sub>2</sub> and H<sub>2</sub>O and the real gas effects are included only for the individual components.

## Base Thermodynamic Model
The base thermodynamic module can be used via the `..\source\main.m` script. It evaluate a single configuration of the HYCOS cycle that can be specified by the user via the `..\source\input.dat` file.  
### I/O format
When executing `..\source\main.m` ensure a valid `..\source\input.dat` file is provided. The script then generates `..\source\output.dat` file containing the evaluated performance parameter of the HYCOS cycle for the defined configuration. Any desired configuration of the HYCOS cycle can be analyzed by editing the parameters in the `..\source\input.dat`. 

### Input file
The `..\source\input.dat` should contain the following thermodynamic parameters as individual line items. 
```
32 ##Lowest cycle pressure [bar] i.e. compressor inlet pressure 
303.85 ##Highest cycle pressure [bar] i.e. compressor outlet pressure
1455 ##Highest cycle temperature [K] i.e. turbine inlet temperature
302.15 ##Lowest cycle temperature [K] i.e. compressor inlet temperature
10 ##PPTD [K] i.e. minimum permissible temperature difference between the hot and cold lines in the recuperator
0.9973 ##HEX pressure recovery ratio HP side [-]
0.97 ##HEX pressure recovery ratio LP side [-]
0.99 ##Combustor pressure recovery ratio [-]
80 ##Isentropic efficiency of compression process [%]
83 ##Isentropic efficiency of expansion process [%]
99.5 ##Combustion efficiency [%]
4 ##Number of intercooled compression steps [-]
1073.15 ##Maximum allowable blade metal temperature [K]
44.00095 ##Molar mass of CO<sub>2</sub> [kg/kmol]
18.0153 ##Molar mass of H<sub>2</sub>O [kg/kmol]
2.01588 ##Molar mass of H<sub>2</sub>  [kg/kmol]
31.9988 ##Molar mass of O<sub>2</sub>  [kg/kmol]
285.8E3 ##Molar HHV of fuel (H<sub>2</sub>)  [MJ/kmole]
241.826E3 ##Molar LHV of fuel (H<sub>2</sub>)  [MJ/kmole]
1E-1 ##Permissible error in PPTD calculation [-]
1E-6 ##Permissible error in mixture composition calculation [-]
501 ##Number of heat exchange steps in the recuperator [-]
```

The values preceeding `##` can be changed in accordance with the user requirements.

<ins>**Important note:**</ins> 

Please ensure to provide the parameters in the stated units/format  and in the same sequence as given in the sample `..\source\input.dat` file to avoid compilation errors and/or invalid results.

### Output file
The `..\source\output.dat` will have the following format.  
```
32.00,303.85,303.85,303.03,303.03,300.00,300.00,34.01,34.01,32.99,32.99,
302.15,314.85,314.85,1050.42,1050.42,1455.00,1427.44,1093.42,1073.30,329.06,329.06,
58.780,370.576,10.000,5.255,
```
<ins>**Explanation:**</ins>

Line 1: Comma separated values of pressure in bar at the following locations

*Compressor inlet, compressor outlet, recuperator HP inlet, recuperator HP outlet, combustor inlet, combustor outlet, turbine inlet, turbine outlet, recuperator LP inlet, recuperator LP outlet, condenser inlet*

Line 2: Comma separated values of temperature in K at the following locations

*Compressor inlet, compressor outlet, recuperator HP inlet, recuperator HP outlet, combustor inlet, combustor outlet, turbine inlet, turbine outlet, recuperator LP inlet, recuperator LP outlet, condenser inlet*

Line 3: Comma separated values of key performance parameters

*Efficiency[%], net specific work output[kJ/kgCO<sub>2</sub>], PPTD[K], fuel flow rate [g/s]*

## Additional functionalities
### Performance map module
The `performance_map.m` script included in the `../utils` subdirectory can used to generate a performance map for the HYCOS cycle. It requires the user to define range of values for turbine outlet pressure (TOP) and turbine inlet temperature (TIT) over which the base thermodynamic model is iterated. Other cycle parameters previously specified using the `..\source\input.dat` file are also included in this script and can be modified as desired. The script generates `..\utils\output_map.dat` file and appends key performance parameters to it at the end of each iteration. 

### Inputs
Specify the desired values of TOP and TIT in `..\utils\performance_map.m` file.
```
TOP = [1,2:2:100]; %specify the desired values of TOP
TIT = [1000:5:2000]; %specify the desired values of TIT
```
### Outputs 
The `..\utils\output_map.dat` file contains a list of key performance parameters for each combination of TOP and TIT specified by the user. 
```
TOP[Pa]	TIT[K]	Efficiency[-]	Net_sp_work[J/kgCO2]	TOT[K]
100000.000000	1000.000000	0.307700	274873.006000	476.070846	
100000.000000	1005.000000	0.310900	279148.016000	478.970176	
.
.
.
.
100000.000000	1995.000000	0.602000	1061550.895000	958.468393	
100000.000000	2000.000000	0.602200	1065940.522000	960.621250	
200000.000000	1000.000000	0.331000	281244.253000	518.499250	
200000.000000	1005.000000	0.334000	285096.416000	521.612321	
.
.
.
10000000.000000	2000.000000	0.423300	289415.432000	1619.287190
```

### Other modules
The author has also developed the following additional functionalities using the base code provided in this repository. 

1. Optimization module using the MATLAB Optimization Toolbox
2. Sensitivity module

Please contact the author [@k.a.dave@tudelft.nl](k.a.dave@tudelft.nl) or [@kaushal.atul.dave@gmail.com](kaushal.atul.dave@gmail.com) if you are interested in exploring these modules. 

## Acronyms

| Acronym | Definition                                          |
|---------|-----------------------------------------------------|
| HYCOS   | Hydrogen Combustion in supercritical-CO<sub>2</sub> |
| PPTD    | Pinch Point Temperature Difference      |
| HEX     | Heat Exchanger|
| HP      | High pressure|
| LP      | Low pressure|
| LHV     | Lower heating value |
| HHV     | Higher heating value |
| TOP     | Turbine outlet pressure|
| TIT     | Turbine inlet temperature|

## License
The contents of this repository are released under an [MIT](https://choosealicense.com/licenses/mit/) license (see LICENSE file).


### Copyright notice

Technische Universiteit Delft hereby disclaims all copyright interest in the **HYCOS** thermodynamic model for assessment of transcritical/supercritical CO<sub>2</sub> Brayton cycles written by the Author(s). 

Henri Werij, Faculty of Aerospace Engineering, Technische Universiteit Delft.

© [2023], [Kaushal Dave]

