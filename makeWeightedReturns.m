function weightedReturns=makeWeightedReturns(crsp)
    uniqueDates = unique(crsp.datenum);
    rets = zeros(length(uniqueDates), 1);
    
    for i = 1 : length(uniqueDates)
        date = uniqueDates(i);
        dateidx = crsp.datenum == date;
        
        individualRets = crsp.RET(dateidx);
        individualWeights = crsp.w(dateidx);
        
        rets(i) = individualRets' * individualWeights;
        
    end
    
    weightedReturns = [uniqueDates, rets];
end