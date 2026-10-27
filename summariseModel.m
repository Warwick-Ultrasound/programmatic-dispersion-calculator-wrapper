function summariseModel(a)
    % there are a lot of parameters to control the model, this function
    % displays some of the important ones so that you can check everything
    % is configured properly.

    fprintf('Model configuration summary:\n');
    fprintf('Symmetry = %g\n', a.SymmetricSystem);
    fprintf('Materials:\n');
    for ii = 1:length(a.Material2)
        fprintf('%s %gum\n', a.Material2{ii}.Name, a.LayerThicknesses(ii)*1000);
    end
    fprintf('Frequency %g - %g kHz in steps of %g kHz\n', a.FrequencyRangeStart2, a.FrequencyLimit2, a.FrequencyResolution2);

end