function portfolio = tradeOnSlope (thisDate, crsp, optionalArguments)
%% Get date from investible universe
%Match by date
isInvestible= crsp.datenum==thisDate;

%Require that stock is currently still trading (has valid return)
isInvestible= isInvestible & ~isnan(crsp.RET);

%Extrade relevant data from crsp.
thisCrsp=crsp(isInvestible,:);

portfolio=thisCrsp(:,{'PERMNO','weight','RET'});