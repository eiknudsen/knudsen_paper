function all_outputs = load_data_current_folder_manual()
%% luminance to Weber contrast transformation parameters


calib_params = cont_transform();


%% assigning the various relevant indices


xC_ind = 1;
yC_ind = 2;
succ_ind = 3;
spd_ind = 4;
thresh_ind = 5;
xlocT_ind = 6;
ylocT_ind = 7;
rtime_ind = 8;
stimpos_ind = 9;
cuepos_ind = 11;
trialtype_ind = 12;
dist_ind = 13;
orient_ind = 14;


f = dir('tdc*params.mat');
all_outputs = [];

go_pecks_1 = [];
go_pecks_2 = [];
nogo_pecks_1 = [];
nogo_pecks_2 = [];
for i =1:length(f)
    load(f(i).name, 'trial_duration', 'xdispResp', 'ydispResp','fixXOffset', 'fixYOffset', 'tdCueOn', 'no_distractor');
    load(strcat(f(i).name(1:10), '.mat'));
    load(f(i).name, 'datetr_dir')

    %% loop through all trials

    max_num_tr_type=2;
    num_stim_pos = 2;
    ntr_tot = 0;

    hrb = cell(max_num_tr_type,num_stim_pos); % hit rate for this session

    stb = cell(max_num_tr_type,num_stim_pos); % reaction times for this session

    acb = cell(max_num_tr_type,num_stim_pos); % peck accuracy for this session


    trial_inds = find(cursCoords(:,orient_ind) ~= -1);

    num_trials = length(trial_inds);


    ntr_tot = ntr_tot + num_trials;
    
    crossX = 512+fixXOffset;
    crossY = 384+fixYOffset;

    stim_pos_list = [];
    output=struct('contrast', [], 'cue', [], 'stim_pos', [], 'go', [], 'rxn_time', [],'success', [], 'error', [],...
        'ox_peck', [], 'oy_peck', [], 'targ_x', [], 'targ_y', [], 'resp_time', [], 'rxn_time_nogo', [], 'date', datetr_dir);

    for tr = 1:num_trials,

        cur_trial = trial_inds(tr);

        stim_pos = cursCoords(cur_trial, stimpos_ind);

        if tdCueOn
            cc = cursCoords(cur_trial, trialtype_ind); %1;
        else
            cc = 0;
        end


        trial_hitmiss = cursCoords(cur_trial, succ_ind);

        reaction_time = cursCoords(cur_trial, rtime_ind);

        orient_val = cursCoords(cur_trial, orient_ind);

        thresh_val = abs(cursCoords(cur_trial, thresh_ind));


        ox_peck = cursCoords(cur_trial, xC_ind);

        oy_peck = cursCoords(cur_trial, yC_ind);


        if ox_peck == -1

            ox_peck = cursCoords(cur_trial-1, xC_ind);

            oy_peck = cursCoords(cur_trial-1, yC_ind);

        end
        ox_peck = ox_peck - crossX;
        oy_peck = -(oy_peck - crossY);
        output.ox_peck(end+1) = ox_peck;
        output.oy_peck(end+1) = oy_peck;
        
        output.targ_x(end+1) = cursCoords(cur_trial, xlocT_ind);

        output.targ_y(end+1) = cursCoords(cur_trial, ylocT_ind);
        output.resp_time(end+1) = cursCoords(cur_trial, rtime_ind);

        if ~no_distractor
            output.contrast = [output.contrast, thresh_val];
        else
            output.contrast = [output.contrast, 0.0];
        end
        output.cue = [output.cue, cc];
        output.stim_pos = [output.stim_pos, stim_pos];
        output.go = [output.go, orient_val == 90];

        stim_pos_list = [stim_pos_list, stim_pos];
        
        if stim_pos == 1
            if orient_val == 90
                go_pecks_1(end+1,:) = [ox_peck, oy_peck];
            else
                nogo_pecks_1(end+1,:) = [ox_peck, oy_peck];
            end
        else
            if orient_val == 90
                go_pecks_2(end+1,:) = [ox_peck, oy_peck];
            else
                nogo_pecks_2(end+1,:) = [ox_peck, oy_peck];
            end
        end

        end % for all trials of a kind in a block
   all_outputs = [all_outputs, output];
