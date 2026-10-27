function a = setMaterial(a, mats)
    % takes a cell array of materials (created with LoadHuberIsotropicModel
    % or MakeIsotropicMaterial) and applies them to the model, a.

    for ii = 1:length(mats)
        a.Material2{ii} = mats{ii};
    end
end