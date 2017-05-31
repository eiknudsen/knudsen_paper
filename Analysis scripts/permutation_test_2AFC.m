function [pv_d, pv_c] = permutation_test_2AFC(cont_table)
%% Permutation test for 2AFC task: test a single contingency table
% return values are pv_d and pv_c which are p-values for whether the
% d' is significantly greater than zero, and whether the criterion is
% significantly greater than zero, respectively 
% 
% input value is the contingency table with rows corresponding to
% stimulus events and columns corresponding to response types
%
% usage example: 
%   [pv_d, pv_c] = permutation_test_2AFC (input)
%
% Sridhar Devarajan, 2016
% sridhar@cns.iisc.ernet.in

    [pval_d, pval_c, ~] = randomization_dc(cont_table);

    pv_d = min(1.0, pval_d); 
    pv_c = min(1.0, pval_c); 

    function [pval_d, pval_c, Or_list] = randomization_dc(Oi, niter)
    % compute the null distributions of d and c based on # trials in Oi
    if ~exist('niter', 'var')
        niter = 1e4;
    end

    Oi = round(Oi); % Oi is the contingency table

    [d_i, c_i] = calc_2AFC_dc(Oi);

    nX  = size(Oi, 2);
    ntr = repmat(sum(Oi, 2)', nX, 1)';

    pi  = 0.5*ones(2); % corresponding to the null distribution
    nOs = sum(Oi, 2);

    for i = 1:nX,
        cumprs(i,:) = [0, cumsum(pi(i,:))];
    end

    zOi = zeros(size(Oi));

    Or_list = cell(1,niter);
    d_null  = nan(1, niter);
    c_null  = nan(1, niter);
    
    for iter = 1:niter,
        Or = zOi;
        for i = 1:nX,

            cprs = cumprs(i,:);
            rv   = rand(nOs(i), 1); % random #s corresponding to # observations

            n = histc(rv, cprs);
            Or(i, :) = n(1:end-1);

        end

        [d_n, c_n] = calc_2AFC_dc(Or);

        Or_list{iter}   = Or;
        d_null(iter)  = d_n;
        c_null(iter)  = c_n;   

    end

    if d_i>=0 || isnan(d_i)
        pval_d = sum(d_null >= d_i | d_null <= -d_i)/niter;
    end
    if c_i>=0 || isnan(c_i)
        pval_c = sum(c_null >= c_i | c_null <= -c_i)/niter;
    end
    if d_i<0
        pval_d = sum(d_null <= d_i | d_null >= -d_i)/niter;
    end
    if c_i<0
        pval_c = sum(c_null <= c_i | c_null >= -c_i)/niter;
    end
    
    
        

    fprintf('\n d'' = %2.4f, c = %2.4f\n', d_i, c_i);