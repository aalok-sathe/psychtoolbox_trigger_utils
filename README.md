# TOOL_Matlab_trigger_utils

This set of scripts reliably picks up triggers from the _Current Designs_ interface box in 
the fMRI scanning environment. 

Previous methods to check for trigger had a mechanism by which they occasionally failed to trigger on time.
Failing to trigger on time can offset your experiment's neural data and the logged stimulus data by 1 TR (or more),
throwing off your modeling (reducing effect sizes for block design, or completely screwing with event-related design).
To understand why the previous methods sometimes failed, and how we came up with the code in this repo, see:
https://github.mit.edu/EvLab/REFERENCE_tech_wiki/blob/master/matlab/missed_triggers_workaround.md

What you can do: use this updated script in a very simple way, explained below. 

# Adding these utils to your main script:

- First, clone the repository at the top level of experiments (`~/evlab-experiments`) 
    on the scanning laptop using
    ```
    git clone git@github.mit.edu:evlab/TOOL_Matlab_trigger_utils.git
    ```
- Create a symlink to that directory from **your experiment script top-level**
    ```bash
    ln -s ~/evlab-experiments/TOOL_Matlab_trigger_utils
    ```
- Next, modify your main script to include the new cloned repo in its path
    ```matlab
    TRIGGER_UTIL_DIR = [pwd filesep 'TOOL_Matlab_trigger_utils']; % trigger utils dir
    addpath(TRIGGER_UTIL_DIR);
    ```
- Finally, include a statement in your main script where you need to wait for the trigger
    ```matlab
    run_start_time = wait_for_trigger_kbqueue;
    ```
    
- NOTE: it may be necessary to **restart MATLAB** when you connect the USB for the trigger box
    since using an existing MATLAB session may prevent the script from detecting any
    newly attached devices
