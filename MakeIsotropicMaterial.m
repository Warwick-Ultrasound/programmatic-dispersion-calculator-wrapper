function mat = MakeIsotropicMaterial(name,rho,E,nu)
    % Make isotropic material for Huber Dispersion Calculator
    %
    % name : string
    % rho  : density (kg/m^3)
    % E    : Young's modulus (Pa)
    % nu   : Poisson's ratio

    % Lamé constants
    lambda = E*nu / ((1+nu)*(1-2*nu));
    mu     = E/(2*(1+nu));

    % Velocities
    cL = sqrt((lambda + 2*mu)/rho);
    cT = sqrt(mu/rho);

    % Other velocities used by Huber
    cPlate    = sqrt(E/(rho*(1-nu^2)));
    cCylinder = sqrt(E/rho);
    cRayleigh = cT*((0.87 + 1.12*nu)/(1 + nu));

    % 6x6 stiffness matrix
    C = [
        lambda+2*mu, lambda,        lambda,        0, 0, 0;
        lambda,      lambda+2*mu,   lambda,        0, 0, 0;
        lambda,      lambda,        lambda+2*mu,   0, 0, 0;
        0,           0,             0,             mu,0,0;
        0,           0,             0,             0,mu,0;
        0,           0,             0,             0,0,mu
        ];

    % Build structure
    mat = struct();

    mat.Name = name;
    mat.Class = 'Isotropic';

    mat.Density = rho;

    mat.YoungsModulus = E;
    mat.YoungsModulus_complex = E;

    mat.PoissonsNumber = nu;
    mat.PoissonsNumber_complex = nu;

    mat.LongitudinalAttenuation = 0;
    mat.TransverseAttenuation   = 0;

    mat.Lambda = lambda;
    mat.Lambda_complex = lambda;

    mat.Mu = mu;
    mat.Mu_complex = mu;

    mat.LongitudinalVelocity = cL;
    mat.LongitudinalVelocity_complex = cL;

    mat.TransverseVelocity = cT;
    mat.TransverseVelocity_complex = cT;

    mat.PlateVelocity = cPlate;
    mat.CylinderVelocity = cCylinder;
    mat.RayleighVelocity = cRayleigh;

    mat.C = C;

end