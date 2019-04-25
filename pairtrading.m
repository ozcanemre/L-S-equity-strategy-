
% load your Stock prices as Pricemat in matrix form and Dates as dates in
% vector form.

NumStocks = size(PriceMat,2);

CointMatrix = zeros(NumStocks);

% Pair selection part.
% create a Cointegration matrix

% Go through the list of stocks and test for cointegration and eliminate
% pairs that fail the test.
for idx = 1:NumStocks;

for jdx=idx+1:NumStocks

CointMatrix(idx,jdx)=ForCoint(PriceMat(:,idx),PriceMat(:,jdx));

end

end



[rows,cols]=find(CointMatrix);

CointPairs = [rows cols];

cf=(CointPairs(:,1)-CointPairs(:,2))==0;

% Testing for Tradability, residual series would be stationary ; pairs
% trading is a bet that the residual series will revert to its mean. WE
% take the pairs R-squared from the regression is above 0,90 exceeding the
% two standar deviation. 
CointPairs(cf,:)=[];
Bhat=[];
r=[];
stats=[];
limit=0.90; % limit for Regression R square 
k=[];
for P = 1:size(CointPairs,1)
% Look at the regression founded
Y = log(PriceMat(:,CointPairs(P,1)));
X = log(PriceMat(:,CointPairs(P,2)));
% get coeficients of the regression statistics
[B,BINT,R,RINT,STATS] = regress(Y,[ones(length(X),1) X(1:end)]);
r=[R r];
stats=[STATS(1,1)' stats];
Bhat=[B(2)' Bhat];
% find the values that exceed the limit we set.
Z=(stats>limit);
if any(Z)
K=find(Z);
else
K=0;
end
k=[K k];
end

figure % set up dates ticks
h=plot(Dates,Dates); 

a=get(gca,'XTick');

XTick = [];

years = year(Dates(1)):year(Dates(end));

for n = years
XTick = [XTick datenum(n,1,1)];
end
a=min(Dates); 
b=max(Dates); 
X_Lim=[a-.01*(b-a) b+.01*(b-a)];
close

Pairres=r(:,K);
Sigma=std(Pairres);
Uppersigma=Sigma.*2;
Lowersigma=Sigma.*(-2);
[S1 S2]=size(Pairres);

