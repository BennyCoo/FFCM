function crsp=derive(variableList, crsp)
    crsp = addLags(['datenum' variableList], 1, crsp);
    
    permnoLag=nan(height(crsp), 1);
    permnoLag(2:end, 1)= crsp{1:(end-1), ['PERMNO']};
    
    laggedVars = strcat('lag1', variableList);
    newVars = strcat(variableList, '_derived');
    
    dx = crsp{:, 'datenum'} - crsp{:, 'lag1datenum'};
    
    for i=1:length(variableList)
        var = variableList(i);
        newVar = newVars(i);
        laggedVar = laggedVars(i);
        
        crsp{:, newVar} = (crsp{:, var} - crsp{:, laggedVar}) ./ dx;
    end
    crsp{permnoLag~=crsp.PERMNO, newVars}=NaN;
end
