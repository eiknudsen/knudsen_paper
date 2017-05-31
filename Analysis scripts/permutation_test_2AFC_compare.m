function [pv_d, pv_c] = permutation_test_2AFC_compare(ctable_ref, ctable_test, ddir, cdir)
%% Permutation test for 2AFC task: compare 2 contingency tables
% return values are pv_d and pv_c which are p-values for whether the
% d' and c in 2 different 2AFC contingency tables are significantly
% differrent or not
% 
% input values are the 2 contingency tables with rows corresponding to
% stimulus events and columns corresponding to response types
% 
% ctable_ref  : reference contingency table
% ctable_test : tested contingency table 
% ddir, cdir  : direction of statistical test for d' and c respectively
%       permissible values are 'r>t' (or 't<r') and 'r<t' (or 't>r') which
%       will test the respective parameter in the direction
%       'reference > test' and 'reference < test', respectively
%
% usage example: 
%   [pv_d, pv_c] = permutation_test_2AFC_compare (ctable_ref, ctable_test, 't>r', 't<r')
%      -- will test if the d' for the test data is greater than the d' for
%      the reference data and if the c for the test data is less than the c
%      for the reference data
% 
% Sridhar Devarajan, 2016
% sridhar@cns.iisc.ernet.in

[pval_d, pval_c, ~] = randomization_dc_compare(ctable_ref, ctable_test, ddir, cdir);

pv_d = min(1.0, pval_d); % 2-tailed test
pv_c = min(1.0, pval_c); % 2-tailed test

function [pval_d, pval_c, Or_list] = randomization_dc_compare(Oir, Oit, ddir, cdir, niter)
% compute the null distributions of d and c based on # trials in Oi
if ~exist('niter', 'var')
    niter = 1e4;
end

Oir = round(Oir);
Oit = round(Oit);

[d_ir, c_ir] = calc_2AFC_dc(Oir);
[d_it, c_it] = calc_2AFC_dc(Oit);

delta_dtr = d_it - d_ir;
delta_ctr = c_it - c_ir;
 
nXr  = size(Oir, 2);
ntrr = repmat(sum(Oir, 2)', nXr, 1)';

pi  = Oir./ntrr;
nOs = sum(Oir, 2);

for i = 1:nXr,
    cumprs(i,:) = [0, cumsum(pi(i,:))];
end

zOi = zeros(size(Oir));

Or_list = cell(1,niter);
delta_dr_null  = nan(1, niter);
delta_cr_null  = nan(1, niter);

for iter = 1:niter,
    Or = zOi;
    for i = 1:nXr,
    
        cprs = cumprs(i,:);
        rv   = rand(nOs(i), 1); % random #s corresponding to # observations
        
        n = histc(rv, cprs);
        Or(i, :) = n(1:end-1);
        
    end

    [d_rn, c_rn] = calc_2AFC_dc(Or);
    
    Or_list{iter}  = Or;
    delta_dr_null(iter)  = d_ir - d_rn;
    delta_cr_null(iter)  = c_ir - c_rn;   
    
end

if all(ddir == 'r>t') || all(ddir == 't<r')
    pval_d = sum(delta_dr_null <= delta_dtr)/niter;
elseif all(ddir == 't>r') || all(ddir == 'r<t')
    pval_d = sum(delta_dr_null >= delta_dtr)/niter;
end
    
if all(cdir == 'r>t') || all(cdir == 't<r')
    pval_c = sum(delta_cr_null <= delta_ctr)/niter;
elseif all(cdir == 't>r') || all(cdir == 'r<t')
    pval_c = sum(delta_cr_null >= delta_ctr)/niter;
end

fprintf('\n d''_test - d''_ref = %2.4f', delta_dtr);
fprintf('\n c_test - c_ref = %2.4f\n', delta_ctr);
