function a = setThickness(a, thick)
    % sets the thicknesses of the layers. Remember that if using a
    % symmetric model the middle layer will be doubled in thickness.

    a.LayerThicknesses = thick;
    if a.SymmetricSystem
        a.PlateThickness = 2*sum(a.LayerThicknesses);
    else
        a.PlateThickness = sum(a.LayerThicknesses);
    end
end