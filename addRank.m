function crsp=addRank(variableList,crsp)

variableListOut=strcat(variableList,'Rank');

%Sort by date, permno
crsp=sortrows(crsp,{'datenum','PERMNO'});

%Create empty columns
crsp{:,variableListOut}=NaN;

dateList=unique(crsp.datenum);

for thisDate = dateList'
    %Fill in percentile ranks for one date at a time
    thisCrsp=crsp{crsp.datenum==thisDate,variableList};
    
    %Get number of non NaN observations in each column
    nValid=sum(~isnan(thisCrsp),1); %this is a 1 x K vector, where K=length(variableList)
    
    %Replace thisCrsp with the rank of the variable, 1 being the smallest
    thisCrsp=tiedrank(thisCrsp);%this is a N x K matrix, where K=length(variableList)
    
    %Calculate percentile rank = rank / N.
    %Store percentile ranks in new columns of crsp.
    crsp{crsp.datenum==thisDate,variableListOut}=thisCrsp./nValid;

end

%Resort by permno, date
crsp=sortrows(crsp,{'PERMNO','datenum'});


end