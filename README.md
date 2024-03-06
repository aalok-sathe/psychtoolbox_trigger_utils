# psychtoolbox-trigger-utils

This set of scripts reliably picks up triggers from the _Current Designs_ interface box in 
the fMRI scanning environment. 

Methods using `KbCheck` in a `while`-loop to check for trigger continuously had a mechanism by which they 
occasionally failed to trigger on time due to the very short pulse width typically sent out by interface boxes.
Failing to trigger on time can offset your experiment's neural data and the logged stimulus data by 1 TR (or more),
throwing off your modeling (reducing effect sizes for block design, or completely screwing with event-related design).

What you can do: use this script in a very simple way, explained below. 

# Adding these utils to your main script:

- First, clone the repository at the top level of experiments (`~/evlab-experiments`) 
    on the scanning laptop (only needs to be done once per laptop) using
    ```bash
    cd ~/experiments
    git clone git@github.com:aalok-sathe/psychtoolbox-trigger-utils.git
    ```
    - If the repository already exists, double-check that it is up to date using `git pull` inside it
        or refer to the `LAST_PULLED_AT....` file if it exists (see bonus point below)
    
- Create a **symlink** to that directory from the **directory containing your experiment script(s)** (needs to be done once per experiment)
    ```bash
    ln -s ~/experiments/psychtoolbox-trigger-utils
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

- As a bonus, copy the `post-merge` script into `.git/hooks/` to create a file
    timestamping the last time this repo was pulled and merged from remote so that
    you know you're always running the latest trigger code: `cp ./post-merge .git/hooks/`
   
- NOTE: it may be necessary to **restart MATLAB** when you connect the USB for the trigger box
    since using an existing MATLAB session may prevent the script from detecting any
    newly attached devices
    
    
If you want to make your experiment **really portable** you may wish to instead clone this repository 
and commit the contents of it alongside your own code, so it gets 'baked into' your experiment code
(this means, though, that you won't receive any updates to this repository in case we need to make
changes down the line). Alternatively, you could add this repository as a [`git submodule`](https://git-scm.com/book/en/v2/Git-Tools-Submodules).
