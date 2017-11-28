function crsp=addEWMA(variableList,k,crsp)

variableListOut=strcat('ewma',num2str(k),variableList);

%Sort by permno, date
crsp=sortrows(crsp,{'PERMNO','datenum'});

%Create empty columns
crsp{:,variableListOut}=NaN;

permnoList=unique(crsp.PERMNO);

for thisPermno = permnoList'
    %Fill in EWMA for one permno at a time
    whichRows=crsp.PERMNO==thisPermno&sum(~isnan(crsp{:,variableList}),2);
    thisCrsp=crsp{whichRows,variableList};
    if k<size(thisCrsp,1)
        crsp{whichRows,variableListOut}=tsmovavg(thisCrsp,'e',k,1);
    else
        crsp{whichRows,variableListOut}=NaN;
    end
end
end