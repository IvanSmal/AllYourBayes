function [choice, params] = makeDecision(data,type,mu,sigma,prior)
% Chooses the more likely of two distributions
% Possible types include:
% 'mle' - maximum likelihood estimation
% 'map' - maximum a posteriori estimation
% 'lda' - linear discriminant analysis

% Compute the likelihoods and estimate the Gaussian distribution of
% the input data
[like1,muEst(1),sigmaEst(1)] = mleGaussian(data,mu(1),sigma(1));
[like2,muEst(2),sigmaEst(2)] = mleGaussian(data,mu(2),sigma(2));

if strcmpi(type,'mle')
    % Make the decision based on which likelihood is higher
    if like1>like2
        choice = 1;
    elseif like1<like2
        choice = 2;
    else % If they are equal, do a coin flip
        if rand(1)>0.5 
            choice = 1;
        else
            choice = 2;
        end
    end
elseif strcmpi(type,'map')
    % Make the decision based on which likelihood*prior is higher
    if like1*prior(1) > like2*prior(2)
        choice = 1;
    elseif like1*prior(1) < like2*prior(2)
        choice = 2;
    else % If they are equal, do a coin flip
        if rand(1)>0.5 
            choice = 1;
        else
            choice = 2;
        end
    end
elseif strcmpi(type,'lda')
    % LDA assumes both distributions have the same variance
    if (sigma(1) ~= sigma(2))
        disp('Attempting to do LDA on distributions with different variances.');
        disp('This is probably not ending well.');
    end
    choice = ldaDecision(data, mu, sigma(1), prior);
else
    disp('Estimation type does not exist');
end

params = [muEst;sigmaEst];

end