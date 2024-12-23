function [ decs_b, pays ] = CATIE_single_schedule_score(payoffs_a, payoffs_b, reward)
% This implementation was created by Ori Plonsky
 
%% parameters
k = randi([0,2]);
pHeuristic= 0.29;
epsilon= 0.3;
pIner= 0.71;

%% constants
nTrials = 100;

%% preallocation and initializations
ContCountsPaysA = zeros(4^k,2,'double');
ContCountsPaysB = zeros(4^k,2,'double');
decs_b = NaN(nTrials,1); % holds decisions of option B (target)
pays = NaN(nTrials,1); 
surprise = NaN(nTrials,1); % holds levels of surprise in each trial
totalSurprise = 0; % holds sum of surprises thus far
reward_vec = NaN(nTrials,1); % holds observed history (0 = A no reward, 1 = A with reward, 2 = B no reward), 3 = B with reward)
observedSD = zeros(1,2); % holds the observed SD from payoffs in both options
GMa = 0; % grand mean from A (initialized to belief of zero)
GMb = 0; % grand mean from B (initialized to belief of zero)
AltsExpectations = zeros(1,2); % holds the payoff expectations for next trial in each alterrnative. Initialized by 0
TotalASumPay = 0; % Holds sum of payoffs obtained from A 
TotalSqdASumPay = 0; %Holds sum of squares for payoffs from A
ChoiceACounts = 0; % Holds number of A choices made
TotalBSumPay = 0; % Holds sum of payoffs obtained from B 
TotalSqdBSumPay = 0; %Holds sum of squares for payoffs from B
ChoiceBCounts = 0; % Holds number of B choices made

%% simulate decisions
decs_b(1) = int8(randi(2) - 1); % random first choice
for trial = 1:nTrials
    
    % update observed payoff for current trial
    if decs_b(trial) == 1
        pays(trial) = payoffs_b(trial);
        if pays(trial) == reward
            reward_vec(trial) = 3;
        else
            reward_vec(trial) = 2;
        end   
        % compute current SD
        TotalBSumPay = TotalBSumPay + pays(trial);
        ChoiceBCounts = ChoiceBCounts + 1;
        TotalSqdBSumPay = TotalSqdBSumPay + (pays(trial)).^2;
        varB = (1/(ChoiceBCounts-1)) * (TotalSqdBSumPay - ((TotalBSumPay^2)/ChoiceBCounts));
        if varB < 0
            varB = 0;
        end
        observedSD(2) = sqrt(varB);
    else % chose A
        pays(trial) = payoffs_a(trial);
        if pays(trial) == reward
            reward_vec(trial) = 1;
        else
            reward_vec(trial) = 0;
        end   
        % compute current SD
        TotalASumPay = TotalASumPay + pays(trial);
        ChoiceACounts = ChoiceACounts + 1;
        TotalSqdASumPay = TotalSqdASumPay + (pays(trial)).^2;
        varA = (1/(ChoiceACounts-1)) * (TotalSqdASumPay - ((TotalASumPay^2)/ChoiceACounts));
        if varA < 0
            varA = 0;
        end
        observedSD(1) = sqrt(varA);        
    end
    
    % update surprise resulting from observed payoff
    if observedSD(decs_b(trial)+1) > 0.0001  % SURPRISE FUNCTION (DEPENDENT ON EXPECTATIONS & SDs)
        surprise(trial) = (abs(AltsExpectations(decs_b(trial)+1) - pays(trial))) / (observedSD(decs_b(trial)+1) + (abs(AltsExpectations(decs_b(trial)+1) - pays(trial)))); % surprise function
    else % no variability observed in the chosen button
        surprise(trial) = 0;
    end
    totalSurprise = totalSurprise + surprise(trial);
    mSurp = totalSurprise / trial; % the mean surprise observed in this game

    % update contingency beliefs 
    if k > 0 && trial > k 
        rowUpdate = base2dec(4,(reward_vec((trial-k):(trial-1))'))+1;
        if decs_b(trial) == 0    
            % update contingent sum
            ContCountsPaysA(rowUpdate,1) = ContCountsPaysA(rowUpdate,1) + pays(trial);
            % update that contingent number encountered
            ContCountsPaysA(rowUpdate,2) = ContCountsPaysA(rowUpdate,2) + 1;
        else
            % update contingent sum
            ContCountsPaysB(rowUpdate,1) = ContCountsPaysB(rowUpdate,1) + pays(trial);
            % update that contingent number encountered
            ContCountsPaysB(rowUpdate,2) = ContCountsPaysB(rowUpdate,2) + 1;
        end
    end
    
    if decs_b(trial) == 1 % update GM
        GMb = TotalBSumPay/ChoiceBCounts;
    else
        GMa = TotalASumPay/ChoiceACounts;
    end    
    
    if k == 0 % CAB-0
        AltsExpectations(2) = GMb;
        AltsExpectations(1) = GMa;
        decCA = int8(GMb > GMa);
        if GMb == GMa
            decCA = int8(randi(2)-1);  %    IF ESTIMATED VALUES ARE EQUAL, CHOOSE RANDOMLY
        end        
    elseif trial > k && trial < nTrials % CAB-k, k>0
        rowDecide = base2dec(4,(reward_vec((trial-k+1):(trial))'))+1;       
        if ContCountsPaysA(rowDecide,2) > 0
           CAa = ContCountsPaysA(rowDecide,1) / ContCountsPaysA(rowDecide,2);
        else
            logicConts = ContCountsPaysA(:,2) > 0;
            if sum(logicConts) > 0
                ConfusionCont = datasample(ContCountsPaysA(logicConts,:),1,1);
                CAa = ConfusionCont(1)/ConfusionCont(2); 
            else
                CAa = GMa;
            end
        end        
        if ContCountsPaysB(rowDecide,2) > 0
           CAb = ContCountsPaysB(rowDecide,1) / ContCountsPaysB(rowDecide,2);
        else
            logicConts = ContCountsPaysB(:,2) > 0;
            if sum(logicConts) > 0
                ConfusionCont = datasample(ContCountsPaysB(logicConts,:),1,1);
                CAb = ConfusionCont(1)/ConfusionCont(2); 
            else
                CAb = GMb; 
            end
        end
        decCA = int8(CAb > CAa);
        if CAb == CAa
            decCA = int8(randi(2)-1);  %   
        end
        AltsExpectations(2) = CAb;
        AltsExpectations(1) = CAa;
    else %if k>0 and not enough experience to use CAB-k
        decCA =  int8(GMb > GMa);
        if GMb == GMa
            decCA = int8(randi(2)-1);  %    
        end    
    end 
    
    % make decision
    if trial < nTrials
        if  trial > 1
            if (rand(1) < pHeuristic) && (decs_b(trial) == decs_b(trial-1)) && (pays(trial) ~= pays(trial-1))
                if pays(trial) > pays(trial-1)
                    decs_b(trial+1) = decs_b(trial);
                else
                    decs_b(trial+1) = 1-decs_b(trial);
                end
            elseif getExploreProb(epsilon, surprise(trial), mSurp) > rand(1)       
                decs_b(trial+1) = int8(randi(2)-1);
            elseif pIner > rand(1) 
                decs_b(trial+1) = decs_b(trial); 
            else % use Exploitation mode.
                decs_b(trial+1) = decCA;    
            end 
        else
            decs_b(trial+1) = 1-decs_b(trial);            
        end
    end
end

end