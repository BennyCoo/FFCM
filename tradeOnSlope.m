function portfolio = tradeOnSlope (date, crsp)
    idx = crsp.datenum == date;
    portfolio=crsp(idx, {'PERMNO', 'w', 'RET'});
end
