function [new_block] = concatenate_folders(experiment_file)

% In the form new_block = concatenate_folders(experiment_file), where
% experiment file is the output from using load_experiment, and this output
% is a matlab structure containing all of the data from the experiments in
% the directory you loaded. This code will ask a few questions, and will
% concatenate the data in the experiment_file structure you give it, according to
% the way you answer those questions, allowing you to analze multiple
% blocks as if they were just one block. For example, everything in the
% experiment file (the output from load_experiment) can be combined into a
% single block, which would be stored in new_block. If certain weeks are
% combined, then those combined weeks will show up as the first entry of
% new_block, with all of the other weeks that were not combined being added
% as additional entries. e.g. after running load_experiment, you have a
% 1x9 structure called output. You combine weeks (folders, whatever,
% basically entries of output) 2, 5 and 7. You now have a 1x7 structure
% new_block, where new_block(1) is the combination of 2,5 and 7 in temporal
% order. new_block(2) is now output(3), new_block(3) is now output(4),
% new_block(4) is output(6) (because we already used output(5)), new_block(5) is output(7), and so on.

    new_block = struct; % This structure will be filled with reorganized data from experiment_file
    % The following will be filled with parameters and stored in new_block

    
    %% This section combines everything into a single block, if that is what you want.
        
        for i = 1:length(experiment_file) % One iteration for each folder in the directory loaded by load_experiment
            
     contrast = [];
          cue = [];
     stim_pos = [];
           go = [];
     rxn_time = [];
      success = [];
        error = [];
      ox_peck = [];
      oy_peck = [];
       targ_x = [];
       targ_y = [];
    resp_time = [];
            
            for j = 1:length(experiment_file(i).data) % One iteration for each cell in output.data. For weeks of data these cells represent days
            
                contrast = [contrast experiment_file(i).data(j).contrast];
                cue = [cue experiment_file(i).data(j).cue];
                stim_pos = [stim_pos experiment_file(i).data(j).stim_pos];
                go = [go experiment_file(i).data(j).go];
                rxn_time = [rxn_time experiment_file(i).data(j).rxn_time];
                success = [success experiment_file(i).data(j).success];
                error = [error experiment_file(i).data(j).error];
                ox_peck = [ox_peck experiment_file(i).data(j).ox_peck];
                oy_peck = [oy_peck experiment_file(i).data(j).oy_peck];
                targ_x = [targ_x experiment_file(i).data(j).targ_x];
                targ_y = [targ_y experiment_file(i).data(j).targ_y];
                resp_time = [resp_time experiment_file(i).data(j).resp_time];
            
            end % End for j loop
            
        new_block(i).experiment = experiment_file(i).experiment;
        new_block(i).data.contrast = contrast;
        new_block(i).data.cue = cue;
        new_block(i).data.stim_pos = stim_pos;
        new_block(i).data.go = go;
        new_block(i).data.rxn_time = rxn_time;
        new_block(i).data.success = success;
        new_block(i).data.error = error;
        new_block(i).data.ox_peck = ox_peck;
        new_block(i).data.oy_peck = oy_peck;
        new_block(i).data.targ_x = targ_x;
        new_block(i).data.targ_y = targ_y;
        new_block(i).data.resp_time = resp_time;
            
        end % End for i loop
             