function PlotDispersion(results,yVariable,modes)

% PlotDispersion
%
% Examples:
%
% PlotDispersion(results,'cp')
%
% PlotDispersion(results,'cg',{'S0','A0'})
%
% PlotDispersion(results,'wavenumber',{'A0'})
%

if nargin < 2
    yVariable = 'cp';
end

if nargin < 3
    modes = {};
end

figure
hold on
grid on
box on

% --- Build catalogue of available modes

modeMap = {};

for n = 1:numel(results.SLamb)
    if ~isempty(results.SLamb{n})
        modeMap(end+1,:) = {sprintf('S%d',n-1),results.SLamb{n}};
    end
end

for n = 1:numel(results.ALamb)
    if ~isempty(results.ALamb{n})
        modeMap(end+1,:) = {sprintf('A%d',n-1),results.ALamb{n}};
    end
end

for n = 1:numel(results.BLamb)
    if ~isempty(results.BLamb{n})
        modeMap(end+1,:) = {sprintf('B%d',n-1),results.BLamb{n}};
    end
end

for n = 1:numel(results.SShear)
    if ~isempty(results.SShear{n})
        modeMap(end+1,:) = {sprintf('SSH%d',n-1),results.SShear{n}};
    end
end

for n = 1:numel(results.AShear)
    if ~isempty(results.AShear{n})
        modeMap(end+1,:) = {sprintf('ASH%d',n),results.AShear{n}};
    end
end

for n = 1:numel(results.BShear)
    if ~isempty(results.BShear{n})
        modeMap(end+1,:) = {sprintf('BSH%d',n-1),results.BShear{n}};
    end
end

% --- If no mode list supplied, plot everything

if isempty(modes)
    modes = modeMap(:,1);
end

% --- Plot requested modes

for n = 1:size(modeMap,1)

    modeName = modeMap{n,1};

    if ~any(strcmp(modeName,modes))
        continue
    end

    T = modeMap{n,2};

    plot( ...
        T.f/1E3,...
        T.(yVariable),...
        'DisplayName',modeName,...
        'LineWidth',1.5);

end

legend('Location','best')

xlabel('Frequency /kHz')

ylabel(VariableLabel(yVariable))

title('Dispersion Curves')

end


function label = VariableLabel(var)

switch lower(var)

    case 'cp'
        label = 'Phase Velocity /m/s';

    case 'cg'
        label = 'Group Velocity /m/s';

    case 'alpha'
        label = 'Attenuation /Np/m';

    case 'wavelength'
        label = 'Wavelength /m';

    case 'wavenumber'
        label = 'Wavenumber rad/m';

    case 'fd'
        label = 'Frequency-Thickness /Hz-mm';

    otherwise
        label = var;

end

end