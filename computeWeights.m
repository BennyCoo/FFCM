function crsp = computeWeights(crsp)
    
    dateList = sort(unique(crsp.datetime));
    
    crsp = sortrows(crsp, {'PERMNO', 'datetime'});
    
    crsp{:, 'stockWeights'} = Nan;
    
    %handle first row (still work to do)
    %crsp.stockWeight(1) = 1/sum(crsp.datenum == crsp.datenum(1) & crsp.buy ==1);
    
    for i = 2: height(crsp)
        
        if(crsp.PERMNO(i-1) == crsp.PERMNO(i))
            
            if(crsp.stockWeight(i-1) == 0 && crsp.buy(i) ==1)
                
                %total weight of the portfolio sold at this date
                sales = sum(crsp.stockWeight(crsp.datenum == crsp.datenum(i-1) & crsp.stockWeight>0 & crsp.sell ==1));
                
                %number (integer) of new stocks purchased
                newStocksPurchased = sum(crsp.buy(crsp.datenum == crsp.datenum(i-1)& crsp.stockWeight==0));
                
                %weight invested in new purchases at this date
                currentWeighting = (1 - sales)/ newStocksPurchased;
                
                %value assignment
                crsp.stockWeight(i) = crsp.buy(i)*currentWeighting;
            
            elseif (crsp.sell(i)==1)
                crsp.stockWeight(i) = 0;
            else
                crsp.stockWeight(i) = crsp.stockWeight(i-1);
            end
        else
            %case where this is the min time in framework
            if(crsp.buy(i) ==1 && crsp.datetime(i) ==dateList(1))
                crsp.stockWeight(i) = 1/sum(crsp.datenum == dateList(1) & crsp.buy ==1);
           
            elseif (crsp.buy(i) ==1)
                
                idx = dateList == crsp.datetime(i);
                thisDate = dateList(idx-1);
                    
                
                %total weight of the portfolio sold at this date
                sales = sum(crsp.stockWeight(crsp.datenum == thisDate) & crsp.stockWeight>0 & crsp.sell ==1));
                
                %number (integer) of new stocks purchased
                newStocksPurchased = sum(crsp.buy(crsp.datenum == thisDate & crsp.stockWeight==0));
                
                %weight invested in new purchases at this date
                currentWeighting = (1 - sales)/ newStocksPurchased;
                
                %value assignment
                crsp.stockWeight(i) = crsp.buy(i)*currentWeighting;
            
            else
                crsp.stockWeight(i) = 0;
            end
        end
        
    end
end
