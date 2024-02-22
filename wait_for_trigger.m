
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% 2024-02-22+, asathe@mit.edu
% requires Psychtoolbox 3.0.17+ and MATLAB 2019b+ 
% (will not work on Franklin)
%
% utility defining various ways of capturing trigger input from 
% scanner interface box (i.e., Current Devices 932).
% must be invoked/loaded at the top of a script to be effective
%
% this file is created due to the following issue: 
%   https://github.com/Psychtoolbox-3/Psychtoolbox-3/issues/828
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


KbName('UnifyKeyNames');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Log start time of a script after triggering (typically
%%%% called from within a triggering method; see below)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function log_time()
  run_start_time = GetSecs;
  fprintf('\n------------- TRIGGERED! STARTING RUN! Run onset %f\n', run_start_time)
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Use KbCheck and hope that we have overlap with even the
%%%% shortest of pulse triggers (may miss triggers!)
%%%% taken from MDloc implementation by `lipkinb@mit.edu`
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function wait_for_trigger_kbcheck()
  [~, ~, keyCode] = KbCheck;
  while ( ~keyCode(KbName('=+')) )  &&  ~keyCode(KbName('+'))
     [~, ~, keyCode] = KbCheck;
  end
  log_time;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Use KbQueue and a certain allowable latency (ms) 
%%%% so we don't miss any short pulse triggers 
%%%% tradeoff: won't miss triggers but has some latency
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function wait_for_trigger_kbqueue(latency)
  arguments
        latency = 10
    end
  [pressed, firstPress, firstRelease, lastPress, lastRelease] = KbQueueCheck; %([deviceIndex])
  KbName(firstPress) % TODO
  
  % wait for at least `waitPeriodSecs` seconds. try to be precise. http://psychtoolbox.org/docs/WaitSecs
  [realWakeupTimeSecs] = WaitSecs(double(latency) / 1000.0); 
  
    
  log_time;

end
