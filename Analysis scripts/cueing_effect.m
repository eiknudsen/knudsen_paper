function cueing_effect()
%% data organized as # trials, [correct, incorrect]
% data were binned into 3 distractor bins before computing these counts to account for 
% potentially different numbers/strengths of distractors tested across sessions

figure; set(gcf, 'Position', [100 500 600 260], 'Color', [1 1 1]);

%% Chicken 69's data
% 4 sessions: #420,21,22,23
c69_baseline_cuedR   = [134, 44];   
c69_baseline_uncuedR = [114, 64];

c69_baseline_cuedL   = [148, 29]; 
c69_baseline_uncuedL = [133, 46];

% 11 sessions: #433,37,38,40,41,42,43,44,47,48,51
c69_lesioned_cuedR   = [377, 40];
c69_lesioned_uncuedR = [347, 63];

c69_lesioned_cuedL   = [217, 199];
c69_lesioned_uncuedL = [255, 154];

% 12 sessions: #453,59,62,63,66,68,69,70,71,72,76,79
c69_recovery_cuedR   = [295, 48];
c69_recovery_uncuedR = [273, 72];

c69_recovery_cuedL   = [188, 152]; 
c69_recovery_uncuedL = [192, 147];

concat_counts_baseline = [c69_baseline_cuedR, c69_baseline_uncuedR, c69_baseline_cuedL, c69_baseline_uncuedL];
concat_counts_lesioned = [c69_lesioned_cuedR, c69_lesioned_uncuedR, c69_lesioned_cuedL, c69_lesioned_uncuedL];
concat_counts_recovery = [c69_recovery_cuedR, c69_recovery_uncuedR, c69_recovery_cuedL, c69_recovery_uncuedL];

disp(' --- ')
disp(' '); disp('Chicken 69: Baseline');
[dR_b, dL_b] = fisher_test(concat_counts_baseline);
disp(' '); disp('Chicken 69: Lesion');
[dR_l, dL_l] = fisher_test(concat_counts_lesioned);
disp(' '); disp('Chicken 69: Recovery');
[dR_r, dL_r] = fisher_test(concat_counts_recovery);

subplot(122); plot_cueing_effect(100*[dL_b, dR_b, dL_l, dR_l, dL_r, dR_r]); 
axis([0.5 2.5 -12 30]); title('Chicken 69')

%% Chicken 59's data
% 3 sessions: #173,77,84
c59_baseline_cuedR   = [43,  7];   
c59_baseline_uncuedR = [31, 17];

c59_baseline_cuedL   = [32, 17]; 
c59_baseline_uncuedL = [32, 16];
    
% 1 session: #210
c59_lesioned_cuedR   = [15, 17];
c59_lesioned_uncuedR = [14, 18];

c59_lesioned_cuedL   = [19, 13];
c59_lesioned_uncuedL = [21, 12];

% 8 sessions: #212,14,16,39,42,49,54,55
c59_recovery_cuedR   = [86, 62];
c59_recovery_uncuedR = [71, 75];

c59_recovery_cuedL   = [103, 46]; 
c59_recovery_uncuedL = [103, 42];

concat_counts_baseline = [c59_baseline_cuedR, c59_baseline_uncuedR, c59_baseline_cuedL, c59_baseline_uncuedL];
concat_counts_lesioned = [c59_lesioned_cuedR, c59_lesioned_uncuedR, c59_lesioned_cuedL, c59_lesioned_uncuedL];
concat_counts_recovery = [c59_recovery_cuedR, c59_recovery_uncuedR, c59_recovery_cuedL, c59_recovery_uncuedL];

disp(' --- ')
disp(' '); disp('Chicken 59: Baseline');
[dR_b, dL_b] = fisher_test(concat_counts_baseline);
disp(' '); disp('Chicken 59: Lesion');
[dR_l, dL_l] = fisher_test(concat_counts_lesioned);
disp(' '); disp('Chicken 59: Recovery');
[dR_r, dL_r] = fisher_test(concat_counts_recovery);

subplot(121); plot_cueing_effect(100*[dR_b, dL_b, dR_l, dL_l, dR_r, dL_r]); 
axis([0.5 2.5 -12 30]); title('Chicken 59')

function plot_cueing_effect(y)
bar([y(1), y(3), y(5); y(2), y(4), y(6)]);
ylabel('\Delta accuracy: Cued-Uncued')
set(gca, 'XTickLabel', {'Exptl', 'Control'}, 'FontSize', 15);
legend({'Baseline', 'Lesioned', 'Recovery'})

function [dR, dL] = fisher_test(concat_counts)
tR = [concat_counts(1), concat_counts(2); concat_counts(3), concat_counts(4)]; 
[hR,pR,~] = fishertest(tR);
wR = tR./repmat(sum(tR')', 1, 2);
dR = wR(1,1) - wR(2,1);
fprintf('Cueing effect right, p-val: %1.3f\n', pR);

tL = [concat_counts(5), concat_counts(6); concat_counts(7), concat_counts(8)]; 
[hL,pL,~] = fishertest(tL);
wL = tL./repmat(sum(tL')', 1, 2);
dL = wL(1,1) - wL(2,1);
fprintf('Cueing effect left, p-val: %1.3f\n', pL);

