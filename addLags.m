function crsp=addLags(variableList,k,crsp)
variableListOut=strcat('lag',num2str(k),variableList);

%Sort by permno, date
crsp=sortrows(crsp,{'PERMNO','datenum'});

% Keep variables to be lagged, along with permnos
crspLag= crsp(:,['PERMNO' variableList]);

%Fill part of crspLag with lag variables
crspLag((k+1):end,:)=crspLag(1:(end-k),:);
%Fill header of crspLag with NaN
crspLag{1:k,:}=NaN;

%Where lagged parmno != current permno, the lag variables should be NaN
crspLag{crspLag.PERMNO~=crsp.PERMNO,variableList}=NaN;

%Weld lagged variables onto output table ''crsp'' with the appropriate
%table names
crsp(:,variableListOut)=crspLag(:,variableList);


end