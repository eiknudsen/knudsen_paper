function find_percent_correct(chickenfile)

params_str = strcat(chickenfile, '_params.mat');
data_str = strcat(chickenfile, '.mat');
load(params_str)
load(data_str)

parameter_struct = struct();
if sum(distractorColor) ~= 0;
    parameter_struct.distractors_on = 1;
else
    parameter_struct.distractors_on = 0;
end
parameter_struct.cue_on = tdCueOn;
parameter_struct.target_strength = threshval_pos(1);

crossX = 512+fixXOffset;
crossY = 384+fixYOffset;
right_nogoX = [];
right_nogoY = [];
right_goX = [];
right_goY = [];
left_nogoX = [];
left_nogoY = [];
left_goX = [];
left_goY = [];
right_go_time = [];
left_go_time = [];
for i = 1:size(cursCoords, 1);
    if cursCoords(i, 14) == 0;
        if cursCoords(i-1, 9) == 1;
            right_nogoX = [right_nogoX cursCoords(i-1, 1)-crossX];
            right_nogoY = [right_nogoY cursCoords(i-1, 2)-crossY];
        else
            left_nogoX = [left_nogoX cursCoords(i-1, 1)-crossX];
            left_nogoY = [left_nogoY cursCoords(i-1, 2)-crossY];
        end
    end
    if cursCoords(i, 14) == 90;
        if cursCoords(i-1, 9) == 1;
            right_goX = [right_goX cursCoords(i-1,1)-crossX];
            right_goY = [right_goY cursCoords(i-1,2)-crossY];
            right_go_time = [right_go_time cursCoords(i,8)];
        else
            left_goX = [left_goX cursCoords(i-1,1)-crossX];
            left_goY = [left_goY cursCoords(i-1,2)-crossY];
            left_go_time = [left_go_time cursCoords(i,8)];
        end
    end
end
scatter(right_nogoX, right_nogoY)
title('Right trials: select threshold');
hold on;
scatter(right_goX, right_goY, 'r')
thresh_right = ginput(1);
hold off;

figure
scatter(left_nogoX, left_nogoY)
title('Left trials: select threshold');
hold on;
scatter(left_goX, left_goY, 'r')
thresh_left = ginput(1);
hold off;

performance = struct();
performance_time = struct();
%Check percent correct for right side
performance.n_right = length(right_goX) + length(right_nogoX);
right_nogo_correct = sum(right_nogoX(right_nogoX~=-1) < thresh_right(1));
performance.right_nogo_perc_correct = right_nogo_correct/length(right_nogoX);
right_correct_go = right_goX(right_goX~=-1) > thresh_right(1);
right_go_correct = sum(right_correct_go);

performance.right_go_perc_correct = right_go_correct/length(right_goX);
performance.right_correct = (right_nogo_correct + right_go_correct)/performance.n_right;

right_go_time_correct = right_go_time(right_correct_go);
performance_time.right_mean_response_time = mean(right_go_time_correct);
performance_time.right_std_response_time = std(right_go_time_correct);


%Check percent correct for left side
performance.n_left = length(left_goX) + length(left_nogoY);
left_nogo_correct = sum(left_nogoX(left_nogoX~=-1) > thresh_left(1));
performance.left_nogo_perc_correct = left_nogo_correct/length(left_nogoX);
left_correct_go = left_goX(left_goX~=-1) < thresh_left(1);
left_go_correct = sum(left_correct_go);
performance.left_go_perc_correct = left_go_correct/length(left_goX);
performance.left_correct = (left_nogo_correct + left_go_correct)/performance.n_left;

left_go_time_correct = left_go_time(left_correct_go);
performance_time.left_mean_response_time = mean(left_go_time_correct);
performance_time.left_std_response_time = std(left_go_time_correct);

parameter_struct
performance_time
performance
