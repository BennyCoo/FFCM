function crsp = makeWeights(crsp)
%     crsp.BuyOrSell = crsp.Buy - crsp.Sell;
%     crsp = addLags({'BuyOrSell'}, 1, crsp);
    
    crsp.Ownership = nan(height(crsp), 1);
    
    crsp.PERMNO_Lag = nan(height(crsp), 1);
    crsp.PERMNO_Lag(2:end, 1) = crsp.PERMNO(1:end-1, 1);
    
    idx = (~isnan(crsp.ewma20RET_derived) & ~isnan(crsp.ewma50RET_derived));
    
    crsp.BuyLag = nan(height(crsp), 1);
    crsp.SellLag = nan(height(crsp), 1);
    crsp.BuyLag(2:end, 1) = crsp.Buy(1:end-1, 1);
    crsp.SellLag(2:end, 1) = crsp.Sell(1:end-1, 1);
   
    crsp.Ownership(crsp.BuyLag(idx) == 1) = 1;
    crsp.Ownership(crsp.SellLag(idx) == 1) = 0;
    
    % ensure that first n are non-nan because cumsum will truncate
    % otherwise
    indexOfLastNan = 1;
    while isnan(crsp.Ownership(indexOfLastNan))
        crsp.Ownership(indexOfLastNan) = 0;
        indexOfLastNan = indexOfLastNan + 1;
    end
    % to ensure correct state, reset 1 : indexOfLastNan to nan.
    
    nonNan = (~isnan(crsp.Ownership));
    vr = crsp.Ownership(nonNan);
    crsp.Ownership = vr(cumsum(nonNan));
    
    crsp.Ownership(1:indexOfLastNan - 1) = nan(indexOfLastNan - 1, 1);
    
    uniqueDates = unique(crsp.datenum);
    totals = zeros(length(uniqueDates), 1);
    
    crsp.Totals = zeros(height(crsp), 1);
    crsp.w = zeros(height(crsp), 1);
    
    for i = 1:length(uniqueDates)
        date = uniqueDates(i);
        dateidx = crsp.datenum == date;
        totals(i) = sum(crsp.Ownership(dateidx));
        
        crsp.Totals(dateidx) = totals(i);
        subrangeOwnership = crsp.Ownership(dateidx);
        crsp.w(dateidx) = subrangeOwnership ./ totals(i);
        
    end
    
    crsp.w(isnan(crsp.ewma20RET_derived) | isnan(crsp.ewma50RET_derived)) = nan;
    
end