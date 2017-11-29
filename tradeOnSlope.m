function portfolio = tradeOnSlope (thisDate, crsp, optionalArguments)
%% Get date from investible universe
%Match by date
isInvestible= crsp.datenum==thisDate;

%Require that stock is currently still trading (has valid return)
isInvestible= isInvestible & ~isnan(crsp.RET);

%Extrade relevant data from crsp.
thisCrsp=crsp(isInvestible,:);

%Standardize investment weights to make sure that 1) There's no short
%position 

thisCrsp{:,'w'}=0;

% and 2) weights add up to 1.

thisCrsp.w=thisCrsp.Ownership./nansum(thisCrsp.Ownership);
portfolio=thisCrsp(:,{'PERMNO','w','RET'});