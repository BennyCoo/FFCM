function crsp = computeWeights(crsp)

%% this function appends to crsp
%It computes the weight that should be invested in a stock at a point in
%time. It takes into account previous weight in the stock. When selling,
%sell the full weight of the stock. When buying, buy based on available
%portfolio weight liberated by selling at that point in time.

%%
    
    dateList = sort(unique(crsp.datenum));
    
    crsp = sortrows(crsp, {'PERMNO', 'datenum'});
    
    crsp{:, 'stockWeights'} = NaN;
    
    %handle first row (still work to do)
    %crsp.stockWeight(1) = 1/sum(crsp.datenum == crsp.datenum(1) & crsp.Buy ==1);
    
    for i = 2: height(crsp)
        
        if(crsp.PERMNO(i-1) == crsp.PERMNO(i))
            
            if(crsp.stockWeights(i-1) == 0 && crsp.Buy(i) ==1)
                
                %total weight of the portfolio sold at this date
                whichRows = crsp.datenum == crsp.datenum(i)& crsp.stockWeights>0 & crsp.Sell ==1;
                sales = nansum(crsp.stockWeights(whichRows));
                
                if (sales == 0)
                    currentWeighting  = 1/nansum(crsp.Buy(crsp.datenum == crsp.datenum(i)));
                else
                    %number (integer) of new stocks purchased
                    newStocksPurchased = nansum(crsp.Buy(crsp.datenum == crsp.datenum(i)& crsp.stockWeights==0));
                
                    %weight invested in new purchases at this date
                    currentWeighting = (1 - sales)/ newStocksPurchased;
                end
                %value assignment
                crsp.stockWeights(i) = currentWeighting;
            
            elseif (crsp.Sell(i)==1)
                crsp.stockWeights(i) = 0;
            else
                crsp.stockWeights(i) = crsp.stockWeights(i-1);
            end
        else
            %case where this is the min time in framework
            if(crsp.Buy(i) ==1 && crsp.datenum(i) ==dateList(1))
                crsp.stockWeights(i) = 1/nansum(crsp.Buy(crsp.datenum == dateList(1) & crsp.Buy ==1));
           
            elseif (crsp.Buy(i) ==1)
                
                idx = dateList == crsp.datenum(i);
                thisDate = dateList(idx-1);
                    
                
                %total weight of the portfolio sold on this date
                sales = nansum(crsp.stockWeights(crsp.datenum == thisDate & crsp.stockWeights>0 & crsp.Sell ==1));
                
                %number (integer) of new stocks purchased
                newStocksPurchased = nansum(crsp.Buy(crsp.datenum == thisDate & crsp.stockWeights==0));
                
                %weight invested in new purchases on this date
                currentWeighting = (1 - sales)/ newStocksPurchased;
                
                %value assignment
                crsp.stockWeights(i) = crsp.Buy(i)*currentWeighting;
            
            else
                crsp.stockWeights(i) = 0;
            end
        end
        
    end
end
