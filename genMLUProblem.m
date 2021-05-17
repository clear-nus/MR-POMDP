% Generates the Multi-Load-Unload Problem
% Harold Soh


load('MLUMap.mat');
MLUMap = MLUMap2;
MLUObjLabels = zeros(size(MLUMap,1), size(MLUMap,2));
M = size(MLUMap,1);
N = size(MLUMap,2);

k = 1;

discountFactor = 0.99999;

%create labels for objectives (unload points)
for j=1:size(MLUMap,1)
    for i=1:size(MLUMap,2)
        if (MLUMap(i,j) == 3) 
            MLUObjLabels(i,j) = k;
            k = k+1;
        end;
    end;
end;

%set number of objectives
nObj = 5;
mrpomdpfile = fopen(strcat('mluS', int2str(nObj), '.pomdp'), 'w');
nR = nObj;
%set number of actions
nA = 6; %up, down, left, right, load, unload

%compute number of states
nns = nnz(MLUMap);
nS = nnz(MLUMap); %non-zero elements
nS = nS*2; %for unloaded and loaded states (first half is unloaded)

%create possible states
StateMapUL = zeros(M,N);
StateMapL = zeros(M,N);
StateList = zeros(nS, 2);
startState = 0;
s = 1;
for i=1:M
    for j=1:N
        if (MLUMap(i,j) ~=0) 
            StateMapUL(i,j) = s;
            StateList(s,:) = [i j];
            StateList(nns+s,:) = [i j];

            
            if (MLUMap(i,j) == 4) 
                startState = s;
            end;
            
            s = s+1;
            
        end;
    end;
end;

StateMapL = StateMapUL + nns;

%create transition matrix
Tp = zeros(nS, nA, nS);

%deal with the unloaded case first
for s=1:nns
    %move up
    %check if we can move up
    index = sub2ind(size(MLUMap), StateList(s,1)-1, StateList(s,2));
    if (MLUMap(index) == 0) 
        %cannot move up
        Tp(s,1, s) = 1.0;
    else
        %can move up
        Tp(s,1, StateMapUL(index)) = 0.98;
        Tp(s,1, s) = 0.02;        
    end;
    
    %down
    index = sub2ind(size(MLUMap),StateList(s,1)+1, StateList(s,2));
    if (MLUMap(index) == 0) 
        Tp(s,2, s) = 1.0;
    else
        Tp(s,2, StateMapUL(index)) = 0.98;
        Tp(s,2, s) = 0.02;        
    end;
    
    
    %left
    index = sub2ind(size(MLUMap),StateList(s,1), StateList(s,2)-1);
    if (MLUMap(index) == 0) 
        Tp(s,3, s) = 1.0;
    else
        Tp(s,3, StateMapUL(index)) = 0.98;
        Tp(s,3, s) = 0.02;        
    end;
    
    %right
    index = sub2ind(size(MLUMap),StateList(s,1), StateList(s,2)+1);
    if (MLUMap(index) == 0) 
        Tp(s,4, s) = 1.0;
    else
        Tp(s,4, StateMapUL(index)) = 0.98;
        Tp(s,4, s) = 0.02;        
    end;   
    
    %load
    index = sub2ind(size(MLUMap),StateList(s,1), StateList(s,2));    
    if (MLUMap(index) ~= 2) 
        %not at load point
        Tp(s,5, s) = 1.0;
    else
        %at load point
        Tp(s,5, StateMapL(index)) = 0.98;
        Tp(s,5, s) = 0.02;        
    end;       
    
    %unload
    Tp(s,6,s) = 1.0;
end;

