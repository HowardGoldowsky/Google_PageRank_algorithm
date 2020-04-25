% function to implement Google's Personalized PageRank algorithm

function [iter, importanceVector] = personalizedpagerank(G, m, personalizationVector, z, tolerence, max_iter)

% INPUT:
%   G:                  directed network
%   m:                  weighting of main link matrix versus uniform
%                       distribution; this was m=0.15 in the original Google algorithm and
%                       typically works well.
%   z:                  personalization weighting factor
%   personalizationVector: probability distribution of node relevance 
%   tolerence:          threshold for convergence
%   max_iter            max number of iterations before returning without convergence
%
% OUTPUT:
%   iter:               number of iterations to convergence
%   importanceVector:   importance of nodes based on PageRank algorithm 

    % INIT
    
    iter = 0;    
    length_diff = inf;
    
    AdjG = full(adjacency(G));                                              % init the adjacency matrix
    outboundLinks = sum(AdjG);
    nNodes = length(AdjG);                                                  % number of outbound links for each node in the network
    s = (1/nNodes) * ones(nNodes);                                          % init "uniform basic income"  matrix
    P = (1./outboundLinks).*AdjG;                                           % init the P matrix; some of these probabilities will be infinity    
    P = (P*(1-m) + s*m);
    importanceVector = (1/nNodes) * ones(nNodes,1);                         % init importance vector              
    danglingNodes = outboundLinks == 0;                                     % reset the infinite probabilities to 1/N
    nDanglingNodes = sum(danglingNodes);
    if (nDanglingNodes)
        P(:,danglingNodes) = repmat(importanceVector,1,nDanglingNodes);     % danglingNodes that have no outbound links get the special treatment
    end
     
    % ITERATE
    
    while (length_diff > tolerence)                                         % run until convergence
        
        importanceVector_old = importanceVector;
        importanceVector = z*personalizationVector + P*(1-z) * importanceVector;
        
        difference = (importanceVector_old - importanceVector);             % difference vector
        length_diff = difference'*difference;                               % calculate length of difference vector
        
        iter = iter + 1;
        if (iter >= max_iter)                                               % stop if it hits max iterations
            disp('Hit max iterations.')
            return
        end
        
    end % while

end % function 