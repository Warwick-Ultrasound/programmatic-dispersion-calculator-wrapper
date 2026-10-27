# programmatic-dispersion-calculator-wrapper
A MATLAB wrapper which allows you to use a subset of Armin Huber's Dispersion Calculator functions programmatically.

## What is this for?

Armin Huber has developed an excellent tool for calculating guided wave dispersion curves called Dispersion Calculator, which can be found [here](https://github.com/ArminHuber/Dispersion-Calculator). This repository contains a handful of functions which allow you to call a limited subset of the functions in the Dispersion Calculator source code programmatically, to enable iteration over wide ranges of material parameters and dimensions.  

The Dispersion Calculator is an incredibly versatile and well written tool. The code in this repository is neither of those things, and was never designed to be. It only uses the anisotropic tab of the Dispersion Calculator, and even then only has access to limited parts of it. It emulates the GUI by loading in a baseline structure a, and then contains functions which allow you to make some modifications. For example changing the layup, materials, thicknesses, and frequency range.

## Installation Instructions

First install the [Dispersion Calculator source code](https://github.com/ArminHuber/Dispersion-Calculator) following the instructions in it's repository. You will need MATLAB 2026a or newer, and access to the packages it is dependent on. Make sure to add the source code to the MATLAB path.

Now download the code in this repository, and add it to the MATLAB path.

## Description of functions

The easiest way to get started is to open "Example_usage.m" to see the workflow of configuring the model, running the calculation, and plotting the dispersion curves. Detailed descriptions of the functions are below.

**Note**: If the structure you are trying to simulate is symmetric about the midplane (e.g. a 3 mm thick copper plate with 0.5 mm of aluminium on each side), then you must only model half of the structure and turn on symmetry. In our example, that would mean thick = [0.5, 1.5] and mats = {aluminium, copper}, i.e. the top half is modelled and reflected onto the bottom half, so the central plate thickness must be halved.

### mat = LoadHuberIsotropicMaterial(materialName,materialFile)

Load a single isotropic material from the materials database contained in the dispersion calculator source code. For example, copper_plate = LoadHuberIsotropicMaterial('Copper110_Ono_2020_Viscoelastic', 'MaterialList_Isotropic.txt').

### mat = MakeIsotropicMaterial(name,rho,E,nu)

Make a new isotropic material by assigning a name, mass density, Young's modulus and Poisson's ratio (all in base SI units). Note that this does not save to Dispersion Calculator's database - it's intended purpose is to allow for iteration through different material properties.

### a = generateBaselineModel

Loads the struct in "a_core.mat" to the workspace. This is a baseline model which was extracted by running the GUI and pausing just before a calculation was run. It means that the many parameters in the GUI have been captured within it, and it is this that is passed onto later functions containing all of the information about what you want to calculate and how to calculate it.  

### a = setThickness(a,thick)

Changes the thicknesses of all of the layers in the anisotropic structure by passing an array of doubles with a length equal to the number of layers in the unit cell. "thick" should be passed to this function in mm.

### a = setMaterial(a, mats)

Changes the materials in each layer. "mats" is a cell array containing a material in each cell which is created using MakeIsotropicMaterial or LoadHuberIsotropicMaterial.

### a = setFrequency(a, flim, df)

Changes the frequencies at which the dispersion calculation will be outputted. flim is a 2-vector containing the lower and upper bounds, and df is the spacing. All in kHz.

### a = setSymmetry(a, str)

Sets the symmetry of the model "on" or "off". Symmetry "on" will create a mirror image of your model directly below the original one - see the note above.

### summariseModel(a)

Prints some important features of your model to the command window so that you can check that you have configured it properly.

### results = RunHuberDispersion(a)

This is the function which actually runs the calculation for a given configuration, a. The results is a struct containing fields for the different kinds of modes. Each mode has a cell array inside it, with a cell for each mode. Inside each mode cell is a table containing all of the parameters for that mode.

### PlotDispersion(results, yVar, modes)

A plotting function for the results structure which allows you to choose the y variable (from the table column headings inside "results") and the modes to plot. Example usage:

PlotDispersion(results,'cp')

PlotDispersion(results,'cg',{'S0','A0'})

PlotDispersion(results,'wavenumber',{'A0'})
