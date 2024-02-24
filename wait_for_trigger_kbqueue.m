%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Use KbQueue and a certain allowable latency (ms) 
%%%% so we don't miss any short pulse triggers 
%%%% tradeoff: won't miss triggers but has some latency
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function run_start_time = wait_for_trigger_kbqueue(latency)
  arguments
        latency = 100
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
  keyList(KbName('Escape')) = 1.0;
  
  dvc = find_device;

  KbQueueCreate(dvc, keyList);
  KbQueueStart(dvc);
  KbQueueFlush(dvc);
  WaitSecs(double(latency) / 1000.0);
  
  % secs = KbQueueWait([deviceIndex][, forWhat=0][, untilTime=inf]) % http://psychtoolbox.org/docs/KbQueueWait
  run_start_time = KbQueueWait(dvc);
  log_time;

%   fprintf('kbq start minus our start: %f\n', run_start_time - run_start_time_acc_kbq);

end
