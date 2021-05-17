% Generates the Mult-Objective Anthrax Response Problem
% by Harold Soh, haroldsoh@imperial.ac.uk
% This problem is adapted from the POMDP by Izadi and Buckeridge (See Ref below). This POMDP is comprised of six states (“normal”, “ outbreak day 1” to “outbreak day 4” and “detected”) with two observations (“suspicious” and “not suspicious”) and four actions (“de-clare outbreak”, “review records”, “systematic studies” and “wait”). The original POMDP used a relatively complex reward function that combined the economic costs from multiple sources such as productivity loss, investigative costs, hospitalisation and medical treat- ment. In our multi-objective formulation, we have three-objectives to minimise: loss of life, number of false alarms and cost of investigation (in man-hours). 
% If used in research, please cite papers the papers in the README and:

% M.T. Izadi and D. Buckeridge. Decision Theoretic Analysis of Improving Epidemic Detection. American Medial Informatics Association (AMIA). Chicago, USA, 2007.

discountFactor = 0.999;


%set number of objectives
pd = 1;% number of  deaths 
fa = 2;% number of false alarms
cs = 3;% cost of investigation


%   pd = 1;% number of deaths 
%   fa = 2;% number of false alarms
%   cs = 3;% cost of intervention
%   nf = 4;% number of non-fatal exposures
%   du = 5;% number of drugs used

nObj = 3; %ignore the number of drugs used for now 
nR = nObj;

%set number of actions
%4 actions: 
dc = 1; % declare
ss = 2;% systematic studies
rr = 3;% review records
wt = 4;% wait
nA = 4; 

%number of states = number of days (6)
% normal, day1, day2, day3, day4, detected
nn = 1;
d1 = 2;
d2 = 3;
d3 = 4;
d4 = 5;
dt = 6;

nS = 6;


%number of observations
%suspicious
%non-suspicious
nO = 2;

%================================================
%create transition matrix
Tp = zeros(nS, nA, nS);

%declare action
for s=2:nS-1
    Tp(s,dc,dt) = 1.0;
end;
Tp(nn,dc,d1) = 0.01;
Tp(nn,dc,nn) = 0.99;
Tp(dt,dc,nn) = 1.0;


for a=1:nA
    Tp(dt,a,dt) = 0.0;
end;


%systematic studies
Tp(nn,ss,nn) = 0.99;
Tp(nn,ss,d1) = 0.01;
Tp(d1,ss,d3) = 0.80;
Tp(d1,ss,dt) = 0.20;
Tp(d2,ss,d4) = 0.60;
Tp(d2,ss,dt) = 0.40;
Tp(d3,ss,dt) = 1.0;
Tp(d4,ss,dt) = 1.0;
Tp(dt,ss,nn) = 1.0;

%review records
Tp(nn,rr,nn) = 0.99;
Tp(nn,rr,d1) = 0.01;
Tp(d1,rr,d2) = 0.90;
Tp(d1,rr,dt) = 0.1;
Tp(d2,rr,d3) = 0.8;
Tp(d2,rr,dt) = 0.2;
Tp(d3,rr,d4) = 0.5;
Tp(d3,rr,dt) = 0.5;
Tp(d4,rr,dt) = 1.0;
Tp(dt,rr,nn) = 1.0;

%wait
Tp(nn,wt,nn) = 0.99;
Tp(nn,wt,d1) = 0.01;
Tp(d1,wt,d2) = 1.0;
Tp(d2,wt,d3) = 1.0;
Tp(d3,wt,d4) = 1.0;
Tp(d4,wt,dt) = 1.0;
Tp(dt,wt,nn) = 1.0;

%================================================

%observation matrix
suspicious=1;
notsuspicious=2;
Op = zeros(nS, nO);
Op(nn,suspicious) = 0.03;
Op(d1,suspicious) = 0.17;
Op(d2,suspicious) = 0.45;
Op(d3,suspicious) = 0.67;
Op(d4,suspicious) = 0.90;
Op(dt,suspicious) = 1.00;

for s=1:nS
    Op(s,notsuspicious) = 1.0 - Op(s,suspicious);
end;

%================================================


%reward matrices
%we keep track of how many of each item we sell
rVal = zeros(nS, nA, nS, nR);

%recall:
%   pd = 1;% number of deaths 
%   fa = 2;% number of false alarms
%   cs = 3;% cost of intervention
%   nf = 4;% number of non-fatal exposures
%   du = 5;% number of drugs used


%preventable deaths
% assuming 90% efficacy 
% start of postattack intervention - number of deaths 
% 0 - 6.38596
% 1 - 9.08772
% 2 - 14.36842
% 3 - 23.33333
% 4 - 28.12281
% 5 - 30.70175
% 6 - 32.05263

%number of hospitalization days
% 0 - 6.50877
% 1 - 9.21053
% 2 - 14.24561
% 3 - 23.33333
% 4 - 28.36842
% 5 - 31.19298
% 6 - 32.42105

%outpatient visits
% 0 - 0.73684
% 1 - 1.22807
% 2 - 1.96491
% 3 - 3.19298
% 4 - 3.80702
% 5 - 4.29825
% 6 - 4.42105


%for a=1:nA
%    if (Tp(d1,a,dt) > 0)
%      rVal(d1,a,dt,pd) = -6.385;
%    end;
%    if (Tp(d2,a,dt) > 0)
%      rVal(d2,a,dt,pd) = -9.087;
%    end;
%    if (Tp(d3,a,dt) > 0)
%      rVal(d3,a,dt,pd) = -14.368;
%    end;
%    if (Tp(d4,a,dt) > 0)
%      rVal(d4,a,dt,pd) = -23.333;
%    end;
%end;

