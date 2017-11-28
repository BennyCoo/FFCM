function crsp = setMomentum(crsp)


dateList=unique(crsp.datetime);

permnoList=unique(crsp.PERMNO);

crsp{:, 'momentum'} = NaN;


for thisPermno = permnoList'
    whichRows = crsp.PERMNO == thisPermno;
    for thisDate = dateList'
        %there is a problem with thisRow. it's is always a zero vector :(
        thisRow = whichRows & crsp.datetime == thisDate;
        if (any(thisRow))
            thisMomentum = getMomentum(thisPermno, thisDate, crsp);
            crsp.momentum(thisRow) = thisMomentum;
        end
    end
    
end
end
        
        