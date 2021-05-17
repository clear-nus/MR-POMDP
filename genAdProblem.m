% Generates the Mult-Objective Advertising problem
% by Harold Soh, haroldsoh@imperial.ac.uk
% This problem is adapted from the POMDP by Cassandra where the objective was to maximise revenue from the sale of two products on an online-store. An intelligent advertising agent has to decide, based on the webpages that a customer visits, which product he is likely to be interested in and advertise accordingly. The right advertisement can result in a purchase but the wrong advertisement might cause the person to leave the store. We extended this problem to multiple objectives by modelling each product as an separate reward and by adding an additional reputation objective. The reputation of the site would decrease every time a person left the site as a result of a wrong advertisement


k = 1;

discountFactor = 0.99999;


%set number of objectives
nProd = 6; %number of products
nObj = nProd + 1; % the last objective is "reputation" which goes down 
                  % everytime we send someone away by showing the wrong ad
nR = nObj;

%set number of actions
nA = nProd + 1; %show ad for product or a general ad.

%set number of types of visitors
nVis = nProd;

%compute number of states
nS = nVis + nProd + 1; %the +1 is when the visitor leaves 

%number of observations
nO = nVis + nProd + 1;

%create transition matrix
Tp = zeros(nS, nA, nS);

mrpomdpfile = fopen(strcat('ad', int2str(nObj), '.pomdp'), 'w');

%for the visitor states
for s=1:nVis
    for a=1:nA
        if (a == s) 
            Tp(s,a,s) = 0.8; %stay
            Tp(s,a,nVis+s) = 0.05; %buy
            Tp(s,a,nS) = 0.15;
        elseif (a == nA) 
            %general ad
            Tp(s,a,s) = 2/3; %stay
            Tp(s,a,nS) = 1/3; %leave
        else 
            %wrong ad
            Tp(s,a,s) = 0.5; %stay
            Tp(s,a,nS) = 0.5; %leave           
        end;
    end;
end;

%for the buy states
for s=nVis+1:nS-1
    for a=1:nA
        for s2=1:nVis
            Tp(s,a,s2) = 1/nVis;
        end;
    end;
end;

%for the disconnect state
for a=1:nA
    for s=1:nVis
        Tp(nS, a, s) = 1/nVis;
    end;
end;

%observation matrix
Op = zeros(nS, nO);
for s=1:nVis
    sum = 0;
    for o=1:nVis
        Op(s,o) = exp(-1*abs(s-o));
        sum = sum + Op(s,o);
    end;
    for o=1:nVis
        Op(s,o) = Op(s,o)/sum;
    end;
end;

for s=nVis+1:nS-1
    Op(s,s) = 1.0;
end;

Op(nS,nS) = 1.0;
                

%reward matrices
%we keep track of how many of each item we sell
rVal = zeros(nS, nA, nS, nR);
for r=1:nR-1
    %we only get a reward if the user buys something
    for s=1:nVis
        for a=1:nA-1
            if Tp(s,a,r+nVis) > 0
            rVal(s, a, r+nVis, r) = 1; 
            end;
        end;
    end;
end;

for s=1:nVis
    for a=1:nA-1
        if (s~=a) %wrong ad shown
            if Tp(s,a,nS) > 0
            rVal(s,a,nS, nR) = -1;
            end;
        end; 
    end;
end;



%initial states
pStartStates = zeros(nS);
pStartStates(nS) = 1.0;

%output to file

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

