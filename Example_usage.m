clear;
clc;
close all;

% inputs
foil = LoadHuberIsotropicMaterial('Copper110_Ono_2020_Viscoelastic', 'MaterialList_Isotropic.txt');
coating = MakeIsotropicMaterial('Coating', 1500, 7.5e9, 0.25);
thick = [100E-3, 4.5E-3]; % thicknesses in mm
flim = [1, 1000]; % frequency range /kHz
df = 1; % frequency step /kHz

% configure model
a = generateBaselineModel; % baseline structure
a = setSymmetry(a, "on");
a = setThickness(a, thick);
a = setMaterial(a, {coating, foil});
a = setFrequency(a, flim, df);
summariseModel(a);

% perform calculation
results = RunHuberDispersion(a);

PlotDispersion(results, "wavelength");