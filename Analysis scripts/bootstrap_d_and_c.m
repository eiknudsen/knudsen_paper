function [bootstrapped_pv_d_and_pvc] = bootstrap_d_and_c(cont_tables)

% In the form [bootstrapped_pv_d_and_pvc] = permutation_test_2AFC_single(cont_tables),
% where bootstrapped_pv_d_and_pvc is a table containing the bootstrapped d
% prime and bias values for all of the comparisons within a single folder.
% The input to the function, cont_tables, is the output from
% performance_by_contrast_thresh if you ran load_experiment on a single
% folder before feeding it into performance_by_contrast_thresh.

if size(cont_tables,4)==1 % For bootstrapping d' and c in a single folder
    bootstrapped_pv_d_and_pvc = {};
    bootstrapped_pv_d_and_pvc(1,2) = {'pval_d_prime'};
    bootstrapped_pv_d_and_pvc(1,3) = {'pval_c'};
    bootstrapped_pv_d_and_pvc(2,1) = {'Low_thesh_side_1'};
    bootstrapped_pv_d_and_pvc(3,1) = {'Above_thesh_side_1'};
    bootstrapped_pv_d_and_pvc(4,1) = {'Low_thesh_side_2'};
    bootstrapped_pv_d_and_pvc(5,1) = {'Above_thesh_side_2'};

    for ii = 1:4
        cont_table = cont_tables(:,:,ii,1);
        [pv_d, pv_c] = permutation_test_2AFC(cont_table);
        bootstrapped_pv_d_and_pvc(ii+1,2) = {pv_d};
        bootstrapped_pv_d_and_pvc(ii+1,3) = {pv_c};
        
        if min(cont_table)==0 & max(cont_table)==0 % If there is no data for the condition
            bootstrapped_pv_d_and_pvc(ii+1,2) = {'NaN'};
            bootstrapped_pv_d_and_pvc(ii+1,3) = {'NaN'};
        end
            
    end % end for ii loop
end % end for single folder if statement

if size(cont_tables,4)==2 % For bootstrapping d' and c between 2 folders
    
    bootstrapped_pv_d_and_pvc = {};
    bootstrapped_pv_d_and_pvc(1,2) = {'pval_d_prime'};
    bootstrapped_pv_d_and_pvc(1,3) = {'pval_c'};
    bootstrapped_pv_d_and_pvc(2,1) = {'Low_thesh_side_1_comparison'};
    bootstrapped_pv_d_and_pvc(3,1) = {'Above_thesh_side_1_comparison'};
    bootstrapped_pv_d_and_pvc(4,1) = {'Low_thesh_side_2_comparison'};
    bootstrapped_pv_d_and_pvc(5,1) = {'Above_thesh_side_2_comparison'};

    for ii = 1:4
        ref_table = cont_tables(:,:,ii,1);
        test_table = cont_tables(:,:,ii,2);
        [pv_d, pv_c] = permutation_test_2AFC_compare(ref_table, test_table, 't>r', 't>r');
        bootstrapped_pv_d_and_pvc(ii+1,2) = {pv_d};
        bootstrapped_pv_d_and_pvc(ii+1,3) = {pv_c};
        
        if min(ref_table)==0 & max(ref_table)==0 % If there is no data for the condition
            bootstrapped_pv_d_and_pvc(ii+1,2) = {'NaN'};
            bootstrapped_pv_d_and_pvc(ii+1,3) = {'NaN'};
        end
        if min(test_table)==0 & max(test_table)==0 % If there is no data for the condition
            bootstrapped_pv_d_and_pvc(ii+1,2) = {'NaN'};
            bootstrapped_pv_d_and_pvc(ii+1,3) = {'NaN'};
        end
            
    end % end for ii loop
end % end for single folder if statement
    
    
end % end for 2 folder comparison if statment