%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Use KbQueue and a certain allowable latency (ms) 
%%%% so we don't miss any short pulse triggers 
%%%% tradeoff: won't miss triggers but has some latency
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function run_start_time = wait_for_trigger_kbqueue(delay_milliseconds, timeout_seconds)
  arguments
        delay_milliseconds = 100,
        timeout_seconds = 1.0
  end
  
  KbName('UnifyKeyNames')

  fprintf('--------- CALLED `wait_for_trigger_kbqueue`\n')

  % 'keyList' is an optional 256-length vector of doubles (not logicals)  
  %  with each element corresponding to a particular key (use [KbName](KbName)  
  %  to map between keys and their positions). If the double value  
  %  corresponding to a particular key is zero, events for that key  
  %  are not added to the queue and will not be reported.
  % see also: https://github.com/caomw/Psychtoolbox-3/blob/master/Psychtoolbox/PsychBasic/KbTriggerWait.m
  keyList = zeros(1, 256, 'double');
  keyList(KbName('=+')) = 1.0;
  keyList(KbName('+')) = 1.0;
  keyList(KbName('Escape')) = 1.0;
  
  % still allow exiting via KbCheck for triggering via scanning laptop (useful for debugging) 
  % but only check esc and trigger keys
  RestrictKeysForKbCheck([KbName('=+'), KbName('+'), KbName('Escape')])
  
  dvc = find_device;

  KbQueueCreate(dvc, keyList);
  KbQueueStart(dvc);
  KbQueueFlush(dvc);
  WaitSecs(double(delay_milliseconds) / 1000.0);
  
  evt = [];
  while ~KbCheck && isempty(evt)
      % Wait up to timeout_seconds for a new trigger event
      evt = KbEventGet(dvc, timeout_seconds);
  end
  % secs = KbQueueWait([deviceIndex][, forWhat=0][, untilTime=inf]) % http://psychtoolbox.org/docs/KbQueueWait
  run_start_time = evt.Time; %KbQueueWait(dvc);
  log_time;
  
  % Release queue
  KbEventFlush(dvc);
  KbQueueRelease(dvc);

end
