function a = setSymmetry(a, str)
    % sets the symmetry of the model "on" or "off"

    if str == "on"
        a.SymmetricSystem = 1;
    elseif str == "off"
        a.SymmetricSystem = 0;
    else
        error("Invalid string input to setSymmetry.");
    end
end