end
if ~isempty(nogo_pecks_1)
    figure
    scatter(nogo_pecks_1(:,1), nogo_pecks_1(:,2))
    title('Side 1 trials: select threshold point 1 (left point)');
    hold on;
    scatter(go_pecks_1(:,1), go_pecks_1(:,2), 'r')
    thresh1_1 = ginput(1);
    hold off;
    scatter(nogo_pecks_1(:,1), nogo_pecks_1(:,2))
    title('Side 1 trials: select threshold point 2 (right point)');
    hold on;
    scatter(go_pecks_1(:,1), go_pecks_1(:,2), 'r')
    scatter(thresh1_1(1), thresh1_1(2), 'ks', 'markerfacecolor', 'k')
    thresh1_2 = ginput(1);
    plot([thresh1_1(1), thresh1_2(1)], [thresh1_1(2), thresh1_2(2)], 'k', 'linewidth',2)
    title('hit any key to continue')
    pause()
    close()
end
if ~isempty(nogo_pecks_2)
    figure
    scatter(nogo_pecks_2(:,1), nogo_pecks_2(:,2))
    title('Side 2 trials: select threshold point 1 (left point)');
    hold on;
    scatter(go_pecks_2(:,1), go_pecks_2(:,2), 'r')
    thresh2_1 = ginput(1);
    hold off;
    scatter(nogo_pecks_2(:,1), nogo_pecks_2(:,2))
    title('Side 2 trials: select threshold point 2 (right point)');
    hold on;
    scatter(go_pecks_2(:,1), go_pecks_2(:,2), 'r')
    scatter(thresh2_1(1), thresh2_1(2), 'ks', 'markerfacecolor', 'k')
    thresh2_2 = ginput(1);
    plot([thresh2_1(1), thresh2_2(1)], [thresh2_1(2), thresh2_2(2)], 'k', 'linewidth',2)
    title('hit any key to continue')
    pause()
    close()
end

for i = 1:length(all_outputs)
    output = all_outputs(i);
    for j = 1:length(output.contrast)
        ox_peck = output.ox_peck(j);
        oy_peck = output.oy_peck(j);
        if output.stim_pos(j) == 1, % right side stimulus
            xB = [thresh1_1(1), thresh1_2(1)];
            yB = [thresh1_1(2), thresh1_2(2)];
            resp = above_line(xB, yB, ox_peck, oy_peck);

        elseif output.stim_pos(j) == 2, % left side stimulus
            xB = [thresh2_1(1), thresh2_2(1)];
            yB = [thresh2_1(2), thresh2_2(2)];
            resp = above_line(xB, yB, ox_peck, oy_peck);

        end



        trial_hitmiss = 0;

        if output.go(j) == 1 && resp == 0, trial_hitmiss = 1; end

        if output.go(j) == 0 && resp == 1, trial_hitmiss = 1; end


        if trial_hitmiss < 0 % check why this would be the case

            trial_hitmiss = nan;

        end
        output.success = [output.success, trial_hitmiss];

        %% get RT and peck accuracy only for correct, go trials

        if trial_hitmiss == 1
            if output.go(j) == 1

                peck_err = sqrt((ox_peck - output.targ_x(j)).^2 + (oy_peck - output.targ_y(j)).^2);


                output.rxn_time = [output.rxn_time,  output.resp_time(j)];
                output.rxn_time_nogo = [output.rxn_time_nogo, NaN];
                output.error = [output.error, peck_err];

            else
                output.rxn_time = [output.rxn_time, NaN];
                output.rxn_time_nogo = [output.rxn_time_nogo, output.resp_time(j)];
                output.error = [output.error, NaN];
            end
        else
            output.rxn_time = [output.rxn_time, NaN];
            output.rxn_time_nogo = [output.rxn_time_nogo, NaN];
            output.error = [output.error, NaN];
        end
    end
    all_outputs(i) = output;
    title('Session response categorizations')
    pause(.5);
    close();
end

%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%