%declare
typemode =0 ;
if typemode == 0
    
%     rVal(d1,dc,dt,pd) = -6.385;
%     rVal(d2,dc,dt,pd) = -9.087;
%     rVal(d3,dc,dt,pd) = -14.368;
%     rVal(d4,dc,dt,pd) = -23.333;
% 
% 
%     %systematic studies
%     rVal(d1,ss,dt,pd) = -9.087;
%     rVal(d2,ss,dt,pd) = -14.368;
%     rVal(d3,ss,dt,pd) = -23.333;
%     rVal(d4,ss,dt,pd) = -23.333;
% 
% 
%     %review records
%     rVal(d1,rr,dt,pd) = -6.385;
%     rVal(d2,rr,dt,pd) = -9.087;
%     rVal(d3,rr,dt,pd) = -14.368;
%     rVal(d4,rr,dt,pd) = -23.333;
% 
%     %wait
%     rVal(d4,wt,dt,pd) =  -23.333;
    rVal(d1,dc,dt,pd) = -6385;
    rVal(d2,dc,dt,pd) = -9087;
    rVal(d3,dc,dt,pd) = -14368;
    rVal(d4,dc,dt,pd) = -23333;


    %systematic studies
    rVal(d1,ss,dt,pd) = -9087;
    rVal(d2,ss,dt,pd) = -14368;
    rVal(d3,ss,dt,pd) = -23333;
    rVal(d4,ss,dt,pd) = -23333;


    %review records
    rVal(d1,rr,dt,pd) = -6385;
    rVal(d2,rr,dt,pd) = -9087;
    rVal(d3,rr,dt,pd) = -14368;
    rVal(d4,rr,dt,pd) = -23333;

    %wait
    rVal(d4,wt,dt,pd) =  -23333;


elseif typemode == 1
    % we use number of lives saved
    
    rVal(d1,dc,dt,pd) = 23.333-6.385;
    rVal(d2,dc,dt,pd) = 23.333-9.087;
    rVal(d3,dc,dt,pd) = 23.333-14.368;
    rVal(d4,dc,dt,pd) = 23.333-23.333;


    %systematic studies
    rVal(d1,ss,dt,pd) = 23.333-9.087;
    rVal(d2,ss,dt,pd) = 23.333-14.368;
    rVal(d3,ss,dt,pd) = 23.333-23.333;
    rVal(d4,ss,dt,pd) = 23.333-23.333;


    %review records
    rVal(d1,rr,dt,pd) = 23.333-6.385;
    rVal(d2,rr,dt,pd) = 23.333-9.087;
    rVal(d3,rr,dt,pd) = 23.333-14.368;
    rVal(d4,rr,dt,pd) = 23.333-23.333;

    %wait  
    rVal(d4,wt,dt,pd) =  23.333-23.333;  
 end;


%rVal(dt,dc,dt,pd) = -28.12281*1000;

%false alarms
rVal(nn,dc,d1,fa) = -1;
rVal(nn,dc,nn,fa) = -1;


%cost of intervention in terms of man hours
%review records takes 0.5 days
%systematic takes 1.0000 day
if (nR > 2) 
for s=1:nS
    for s2=1:nS
        if (Tp(s,rr,s2) > 0)
            rVal(s,rr,s2,cs) = -0.5;
        end;
    end;
end;

for s=1:nS
    for s2=1:nS
        if (Tp(s,ss,s2) > 0)
            rVal(s,ss,s2,cs) = -1;
        end;
    end;
end;
end;




%prevented non-fatal exposures
%for a=1:nA
%    rVal(d1,a,dt,pd) = -6.50877*1000;
%    rVal(d2,a,dt,pd) = -9.21053*1000;
%    rVal(d3,a,dt,pd) = -14.24561*1000;
%    rVal(d4,a,dt,pd) = -23.33333*1000;
%end;
%number of drugs used
%rVal(nn,dc,dt,du) = 0;




%================================================

%initial states
pStartStates = zeros(nS);
pStartStates(1) = 1.0;

%output to file
mrpomdpfile = fopen(strcat('anthraxM', int2str(nR), '.pomdp'), 'w');
fprintf(mrpomdpfile, '%d\n', nS);
fprintf(mrpomdpfile, '%d\n', nA);
fprintf(mrpomdpfile, '%d\n', nO);
fprintf(mrpomdpfile, '%d\n', nR);
fprintf(mrpomdpfile, '%f\n', discountFactor);
 
%output observation matrix
for i=1:nS
	for j=1:nO
		fprintf(mrpomdpfile, '%f\t', Op(i,j));
	end;
	fprintf(mrpomdpfile, '\n');
end;

%output transition matrix
for i=1:nS
	for a=1:nA
		for j=1:nS
			fprintf(mrpomdpfile, '%f\t', Tp(i,a,j));
		end;
		fprintf(mrpomdpfile, '\n');
	end;
end;

%ouput reward matrix
for r=1:nR
	for i=1:nS
		for a=1:nA
			for j=1:nS
				fprintf(mrpomdpfile, '%f\t', rVal(i,a,j,r));
			end;
			fprintf(mrpomdpfile, '\n');
		end;
	end;
end;

%output start scenario
for i=1:nS
	fprintf(mrpomdpfile, '%f\n', pStartStates(i));	
end;

fclose(mrpomdpfile);
