%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% utility defining various ways of capturing 
% trigger input from scanner interface box (i.e., Current Devices 932)
% this file is created due to the following issue: https://github.com/Psychtoolbox-3/Psychtoolbox-3/issues/828
% 2024-02-22, asathe@mit.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

KbName('UnifyKeyNames');

function log_time()
  run_start_time = GetSecs;
  fprintf('\n------------- TRIGGERED! STARTING RUN! Run onset %f\n', run_start_time)


function wait_for_trigger_kbcheck()
  [~, ~, keyCode] = KbCheck;
  while ( ~keyCode(KbName('=+')) )  &&  ~keyCode(KbName('+'))
     [~, ~, keyCode] = KbCheck;
  end
  log_time;
end

function wait_for_trigger_kbqueue()
  [pressed, firstPress, firstRelease, lastPress, lastRelease] = KbQueueCheck; %([deviceIndex])
  log_time;
