function crsp = newMomentum(monthLag, dayAvg, crsp)
    
    crsp=sortrows(crsp,{'PERMNO','datetime'});
    crsp{:, 'momentum'} = NaN;
    
    for thisRow = 1:height(crsp)
        thisPERMNO = crsp.PERMNO(thisRow);
        dr1 = crsp.datetime(thisRow);
        dr2 = dr1 - caldays(dayAvg);
        dp1 = dr1 - calmonths(monthLag);
        dp2 = dr2 - calmonths(monthLag);
        c1 = 0;
        c2 = 0;
        s1 = 0.0;
        s2 = 0.0;
        idx = thisRow;
        
        while (crsp.datetime(idx) >= dp2 & crsp.PERMNO(idx) == thisPERMNO)
            if(crsp.datetime(idx) <= dr1 & crsp.datetime(idx) >= dr2)
                c1 = c1 + 1;
                s1 = s1 + crsp.adjustedPrice(idx);
            end
            if (crsp.datetime(idx) <= dp1 & crsp.datetime(idx) >= dp2)
                c2 = c2 +1;
                s2 = s2 + crsp.adjustedPrice(idx);
            end
            if(idx >2)
                idx = idx -1;
            else
                break;
            end
        end
        
        if ( c1 ~= 0 & c2 ~= 0)
            crsp.momentum(thisRow) = ((s2/c2)/(s1/c1)) -1;
        end
    end
    
            
                
