function results = performance_by_contrast_all(experiment_file)
    contrasts = [];
    [experiment_file] = concatenate_folders(experiment_file); % Concatenates data within a folder
    for i = 1:length(experiment_file)
        for j = 1:length(experiment_file(i).data)
            contrasts = [contrasts, unique(experiment_file(i).data(j).contrast)];
        end
    end
    contrasts = unique(contrasts);
    
    results = struct();
    results.contrasts = contrasts;
    for i = 1:length(experiment_file)
        exp = experiment_file(i);
        percent_correct_1 = [];
        percent_correct_2 = [];
        reaction_times_1 = [];
        reaction_times_2 = [];
        reaction_times_std_1 = [];
        reaction_times_std_2 = [];

                percent_correct_1_5_CI = [];
                percent_correct_1_32_CI = [];
                percent_correct_1_68_CI = [];
                percent_correct_1_95_CI = [];
                
                percent_correct_2_5_CI = [];
                percent_correct_2_32_CI = [];
                percent_correct_2_68_CI = [];
                percent_correct_2_95_CI = [];
        
        for j = 1:length(experiment_file(i).data) % Runs through each experiment file
            sess = exp.data(j);
            p1 = [];p2 = []; r1 = []; r2 = []; r1d = []; r2d = [];
            
                percent_correct_1_5_CI_k = [];
                percent_correct_1_32_CI_k = [];
                percent_correct_1_68_CI_k = [];
                percent_correct_1_95_CI_k = [];
                
                percent_correct_2_5_CI_k = [];
                percent_correct_2_32_CI_k = [];
                percent_correct_2_68_CI_k = [];
                percent_correct_2_95_CI_k = [];
                
            for k = 1:length(contrasts) % 1 loop for each contrast type
                p1(end+1) = nanmean(sess.success(sess.contrast == contrasts(k) & sess.stim_pos == 1));

                side_1_temp = sess.success(sess.contrast == contrasts(k) & sess.stim_pos == 1);
                iterations = length(side_1_temp)-19; % Iterations using a sliding window of 20.
                side_1_distrib = [];
                
                if iterations>10
                    for ii = 1:iterations % Sliding window mean for side 1
                        side_1_distrib(ii) = mean(side_1_temp(ii:(ii+19)));
                    end
                    
                    side_1_5_percent = prctile(side_1_distrib,5);
                    side_1_32_percent = prctile(side_1_distrib,32);
                    side_1_68_percent = prctile(side_1_distrib,68);
                    side_1_95_percent = prctile(side_1_distrib,95);
                    
                end
                
                if iterations<=10
                    
                    side_1_5_percent = NaN;
                    side_1_32_percent = NaN;
                    side_1_68_percent = NaN;
                    side_1_95_percent = NaN;
                    
                end
                
                side_2_temp = sess.success(sess.contrast == contrasts(k) & sess.stim_pos == 2);
                side_2_distrib = [];
                iterations = length(side_2_temp)-19; % Iterations using a sliding window of 20.
                side_2_distrib = [];
                
                if iterations>10
                    for ii = 1:iterations % Sliding window mean for side 2
                        side_2_distrib(ii) = mean(side_2_temp(ii:(ii+19)));
                    end
                    
                    side_2_5_percent = prctile(side_2_distrib,5);
                    side_2_32_percent = prctile(side_2_distrib,32);
                    side_2_68_percent = prctile(side_2_distrib,68);
                    side_2_95_percent = prctile(side_2_distrib,95);
                    
                end
                
                if iterations<=10
                    
                    side_2_5_percent = NaN;
                    side_2_32_percent = NaN;
                    side_2_68_percent = NaN;
                    side_2_95_percent = NaN;

                end
                
                p2(end+1) = nanmean(sess.success(sess.contrast == contrasts(k) & sess.stim_pos == 2));
                r1(end+1) = nanmean(sess.rxn_time(sess.contrast == contrasts(k) & sess.stim_pos == 1));
                r2(end+1) = nanmean(sess.rxn_time(sess.contrast == contrasts(k) & sess.stim_pos == 2));
                r1d(end+1) = nanstd(sess.rxn_time(sess.contrast == contrasts(k) & sess.stim_pos == 1));
                r2d(end+1) = nanstd(sess.rxn_time(sess.contrast == contrasts(k) & sess.stim_pos == 2));
                
                percent_correct_1_5_CI_k(end+1) = side_1_5_percent;
                percent_correct_1_32_CI_k(end+1) = side_1_32_percent;
                percent_correct_1_68_CI_k(end+1) = side_1_68_percent;
                percent_correct_1_95_CI_k(end+1) = side_1_95_percent;
                
                percent_correct_2_5_CI_k(end+1) = side_2_5_percent;
                percent_correct_2_32_CI_k(end+1) = side_2_32_percent;
                percent_correct_2_68_CI_k(end+1) = side_2_68_percent;
                percent_correct_2_95_CI_k(end+1) = side_2_95_percent;
                
                
            end
            percent_correct_1 = [percent_correct_1; p1];
            percent_correct_2 = [percent_correct_2; p2];
            reaction_times_1 = [reaction_times_1; r1];
            reaction_times_2 = [reaction_times_2; r2];
            reaction_times_std_1 = [reaction_times_std_1; r1d];
            reaction_times_std_2 = [reaction_times_std_2; r2d];
            percent_correct_1_5_CI = [percent_correct_1_5_CI;percent_correct_1_5_CI_k];
            percent_correct_1_32_CI = [percent_correct_1_32_CI;percent_correct_1_32_CI_k];
            percent_correct_1_68_CI = [percent_correct_1_68_CI;percent_correct_1_68_CI_k];
            percent_correct_1_95_CI = [percent_correct_1_95_CI;percent_correct_1_95_CI_k];
            
            percent_correct_2_5_CI = [percent_correct_2_5_CI;percent_correct_2_5_CI_k];
            percent_correct_2_32_CI = [percent_correct_2_32_CI;percent_correct_2_32_CI_k];
            percent_correct_2_68_CI = [percent_correct_2_68_CI;percent_correct_2_68_CI_k];
            percent_correct_2_95_CI = [percent_correct_2_95_CI;percent_correct_2_95_CI_k];
            
        end
        results.(exp.experiment) = struct('percent_correct', struct('side_1', percent_correct_1, 'side_2', percent_correct_2), ...
                                          'response_latency', struct('side_1', reaction_times_1, 'side_2', reaction_times_2),...
                                          'response_latency_standard_dev', struct('side_1', reaction_times_std_1, 'side_2', reaction_times_std_2),...
                                          'percent_correct_5_CI', struct('side_1', percent_correct_1_5_CI, 'side_2', percent_correct_2_5_CI),...
                                          'percent_correct_32_CI', struct('side_1', percent_correct_1_32_CI, 'side_2', percent_correct_2_32_CI),...
                                          'percent_correct_68_CI', struct('side_1', percent_correct_1_68_CI, 'side_2', percent_correct_2_68_CI),...
                                          'percent_correct_95_CI', struct('side_1', percent_correct_1_95_CI, 'side_2', percent_correct_2_95_CI));
    end
    