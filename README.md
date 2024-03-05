# TOOL_Matlab_trigger_utils

Scripts to overcome an issue with missing trigger pulses. To read more about what this is about, see:
https://github.mit.edu/EvLab/REFERENCE_tech_wiki/blob/master/matlab/missed_triggers_workaround.md

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
    