%next we deal with the loaded cases
for s=nns+1:nS
    %move up
    %check if we can move up
    index = sub2ind(size(MLUMap), StateList(s,1)-1, StateList(s,2));
    if (MLUMap(index) == 0) 
        %cannot move up
        Tp(s,1, s) = 1.0;
    else
        %can move up
        Tp(s,1, StateMapL(index)) = 0.98;
        Tp(s,1, s) = 0.02;        
    end;
    
    %down
    index = sub2ind(size(MLUMap),StateList(s,1)+1, StateList(s,2));
    if (MLUMap(index) == 0) 
        Tp(s,2, s) = 1.0;
    else
        Tp(s,2, StateMapL(index)) = 0.98;
        Tp(s,2, s) = 0.02;        
    end;
    
    
    %left
    index = sub2ind(size(MLUMap),StateList(s,1), StateList(s,2)-1);
    if (MLUMap(index) == 0) 
        Tp(s,3, s) = 1.0;
    else
        Tp(s,3, StateMapL(index)) = 0.98;
        Tp(s,3, s) = 0.02;        
    end;
    
    %right
    index = sub2ind(size(MLUMap),StateList(s,1), StateList(s,2)+1);
    if (MLUMap(index) == 0) 
        Tp(s,4, s) = 1.0;
    else
        Tp(s,4, StateMapL(index)) = 0.98;
        Tp(s,4, s) = 0.02;        
    end;   
    
    %load
    Tp(s,5,s) = 1.0; % cannot load - already loaded
      
    %unload
    index = sub2ind(size(MLUMap),StateList(s,1), StateList(s,2));    
    if (MLUMap(index) ~= 3) 
        %not at unload point
        Tp(s,6, s) = 1.0;
    else
        %at unload point
        Tp(s,6, StateMapUL(index)) = 0.98;
        Tp(s,6, s) = 0.02;        
    end;         
end;        
        

%compute number of observations
%robutt can only see 4 walls and cannot perceive load or unload points
nO = 0;
ObsMat = [];
Obs = [];

MLUMapNZ = MLUMap & MLUMap;

for i=2:M-1
    for j=2:N-1
        if (MLUMapNZ(i,j) ~= 0) 
            currObs = MLUMapNZ(i-1:i+1,j-1:j+1);
            currObs(1,1) = 0;
            curObs(3,3) = 0;
            currObs(3,1) = 0;
            currObs(1,3) = 0;
            if (nO == 0) 
                Obs(1:3,1:3, 1) = currObs;
                ObsMat(i,j) = 1;
                nO = 1;
            else
                found = false;
                for k=1:nO
                    if (currObs == Obs(1:3,1:3,k) )
                        ObsMat(i,j) = k;
                        found = true;
                        break;
                    end;
                end;
                if (found == false)
                    nO = nO + 1;
                    ObsMat(i,j) = nO;
                    Obs(1:3,1:3,nO) = currObs;
                end;
            end;
        end;
    end;
end;
     
%create the observational distance matrix (robutts can make a mistake 
%observing - limited to hamming distance of 2)
ObsDistMat = zeros(nO, nO);
for i=1:nO
    for j=1:nO
        ObsDistMat(i,j) = sum(sum(abs(Obs(:,:,i) - Obs(:,:,j))));
    end;
end;


%create observation probabilities
Op1 = exp(-1.5*ObsDistMat); 
%cind = find(Op1 < 0.02);

%Op1(cind) = 0;
for i=1:nO
    Op1(i,:) = Op1(i,:)./sum(Op1(i,:));
end;

Op = zeros(nS, nO);
for s=1:nS
    obsLabel = ObsMat( StateList(s,1), StateList(s,2) );
    Op( s , :) = Op1( obsLabel, :);
end;



%create reward matrices
rVal = zeros(nS, nA, nS, nR) -1;
for r=1:nR
    %find the loaded state with this reward location, s1
    cind = find(MLUObjLabels == r);
    s1 = StateMapL(cind);
    
    %find the unloaded state with this reward location,s2
    s2 = StateMapUL(cind);
    
    %the reward for transitioning from s1 to s2 with an unload is 100
    rVal(s1,6,s2,r) = 100;
end;
        

%initial states
pStartStates = zeros(nS);
pStartStates(startState) = 1.0;


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