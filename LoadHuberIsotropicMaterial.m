function mat = LoadHuberIsotropicMaterial(materialName,materialFile)
% Load a single isotropic material from Huber's MaterialList_Isotropic.txt
%
% Example:
%   mat = LoadHuberIsotropicMaterial( ...
%       'Copper', ...
%       'MaterialList_Isotropic.txt');

if nargin < 2
    materialFile = 'MaterialList_Isotropic.txt';
end

fid = fopen(materialFile,'r');

if fid == -1
    error('Cannot open %s',materialFile);
end

A = textscan(fid,'%s %f %f %f %f %f');
fclose(fid);

idx = find(strcmp(A{1},materialName),1);

if isempty(idx)
    error('Material "%s" not found.',materialName);
end

rho   = A{2}(idx);
E     = A{3}(idx);
nu    = A{4}(idx);
aL    = A{5}(idx);
aT    = A{6}(idx);

% Real Lamé parameters

lambda = E*nu/((1+nu)*(1-2*nu));
mu      = E/(2*(1+nu));

% Velocities

cL = sqrt((lambda+2*mu)/rho);
cT = sqrt(mu/rho);

cL_complex = cL/(1+1i*aL/(2*pi));
cT_complex = cT/(1+1i*aT/(2*pi));

% Complex Lamé parameters
Mu_real = rho*cT^2*4*pi^2*(4*pi^2-aT^2)/(aT^2+4*pi^2)^2;
Mu_imag = rho*cT^2*4*pi^2*(4*pi*aT)/(aT^2+4*pi^2)^2;

Lambda_real = rho*cL^2*4*pi^2*(4*pi^2-aL^2)/(aL^2+4*pi^2)^2 ...
              - 2*Mu_real;

Lambda_imag = rho*cL^2*4*pi^2*(4*pi*aL)/(aL^2+4*pi^2)^2 ...
              - 2*Mu_imag;

lambda_complex = Lambda_real + 1i*Lambda_imag;
mu_complex     = Mu_real + 1i*Mu_imag;

E_complex = mu_complex .* ...
    ((3*lambda_complex + 2*mu_complex) ./ ...
     (lambda_complex + mu_complex));

nu_complex = ...
    lambda_complex ./ ...
    (2*(lambda_complex + mu_complex));

% Stiffness matrix

C = [
lambda_complex+2*mu_complex lambda_complex              lambda_complex              0 0 0
lambda_complex              lambda_complex+2*mu_complex lambda_complex              0 0 0
lambda_complex              lambda_complex              lambda_complex+2*mu_complex 0 0 0
0                            0                           0                           mu_complex 0 0
0                            0                           0                           0 mu_complex 0
0                            0                           0                           0 0 mu_complex
];

mat.Name = materialName;
mat.Class = 'Isotropic';

mat.Density = rho;

mat.YoungsModulus = E;
mat.YoungsModulus_complex = E_complex;

mat.PoissonsNumber = nu;
mat.PoissonsNumber_complex = nu_complex;

mat.LongitudinalAttenuation = aL;
mat.TransverseAttenuation = aT;

mat.Lambda = lambda;
mat.Lambda_complex = lambda_complex;

mat.Mu = mu;
mat.Mu_complex = mu_complex;

mat.LongitudinalVelocity = cL;
mat.LongitudinalVelocity_complex = cL_complex;

mat.TransverseVelocity = cT;
mat.TransverseVelocity_complex = cT_complex;

mat.PlateVelocity = sqrt(E/(rho*(1-nu^2)));
mat.CylinderVelocity = sqrt(E/rho);
mat.RayleighVelocity = cT*((0.87+1.12*nu)/(1+nu));

mat.C = C;

end