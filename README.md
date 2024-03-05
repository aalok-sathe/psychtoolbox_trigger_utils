# TOOL_Matlab_trigger_utils

Scripts to overcome an issue with missing trigger pulses:
https://github.mit.edu/EvLab/REFERENCE_tech_wiki/blob/master/matlab/missed_triggers_workaround.md

# Adding these utils to your main script:

- First, clone the repository at the same level in your experimental directory using
    `git clone git@github.mit.edu:evlab/TOOL_Matlab_trigger_utils`
- Next, modify your main script to include the new cloned repo:
```matlab
UTIL_DIR = [pwd filesep 'TOOL_Matlab_trigger_utils']; % utils dir
addpath(UTIL_DIR);
```
- Finally, include a statement where you need to wait for trigger:
```matlab
run_start_time = wait_for_trigger_kbqueue;
```