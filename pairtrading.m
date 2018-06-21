
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

for n=1:S2;
pairres=(Pairres(:,n));
Sigma=std(Pairres);
Uppersigmaf=Sigma.*1;
Lowersigmaf=Sigma.*(-1);
Uppersigmas=Sigma.*2;
Lowersigmas=Sigma.*(-2);

figure
uppersigma=0*Dates+Sigma(n);
lowersigma=0*Dates-Sigma(n);
uppersigmaf=0*Dates+Uppersigmaf(n);
lowersigmaf=0*Dates+Lowersigmaf(n);
uppersigmas=0*Dates+Uppersigmas(n);
lowersigmas=0*Dates+Lowersigmas(n);
Z=0*Dates;
plot(Dates,pairres)
hold on
plot(Dates,uppersigmas,'r','linewidth',1)
hold on
plot(Dates,lowersigmas,'r','linewidth',1)
hold on
plot(Dates,uppersigmaf,'g','linewidth',1)
hold on
plot(Dates,lowersigmaf,'g','linewidth',1)
hold on
plot(Dates,uppersigma,'b','linewidth',1)
hold on
plot(Dates,lowersigma,'b','linewidth',1)
hold on
plot(Dates,Z,'k','linewidth',1)
hold on
set(gca,'xlim',X_Lim,'XTick',XTick);
datetick('x','yy','keeplimits','keepticks');
grid off
title(['Pair ' num2str(n)] ,'FontWeight','bold');
xlabel('year','FontWeight','bold');
ylabel('Basis','FontWeight','bold');
end