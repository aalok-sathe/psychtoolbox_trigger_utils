%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Use KbQueue and a certain allowable latency (ms) 
%%%% so we don't miss any short pulse triggers 
%%%% tradeoff: won't miss triggers but has some latency
%%%% 2024, asathe@mit.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function run_start_time = wait_for_trigger_kbqueue(delay_milliseconds, esc_key_latency)
  arguments
      % delay polling the queue after creation of the queue
      % by this amount of time, to avoid missing the first event
      % (though this will almost never happen as we start the
      % stim script before we start the scanner, and that operation
      % introduces a natural and sufficient buffer). note that this
      % has no bearing on the script latency relative to onset time
      % (since trigger)
      delay_milliseconds = 100,
      % we will use a blocking trigger check call to KbEventGet
      % for these many seconds, and only check for ESC key being
      % pressed in between. so this is how long you'll have to
      % press down the ESC key for, in seconds, to ESC out of 
      % the script. making this too low will introduce latency
      % in the script onset. making this high will make ESCing
      % very difficult at trigger time. 
      % note that this again has no bearing on detection of the
      % actual trigger since keyboard events are buffered in a
      % queue and always processed
      esc_key_latency = .20
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
  % keyList(KbName('Escape')) = 1.0;
  
  % still allow exiting via KbCheck for triggering via scanning laptop (useful for debugging) 
  % but only check esc and trigger keys
  RestrictKeysForKbCheck(KbName('Escape'));
  
  dvc = find_device;

  KbQueueCreate(dvc, keyList);
  KbQueueStart(dvc);
  KbQueueFlush(dvc);
  WaitSecs(double(delay_milliseconds) / 1000.0);
  
  evt = [];

  fprintf('WAITING FOR TRIGGER on device = %d.\nTo ESC, hold down ESC key for at least %.2f seconds.\n', dvc, esc_key_latency);
  while ~KbCheck(-1) && isempty(evt)
      % blocking wait up to timeout_seconds for a 
      % new trigger event.
      % note than ESC key needs to be manually pressed up to as
      % long as `esc_key_latency` for this while loop
      % to catch it, because our priority is dedicating
      % resources towards the trigger, not the ESC key.
      % note also that 
      evt = KbEventGet(dvc, esc_key_latency);
      % fprintf('.');
  end

  % Release queue
  KbEventFlush(dvc);
  KbQueueRelease(dvc);
  
  if isempty(evt)
      % evt is [] ie. no trigger received, but KbCheck registered ESCAPE key.
      % END experiment code
      error('EXITING due to ESC!');
  else
      % secs = KbQueueWait([deviceIndex][, forWhat=0][, untilTime=inf]) % http://psychtoolbox.org/docs/KbQueueWait
      run_start_time = evt.Time; %KbQueueWait(dvc);
      log_time;
      
  end

end
