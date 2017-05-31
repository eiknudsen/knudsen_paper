function results = tabulate_data(threshold);

% In the form results = tabulate_data(threshold); threshold is the contrast
% threshold you wish to set. This program loads the folders from your
% current directory, concatenates the data inside of them, and spits out
% tabulated data values.

% Structure = results.folder.params.side.cue.value
% Want = folder.side.param.contrast.value = 1x1x4x2x3 = 24 per side. Get
% nanmean, standard deviation, n for each.

results = [];
output = load_experiment;
new_block = concatenate_folders(output);

results = struct; % Will get filled with sorted contrast and success vectors
curr_dir = pwd; % Get the overarching MATLAB folder string the sub folders are in

last_part = find(curr_dir=='\'); % Find all of the \ in the current directory. Using this in lieu of strsplit due to older MATLAB version.
excel_name = curr_dir(last_part(end)+1:end); % Get the overarching folder name. This will be the name of the excel file
table_scale = -7; % This will be a counter used to make sure each side for each folder gets listed sequentially lower down the excel document
big_table = {}; % This is a cell that will store all of the headers and data we generate

for i = 1:length(new_block); % 1 loop for each folder. This is the big overarching loop
    
    table_scale = table_scale+7; % Advances the printout so they don't overwrite eachother in the excel document
    contrast_hold = [];
    high_contrast = [];
    low_contrast = [];
    contrast_hold = [];
    side_1 = [];
    side_2 = [];
    high_contrast(1,:) = new_block(i).data.contrast>=threshold; % Creates binary high/low contrast
    low_contrast(1,:) = new_block(i).data.contrast<threshold; % Creates binary high/low contrast
    contrast_hold(1,:) = new_block(i).data.success; % For percent correct
    contrast_hold(2,:) = new_block(i).data.go; % For go/no go trials
    A = nanmean(unique(new_block(i).data.targ_x)); % Mean of x values for chicken target location
    side_1 = new_block(i).data.targ_x>=A; % Less than = side_2, greater than = side_1
    side_2 = new_block(i).data.targ_x<A; % Less than = side_2, greater than = side_1
    contrast_hold(3,:) = new_block(i).data.resp_time; % For response latency
    
    side_1_high = [];
    side_1_low = [];
    side_2_high = [];
    side_2_low = [];
    side_1_go_low = [];
    side_1_go_high = [];
    side_1_nogo_low = [];
    side_1_nogo_high = [];
    side_2_go_low = [];
    side_2_go_high = [];
    side_2_nogo_high = [];
    side_2_nogo_low = [];
    
    side_1_high = contrast_hold(:,side_1==1 & high_contrast==1); % Pick out side_1 high contrast values
    side_1_low = contrast_hold(:,side_1==1 & low_contrast==1); % Pick out side_1 low contrast values
    side_2_high = contrast_hold(:,side_2==1 & high_contrast==1); % Pick out side_2 high contrast values
    side_2_low = contrast_hold(:,side_2==1 & low_contrast==1); % Pick out side_2 low contrast values
    side_1_go_low = contrast_hold(:,side_1==1 & low_contrast==1 & contrast_hold(2,:)==1); % for the go trials with low contrast on side 1
    side_1_go_high = contrast_hold(:,side_1==1 & high_contrast==1 & contrast_hold(2,:)==1);
    side_1_nogo_low = contrast_hold(:,side_1==1 & low_contrast==1 & contrast_hold(2,:)==0);
    side_1_nogo_high = contrast_hold(:,side_1==1 & high_contrast==1 & contrast_hold(2,:)==0);
    side_2_go_low = contrast_hold(:,side_2==1 & low_contrast==1 & contrast_hold(2,:)==1);
    side_2_go_high = contrast_hold(:,side_2==1 & high_contrast==1 & contrast_hold(2,:)==1);
    side_2_nogo_low = contrast_hold(:,side_2==1 & low_contrast==1 & contrast_hold(2,:)==0);
    side_2_nogo_high = contrast_hold(:,side_2==1 & high_contrast==1 & contrast_hold(2,:)==0);
      
    folder = new_block(i).experiment; % The folder the i loop is on.
    
    % Create excel file and headings for it
    
    for j = 1:28 % Number of things being calculated
        big_table(table_scale+i,j) = {folder}; % Write folder name in cell
        big_table(table_scale+i+1,j) = {'side_1'}; % Write folder name in cell
    end
    
    for j = 1:10
        big_table(table_scale+i+2,j) = {'Percent_Correct'};
    end
    
    for j = 1:6 % 24/4 = 6
        big_table(table_scale+i+2,j+10) = {'Response_Latency'};
        big_table(table_scale+i+2,j+16) = {'go_trials'};
        big_table(table_scale+i+2,j+22) = {'no-go_trials'};
    end
    
    for j = 1:5
        big_table(table_scale+i+3,j) = {'Low_Contrast'};
    end
    
    for j = 1:5
        big_table(table_scale+i+3,j+5) = {'High_Contrast'};
    end
    
    for j = 1:6
        
        if mod(j,2)==1
            for a = 1:3
                big_table(table_scale+i+3,10+(j*3)-3+a) = {'Low_Contrast'};
            end
        end
        
        if mod(j,2)==0
            for a = 1:3
                big_table(table_scale+i+3,10+(j*3)-3+a) = {'High_contrast'};
            end
        end
        
    end
        
        big_table(table_scale+i+4,1) = {'Mean'};
        big_table(table_scale+i+4,2) = {'Std'};
        big_table(table_scale+i+4,3) = {'n'};
        big_table(table_scale+i+4,4) = {'d_prime'};
        big_table(table_scale+i+4,5) = {'bias'};
        big_table(table_scale+i+4,6) = {'Mean'};
        big_table(table_scale+i+4,7) = {'Std'};
        big_table(table_scale+i+4,8) = {'n'};
        big_table(table_scale+i+4,9) = {'d_prime'};
        big_table(table_scale+i+4,10) = {'bias'};
        
    for j = 1:6
        big_table(table_scale+i+4,8+(j*3)) = {'Mean'};
        big_table(table_scale+i+4,9+(j*3)) = {'Std'};
        big_table(table_scale+i+4,10+(j*3)) = {'n'};  
    end
    
    % Calculate Values for side 1 percent correct low contrast
    
    side_1_percent_correct_low_contrast_nanmean = sum(side_1_low(1,:))/length(side_1_low(1,:)); % percent correct
    % I left the extra trials in here, which get shaved off in the nanstd
    % calculation due to the window size.
    ten_trial_nanmean = [];
    
    for j = 1:floor(length(side_1_low)/10) % 1 loop for each 10 trials in low contrast
        ten_trial_nanmean(j,1) = nanmean(side_1_low(1,(10*j)-9:(10*j)));
    end
    
    side_1_percent_correct_low_contrast_nanstd = nanstd(ten_trial_nanmean);
    side_1_percent_correct_low_contrast_n = length(side_1_low);
    
    big_table(table_scale+i+5,1) = {side_1_percent_correct_low_contrast_nanmean};
    big_table(table_scale+i+5,2) = {side_1_percent_correct_low_contrast_nanstd};
    big_table(table_scale+i+5,3) = {side_1_percent_correct_low_contrast_n};
    
    % d_prime and bias NEED TO CHECK THIS. Checked, it's good.
                 
%     hr1 = [nanmean(contrast_hold(1,(low_contrast==1 & side_1==1 & contrast_hold(2,:)==1))), nanmean(contrast_hold(1,(high_contrast==1 & side_1==1 & contrast_hold(2,:)==1)))] *(1-10^-12) + 10^-16;
%     far1 = [nanmean(~contrast_hold(1,(low_contrast==1 & side_1==1 & contrast_hold(2,:)==0))), nanmean(~contrast_hold(1,(high_contrast==1 & side_1==1 & contrast_hold(2,:)==0)))] *(1-10^-12)+ 10^-16;
%     d_prime_low = [norminv(hr1) - norminv(far1)];
%     response_bias_low = [-(norminv(hr1) + norminv(far1))/2];

    low_contrast_hits = sum(contrast_hold(1,(low_contrast==1 & side_1==1 & contrast_hold(2,:)==1)));
    high_contrast_hits = sum(contrast_hold(1,(high_contrast==1 & side_1==1 & contrast_hold(2,:)==1)));
    low_contrast_false_alarms = sum(~contrast_hold(1,(low_contrast==1 & side_1==1 & contrast_hold(2,:)==0)));
    high_contrast_false_alarms = sum(~contrast_hold(1,(high_contrast==1 & side_1==1 & contrast_hold(2,:)==0)));
    
    low_contrast_hit_length = length(contrast_hold(1,(low_contrast==1 & side_1==1 & contrast_hold(2,:)==1)));
    high_contrast_hit_length = length(contrast_hold(1,(high_contrast==1 & side_1==1 & contrast_hold(2,:)==1)));
    low_contrast_false_alarm_length = length(~contrast_hold(1,(low_contrast==1 & side_1==1 & contrast_hold(2,:)==0)));
    high_contrast_false_alarm_length = length(~contrast_hold(1,(high_contrast==1 & side_1==1 & contrast_hold(2,:)==0)));
    
    hr1 = [((low_contrast_hits*(100/low_contrast_hit_length))+1)/102,((high_contrast_hits*(100/high_contrast_hit_length))+1)/102]; % Normalize to 100 then add 1, to get rid of high d' values
    far1 = [((low_contrast_false_alarms*(100/low_contrast_false_alarm_length))+1)/102,((high_contrast_false_alarms*(100/high_contrast_false_alarm_length))+1)/102]; % Normalize to 100 then add 1, to get rid of high d' values
    
    d_prime_low = [norminv(hr1) - norminv(far1)];
    response_bias_low = [-(norminv(hr1) + norminv(far1))/2];
    
    big_table(table_scale+i+5,4) = {d_prime_low(1,1)};
    big_table(table_scale+i+5,5) = {response_bias_low(1,1)};
    big_table(table_scale+i+5,9) = {d_prime_low(1,2)}; % For high contrast
    big_table(table_scale+i+5,10) = {response_bias_low(1,2)}; % For high contrast
    
    % Calculate Values for side 1 percent correct high contrast
    
    side_1_percent_correct_high_contrast_nanmean = sum(side_1_high(1,:))/length(side_1_high(1,:)); % percent correct
    % I left the extra trials in here, which get shaved off in the nanstd
    % calculation due to the window size.
    ten_trial_nanmean = [];
    
    for j = 1:floor(length(side_1_high)/10) % 1 loop for each 10 trials in high contrast
        ten_trial_nanmean(j,1) = nanmean(side_1_high(1,(10*j)-9:(10*j)));
    end
    
    side_1_percent_correct_high_contrast_nanstd = nanstd(ten_trial_nanmean);
    side_1_percent_correct_high_contrast_n = length(side_1_high);
    
    big_table(table_scale+i+5,6) = {side_1_percent_correct_high_contrast_nanmean};
    big_table(table_scale+i+5,7) = {side_1_percent_correct_high_contrast_nanstd};
    big_table(table_scale+i+5,8) = {side_1_percent_correct_high_contrast_n};
    
    % Calculate Values for side 1 response latency low contrast
    
    side_1_response_latency_low_contrast_nanmean = nanmean(side_1_low(3,:));
    side_1_response_latency_low_contrast_nanstd = nanstd(side_1_low(3,:));
    side_1_response_latency_low_contrast_n = length(side_1_low(3,:));
    
    big_table(table_scale+i+5,11) = {side_1_response_latency_low_contrast_nanmean};
    big_table(table_scale+i+5,12) = {side_1_response_latency_low_contrast_nanstd};
    big_table(table_scale+i+5,13) = {side_1_response_latency_low_contrast_n};
    
    % Calculate Values for side 1 response latency high contrast
    
    side_1_response_latency_high_contrast_nanmean = nanmean(side_1_high(3,:));
    side_1_response_latency_high_contrast_nanstd = nanstd(side_1_high(3,:));
    side_1_response_latency_high_contrast_n = length(side_1_high(3,:));
    
    big_table(table_scale+i+5,14) = {side_1_response_latency_high_contrast_nanmean};
    big_table(table_scale+i+5,15) = {side_1_response_latency_high_contrast_nanstd};
    big_table(table_scale+i+5,16) = {side_1_response_latency_high_contrast_n};
    
    % Calculate values for go trials low contrast
        
    ten_trial_nanmean = [];
    for j = 1:floor(length(side_1_go_low)/10) % 1 loop for each 10 trials in low contrast
        ten_trial_nanmean(j,1) = nanmean(side_1_go_low(1,(10*j)-9:(10*j)));
    end
    
     side_1_go_low_perc_corr = nanmean(side_1_go_low(1,:));
     side_1_go_low_nanstd = nanstd(ten_trial_nanmean);
     side_1_go_low_n = length(side_1_go_low(1,:));
     
    big_table(table_scale+i+5,17) = {side_1_go_low_perc_corr};
    big_table(table_scale+i+5,18) = {side_1_go_low_nanstd};
    big_table(table_scale+i+5,19) = {side_1_go_low_n};
    
    % Calculate values for go trials high contrast
    
    ten_trial_nanmean = [];
    for j = 1:floor(length(side_1_go_high)/10) % 1 loop for each 10 trials in high contrast
        ten_trial_nanmean(j,1) = nanmean(side_1_go_high(1,(10*j)-9:(10*j)));
    end
    
     side_1_go_high_perc_corr = nanmean(side_1_go_high(1,:));
     side_1_go_high_nanstd = nanstd(ten_trial_nanmean);
     side_1_go_high_n = length(side_1_go_high(1,:));
     
    big_table(table_scale+i+5,20) = {side_1_go_high_perc_corr};
    big_table(table_scale+i+5,21) = {side_1_go_high_nanstd};
    big_table(table_scale+i+5,22) = {side_1_go_high_n};
    
    % Calculate values for no-go trials low contrast
    
        ten_trial_nanmean = [];
    for j = 1:floor(length(side_1_nogo_low)/10) % 1 loop for each 10 trials in low contrast
        ten_trial_nanmean(j,1) = nanmean(side_1_nogo_low(1,(10*j)-9:(10*j)));
    end
    
     side_1_nogo_low_perc_corr = nanmean(side_1_nogo_low(1,:));
     side_1_nogo_low_nanstd = nanstd(ten_trial_nanmean);
     side_1_nogo_low_n = length(side_1_nogo_low(1,:));
     
    big_table(table_scale+i+5,23) = {side_1_nogo_low_perc_corr};
    big_table(table_scale+i+5,24) = {side_1_nogo_low_nanstd};
    big_table(table_scale+i+5,25) = {side_1_nogo_low_n};
    
    % Calculate values for no-go trials high contrast
    
            ten_trial_nanmean = [];
    for j = 1:floor(length(side_1_nogo_high)/10) % 1 loop for each 10 trials in high contrast
        ten_trial_nanmean(j,1) = nanmean(side_1_nogo_high(1,(10*j)-9:(10*j)));
    end
    
     side_1_nogo_high_perc_corr = nanmean(side_1_nogo_high(1,:));
     side_1_nogo_high_nanstd = nanstd(ten_trial_nanmean);
     side_1_nogo_high_n = length(side_1_nogo_high(1,:));
     
    big_table(table_scale+i+5,26) = {side_1_nogo_high_perc_corr};
    big_table(table_scale+i+5,27) = {side_1_nogo_high_nanstd};
    big_table(table_scale+i+5,28) = {side_1_nogo_high_n};
    
%% Side 2
    
    table_scale = table_scale+7;

    for j = 1:28 % Number of things being calculated
        big_table(table_scale+i,j) = {folder}; % Write folder name in cell
        big_table(table_scale+i+1,j) = {'side_2'}; % Write folder name in cell
    end
    
    for j = 1:10
        big_table(table_scale+i+2,j) = {'Percent_Correct'};
    end
    
    for j = 1:6 % 24/4 = 6
        big_table(table_scale+i+2,j+10) = {'Response_Latency'};
        big_table(table_scale+i+2,j+16) = {'go_trials'};
        big_table(table_scale+i+2,j+22) = {'no-go_trials'};
    end
    
    for j = 1:5
        big_table(table_scale+i+3,j) = {'Low_Contrast'};
    end
    
    for j = 1:5
        big_table(table_scale+i+3,j+5) = {'High_Contrast'};
    end
    
    for j = 1:6 % Low/High contrast loop
        
        if mod(j,2)==1
            for a = 1:3
                big_table(table_scale+i+3,10+(j*3)-3+a) = {'Low_Contrast'};
            end
        end
        
        if mod(j,2)==0
            for a = 1:3
                big_table(table_scale+i+3,10+(j*3)-3+a) = {'High_contrast'};
            end
        end
        
    end
        
        big_table(table_scale+i+4,1) = {'Mean'};
        big_table(table_scale+i+4,2) = {'Std'};
        big_table(table_scale+i+4,3) = {'n'};
        big_table(table_scale+i+4,4) = {'d_prime'};
        big_table(table_scale+i+4,5) = {'bias'};
        big_table(table_scale+i+4,6) = {'Mean'};
        big_table(table_scale+i+4,7) = {'Std'};
        big_table(table_scale+i+4,8) = {'n'};
        big_table(table_scale+i+4,9) = {'d_prime'};
        big_table(table_scale+i+4,10) = {'bias'};
        
    for j = 1:6
        big_table(table_scale+i+4,8+(j*3)) = {'Mean'};
        big_table(table_scale+i+4,9+(j*3)) = {'Std'};
        big_table(table_scale+i+4,10+(j*3)) = {'n'};  
    end
    
    
    % Calculate Values for side 2 percent correct low contrast
    
    side_2_percent_correct_low_contrast_nanmean = sum(side_2_low(1,:))/length(side_2_low(1,:)); % percent correct
    % I left the extra trials in here, which get shaved off in the nanstd
    % calculation due to the window size.
    ten_trial_nanmean = [];
    
    for j = 1:floor(length(side_2_low)/10) % 1 loop for each 10 trials in low contrast
        ten_trial_nanmean(j,1) = nanmean(side_2_low(1,(10*j)-9:(10*j)));
    end
    
    side_2_percent_correct_low_contrast_nanstd = nanstd(ten_trial_nanmean);
    side_2_percent_correct_low_contrast_n = length(side_2_low);
    
    big_table(table_scale+i+5,1) = {side_2_percent_correct_low_contrast_nanmean};
    big_table(table_scale+i+5,2) = {side_2_percent_correct_low_contrast_nanstd};
    big_table(table_scale+i+5,3) = {side_2_percent_correct_low_contrast_n};
    
    % d_prime and bias NEED TO CHECK THIS
                 
%     hr1 = [nanmean(contrast_hold(1,(low_contrast==1 & side_2==1 & contrast_hold(2,:)==1))), nanmean(contrast_hold(1,(high_contrast==1 & side_2==1 & contrast_hold(2,:)==1)))] *(1-10^-12) + 10^-16;
%     far1 = [nanmean(~contrast_hold(1,(low_contrast==1 & side_2==1 & contrast_hold(2,:)==0))), nanmean(~contrast_hold(1,(high_contrast==1 & side_2==1 & contrast_hold(2,:)==0)))] *(1-10^-12)+ 10^-16;
%     d_prime_low = [norminv(hr1) - norminv(far1)];
%     response_bias_low = [-(norminv(hr1) + norminv(far1))/2];

    low_contrast_hits_2 = sum(contrast_hold(1,(low_contrast==1 & side_2==1 & contrast_hold(2,:)==1)));
    high_contrast_hits_2 = sum(contrast_hold(1,(high_contrast==1 & side_2==1 & contrast_hold(2,:)==1)));
    low_contrast_false_alarms_2 = sum(~contrast_hold(1,(low_contrast==1 & side_2==1 & contrast_hold(2,:)==0)));
    high_contrast_false_alarms_2 = sum(~contrast_hold(1,(high_contrast==1 & side_2==1 & contrast_hold(2,:)==0)));
    
    low_contrast_hit_length_2 = length(contrast_hold(1,(low_contrast==1 & side_2==1 & contrast_hold(2,:)==1)));
    high_contrast_hit_length_2 = length(contrast_hold(1,(high_contrast==1 & side_2==1 & contrast_hold(2,:)==1)));
    low_contrast_false_alarm_length_2 = length(~contrast_hold(1,(low_contrast==1 & side_2==1 & contrast_hold(2,:)==0)));
    high_contrast_false_alarm_length_2 = length(~contrast_hold(1,(high_contrast==1 & side_2==1 & contrast_hold(2,:)==0)));
    
    hr2 = [((low_contrast_hits_2*(100/low_contrast_hit_length_2))+1)/102,((high_contrast_hits_2*(100/high_contrast_hit_length_2))+1)/102]; % Normalize to 100 then add 1, to get rid of high d' values
    far2 = [((low_contrast_false_alarms_2*(100/low_contrast_false_alarm_length_2))+1)/102,((high_contrast_false_alarms_2*(100/high_contrast_false_alarm_length_2))+1)/102]; % Normalize to 100 then add 1, to get rid of high d' values
    
    d_prime_low = [norminv(hr2) - norminv(far2)];
    response_bias_low = [-(norminv(hr2) + norminv(far2))/2];
    
    big_table(table_scale+i+5,4) = {d_prime_low(1,1)};
    big_table(table_scale+i+5,5) = {response_bias_low(1,1)};
    big_table(table_scale+i+5,9) = {d_prime_low(1,2)}; % For high contrast
    big_table(table_scale+i+5,10) = {response_bias_low(1,2)}; % For high contrast
    
    % Calculate Values for side 2 percent correct high contrast
    
    side_2_percent_correct_high_contrast_nanmean = sum(side_2_high(1,:))/length(side_2_high(1,:)); % percent correct
    % I left the extra trials in here, which get shaved off in the nanstd
    % calculation due to the window size.
    ten_trial_nanmean = [];
    
    for j = 1:floor(length(side_2_high)/10) % 1 loop for each 10 trials in high contrast
        ten_trial_nanmean(j,1) = nanmean(side_2_high(1,(10*j)-9:(10*j)));
    end
    
    side_2_percent_correct_high_contrast_nanstd = nanstd(ten_trial_nanmean);
    side_2_percent_correct_high_contrast_n = length(side_2_high);
    
    big_table(table_scale+i+5,6) = {side_2_percent_correct_high_contrast_nanmean};
    big_table(table_scale+i+5,7) = {side_2_percent_correct_high_contrast_nanstd};
    big_table(table_scale+i+5,8) = {side_2_percent_correct_high_contrast_n};
    
    % Calculate Values for side 1 response latency low contrast
    
    side_2_response_latency_low_contrast_nanmean = nanmean(side_2_low(3,:));
    side_2_response_latency_low_contrast_nanstd = nanstd(side_2_low(3,:));
    side_2_response_latency_low_contrast_n = length(side_2_low(3,:));
    
    big_table(table_scale+i+5,11) = {side_2_response_latency_low_contrast_nanmean};
    big_table(table_scale+i+5,12) = {side_2_response_latency_low_contrast_nanstd};
    big_table(table_scale+i+5,13) = {side_2_response_latency_low_contrast_n};
    
    % Calculate Values for side 1 response latency high contrast
    
    side_2_response_latency_high_contrast_nanmean = nanmean(side_2_high(3,:));
    side_2_response_latency_high_contrast_nanstd = nanstd(side_2_high(3,:));
    side_2_response_latency_high_contrast_n = length(side_2_high(3,:));
    
    big_table(table_scale+i+5,14) = {side_2_response_latency_high_contrast_nanmean};
    big_table(table_scale+i+5,15) = {side_2_response_latency_high_contrast_nanstd};
    big_table(table_scale+i+5,16) = {side_2_response_latency_high_contrast_n};
    
    % Calculate values for go trials low contrast
        
    ten_trial_nanmean = [];
    for j = 1:floor(length(side_2_go_low)/10) % 1 loop for each 10 trials in low contrast
        ten_trial_nanmean(j,1) = nanmean(side_2_go_low(1,(10*j)-9:(10*j)));
    end
    
     side_2_go_low_perc_corr = nanmean(side_2_go_low(1,:));
     side_2_go_low_nanstd = nanstd(ten_trial_nanmean);
     side_2_go_low_n = length(side_2_go_low(1,:));
     
    big_table(table_scale+i+5,17) = {side_2_go_low_perc_corr};
    big_table(table_scale+i+5,18) = {side_2_go_low_nanstd};
    big_table(table_scale+i+5,19) = {side_2_go_low_n};
    
    % Calculate values for go trials high contrast
    
    ten_trial_nanmean = [];
    for j = 1:floor(length(side_2_go_high)/10) % 1 loop for each 10 trials in high contrast
        ten_trial_nanmean(j,1) = nanmean(side_2_go_high(1,(10*j)-9:(10*j)));
    end
    
     side_2_go_high_perc_corr = nanmean(side_2_go_high(1,:));
     side_2_go_high_nanstd = nanstd(ten_trial_nanmean);
     side_2_go_high_n = length(side_2_go_high(1,:));
     
    big_table(table_scale+i+5,20) = {side_2_go_high_perc_corr};
    big_table(table_scale+i+5,21) = {side_2_go_high_nanstd};
    big_table(table_scale+i+5,22) = {side_2_go_high_n};
    
    % Calculate values for no-go trials low contrast
    
        ten_trial_nanmean = [];
    for j = 1:floor(length(side_2_nogo_low)/10) % 1 loop for each 10 trials in low contrast
        ten_trial_nanmean(j,1) = nanmean(side_2_nogo_low(1,(10*j)-9:(10*j)));
    end
    
     side_2_nogo_low_perc_corr = nanmean(side_2_nogo_low(1,:));
     side_2_nogo_low_nanstd = nanstd(ten_trial_nanmean);
     side_2_nogo_low_n = length(side_2_nogo_low(1,:));
     
    big_table(table_scale+i+5,23) = {side_2_nogo_low_perc_corr};
    big_table(table_scale+i+5,24) = {side_2_nogo_low_nanstd};
    big_table(table_scale+i+5,25) = {side_2_nogo_low_n};
    
    % Calculate values for no-go trials high contrast
    
            ten_trial_nanmean = [];
    for j = 1:floor(length(side_2_nogo_high)/10) % 1 loop for each 10 trials in high contrast
        ten_trial_nanmean(j,1) = nanmean(side_2_nogo_high(1,(10*j)-9:(10*j)));
    end
    
     side_2_nogo_high_perc_corr = nanmean(side_2_nogo_high(1,:));
     side_2_nogo_high_nanstd = nanstd(ten_trial_nanmean);
     side_2_nogo_high_n = length(side_2_nogo_high(1,:));
     
    big_table(table_scale+i+5,26) = {side_2_nogo_high_perc_corr};
    big_table(table_scale+i+5,27) = {side_2_nogo_high_nanstd};
    big_table(table_scale+i+5,28) = {side_2_nogo_high_n};
    
end

results = big_table;
