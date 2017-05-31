# knudsen_paper

[DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.801558.svg)](https://doi.org/10.5281/zenodo.801558)

Analysis scripts

Scripts used to analyze the data have been deposited in Mendeley Data under the name Analysis scripts (DOI:10.5281/zenodo.801558). To run all of the scripts requires Matlab 2017a.

‘tabulate_data’ computes the response metrics. Load either one data folder or two data folders (to compare across conditions) into the directory; enter graphically the spatial partition boundary defining go (box) versus nogo (cross) responses, and enter the distractor strength for partitioning trials with weak versus strong distractors (0.05 in this paper).

‘output=load_experiment’ plots the spatial pattern of responses. Load either one data folder or two data folders (to compare across conditions) into the directory; enter graphically the spatial partition boundary defining go (box) versus nogo (cross) responses. This script calls ‘load_data_current_folder_manual’ and downloads performance values used for calculations by other scripts.

‘bootstrap_d_and_c’ computes the significance of differences across data folders. First, download the data using ‘output=load_experiment’. Enter the distractor strength for partitioning trials with weak versus strong distractors (0.05 in this paper). Then run this script. It calls ‘permutation_test_2AFC’ to calculate p values for the contingency table and ‘permutation_test_2AFC_compare’ to compare the values between tables.

’performance_by_contrast_all’ computes performance metrics for each distractor contrast. First, download the data using ‘output=load_experiment’. Enter the distractor strength for partitioning trials with weak versus strong distractors (0.05 in this paper). Then run this script. It calls ‘contcatenate_folders’ to group data across sessions.

‘cueing_effect’ measures and tests for the significance of cueing on choice. Load two data folders into the directory and run the script (requires Matlab 2017a).

Figure 1 data

The data files have been deposited in Mendeley Data under the name Fig 1 (DOI:10.5281/zenodo.801558). Analysis script: ‘output=load_experiment’.

Figure 3 data

The data files have been deposited in Mendeley Data under the name Fig 3 (DOI:10.5281/zenodo.801558). Analysis scripts: ‘tabulate_data’, ‘output=load_experiment’, and ‘bootstrap_d_and_c’.

Figure 5 data

The data files have been deposited in Mendeley Data under the name Fig 5 (DOI:10.5281/zenodo.801558). Analysis script: ‘output=load_experiment’.

Figure 6 data

The data files have been deposited in Mendeley Data under the name Fig 6 (DOI:10.5281/zenodo.801558). The data files have been deposited in Mendeley Data under the name Fig 3 (DOI:10.5281/zenodo.801558). Analysis scripts: ‘tabulate_data’, ‘output=load_experiment’, and ‘bootstrap_d_and_c’.

Figure 7 data

The data files have been deposited in Mendeley Data under the name Fig 7 (DOI:10.5281/zenodo.801558). Analysis scripts: ‘cueing_effect’.

Figure S1 data

The data files have been deposited in Mendeley Data under the name Fig S1 (DOI:10.5281/zenodo.801558). Analysis scripts: ‘output=load_experiment’ and ’performance_by_contrast_all’.

Figure S2 data

The data files have been deposited in Mendeley Data under the name Fig S2 (DOI:10.5281/zenodo.801558). Analysis scripts: ‘tabulate_data’, ‘output=load_experiment’, and ‘bootstrap_d_and_c’.

Figure S3 data

The data files have been deposited in Mendeley Data under the name Fig 1 (DOI:10.5281/zenodo.801558). Analysis scripts: ‘tabulate_data’, ‘output=load_experiment’, and ‘bootstrap_d_and_c’.
