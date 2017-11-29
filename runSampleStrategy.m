% crsp=readtable('testData.csv');

% %Create testData.csv
% crsp=readtable('crspCompustatMerged_2010_2014_dailyReturns.csv');
% permnoList=unique(crsp.PERMNO);
% permnoList=randsample(permnoList,100);
% crsp=crsp(ismember(crsp.PERMNO,permnoList),:);
% writetable(crsp,'crspTest.csv');

% ff3=readtable('ff3.csv');
% ff3.datenum=datenum(num2str(ff3.date),'yyyymmdd');
% ff3{:,{'mrp','hml','smb'}}=ff3{:,{'mrp','hml','smb'}}/100;
% writetable(ff3(2010<=year(ff3.datenum)&year(ff3.datenum)<=2014,:),'ff3_20102014.csv')

%% Load ff3 data
ff3=readtable('ff3.csv');

%%
crsp=readtable('crspTest.csv');
% crsp=readtable('crspCompustatMerged_2010_2014_dailyReturns.csv');

% if test file...
% crsp.Properties.VariableNames{'adjustedPrice'} = 'prc';

crsp.datenum=datenum(num2str(crsp.DATE),'yyyymmdd');

%% Calculate momentum size and value
% 
% crsp=addLags({'ME','BE'},2,crsp);
% 
% crsp.size=crsp.lag2ME;
% crsp.value=crsp.lag2BE./crsp.lag2ME;

%Calculate momentum
% crsp=addLags({'prc'},21,crsp);
% crsp=addLags({'prc'},252,crsp);
% crsp.momentum=crsp.lag21prc./crsp.lag252prc;
% 
% crsp=addRank({'size','value','momentum'},crsp);

params=[20, 50];

%add EWMA rank here
crsp=addEWMA({'RET'},params(1),crsp);
crsp=addEWMA({'RET'},params(2),crsp);

exponentialAverageVariables = {'ewma20RET', 'ewma50RET'};

% addLags(exponentialAverageVariables, 1, crsp);
crsp = derive(exponentialAverageVariables, crsp);

buyThreshold = 0;
sellThreshold = 0;

crsp.Buy = crsp.ewma20RET_derived > buyThreshold ...
         & crsp.ewma50RET_derived > buyThreshold;
     
crsp.Sell = crsp.ewma20RET_derived < sellThreshold ...
          & crsp.ewma50RET_derived < sellThreshold;

crsp = makeWeights(crsp);

% buy = a > 0 && b > 0;
% sell = a < 0 && b < 0;
dateList=unique(crsp.datenum);

%Track strategy positions
thisStrategy=table(dateList,'VariableNames',{'datenum'});

%Create empty column of cells for investment weight tables
thisStrategy{:,'portfolio'}={NaN};


%Create empty column of NaNs for ret
thisStrategy{:,'ret'}=NaN;
thisStrategy{:,'turnover'}=NaN;


%Run first iteration separately since there's no turnover to calculate
i = 1;
    
thisDate=thisStrategy.datenum(i);
thisPortfolio=tradeOnSlope(thisDate,crsp);    
thisStrategy.portfolio(i)={thisPortfolio}; %Bubble wrap the table of investment weights and store in thisStrategy

%if (sum(~isnan(thisPortfolio.w))>0)
    %Calculate returns if there's at least one valid position
    %thisStrategy.ret(i)=nansum(thisPortfolio.RET.*thisPortfolio.w);


    %changePortfolio=outerjoin(thisPortfolio(:,{'PERMNO','w'}),lastPortfolio(:,{'PERMNO','w'}),'Keys','PERMNO');
    %Fill missing positions with zeros
    %changePortfolio=fillmissing( changePortfolio,'constant',0);
    %thisStrategy.turnover(i)=nansum(abs(changePortfolio.w_left-changePortfolio.w_right))/2;

%end
    
for i = 2:size(thisStrategy,1)
    
    thisDate=thisStrategy.datenum(i);
    lastPortfolio=thisPortfolio;
    thisPortfolio=tradeOnSlope(thisDate,crsp);    
    thisStrategy.portfolio(i)={thisPortfolio}; %Bubble wrap the table of investment weights and store in thisStrategy
    
    if (sum(~isnan(thisPortfolio.w))>0)
        %Calculate returns if there's at least one valid position
        thisStrategy.ret(i)=nansum(thisPortfolio.RET.*thisPortfolio.w);
        
        changePortfolio=outerjoin(thisPortfolio(:,{'PERMNO','w'}),lastPortfolio(:,{'PERMNO','w'}),'Keys','PERMNO');
        %Fill missing positions with zeros
        changePortfolio=fillmissing(changePortfolio,'constant',0);
        thisStrategy.turnover(i)=nansum(abs(changePortfolio.w_left-changePortfolio.w_right))/2;

    end 
    
end


thisPerformance=evaluateStrategy_m(thisStrategy,ff3);

save('sampleStrat');

%Plot cumulative returns with dateticks
%plot(thisPerformance.thisStrategy.datenum,thisPerformance.thisStrategy.cumLogRet);
%datetick('x','yyyy-mm', 'keepticks', 'keeplimits')
