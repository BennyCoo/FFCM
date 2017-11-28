function momentum = getMomentum(thisPermno, thisDate, crsp)

    

    validateattributes(thisPermno, {'int', 'double'}, {'nonempty'});



    whichRows=crsp.PERMNO==thisPermno;

    dnow2 = thisDate - caldays(15);
    dprev1 = thisDate - calmonths(6);
    dprev2 = dprev1 - caldays(15);

    

    curidx = whichRows & (crsp.datetime <= thisDate) & (crsp.datetime >= dnow2) ;

    previdx = whichRows & (crsp.datetime <= dprev1) & (crsp.datetime >= dprev2);
    
    record = crsp(curidx,:);
    
    prevRecord = crsp(previdx,:);
    
    if (size(record,1) ==0 || size(prevRecord,1) ==0)

        momentum = NaN;

        return;

    end
    
    avgPriceNow = mean(crsp{curidx, 'adjustedPrice'});
    avgPricePrev = mean(crsp{previdx, 'adjustedPrice'});
    
    momentum = avgPricePrev / avgPriceNow - 1;

end