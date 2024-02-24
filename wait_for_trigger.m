
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% from PsychToolBox docs:
% https://github.com/Psychtoolbox-3/Psychtoolbox-3/blob/master/Psychtoolbox/PsychDocumentation/KbQueue.html
% The Psychophysics Toolbox function KbCheck looks to see which keys are
% 		depressed each time that it is called. In effect, KbCheck answers the
% 		question "Which keys are pressed right now?". By asking this question
% 		repetitively in a tight Mablab code loop, it is possible to get a 
% 		reasonably accurate estimate of the time at which a key was pressed.
% 		However, if a keypress is very brief, it can take place in between
% 		successive calls to KbCheck and can potentially be lost. For example,
% 		the Fiber Optic Response Pad (FORP) manufactured by Current Designs for
% 		use with functional magnetic resonance imaging (fMRI) transduces a 
% 		trigger signal from the MRI scanner into an apparent keypress that lasts 
% 		only 8 msec; such signals are often missed even with the fastest 
% 		processors. 
%
% 		In contrast to KbCheck, the function GetChar answers the question "What
% 		characters have been input to allow this function to return?" where it 
% 		is possible that the relevant characters were input (and released) even
% 		before GetChar was invoked thanks to an internal queueing mechanism
% 		(note that a call to KbCheck might therefore miss characters 
% 		identifiable by a call to GetChar). However, GetChar requires Matlab's 
% 		Java and is not recommended for situations requiring precision timing 
% 		because it is slow and because the timebase used by Java can differ 
% 		substantially from the timebase used by GetSecs (the documentation for 
% 		GetChar indicates that discrepancies can be tens or even hundreds of 
% 		miiliseconds).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

KbName('UnifyKeyNames');

global script_start_time;
script_start_time = GetSecs;

% while 1
%     wait_for_trigger_kbqueue;
% end 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Log start time of a script after triggering (typically
%%%% called from within a triggering method; see below)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function run_start_time = log_time()
  
  run_start_time = GetSecs;

  % global script_start_time;
  % fprintf('\n------------- TRIGGERED! STARTING RUN! Run onset since start of script: %f\n', run_start_time-script_start_time)
  
  fprintf('\n------------- TRIGGERED! STARTING RUN! Run onset (absolute): %f\n', run_start_time)
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Use KbCheck and hope that we have overlap with even the
%%%% shortest of pulse triggers (may miss triggers!)
%%%% taken from MDloc implementation by `lipkinb@mit.edu`
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function wait_for_trigger_kbcheck
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
function run_start_time = wait_for_trigger_kbqueue(latency)
  arguments
        latency = 100
  end
  
  fprintf('--------- CALLED `wait_for_trigger_kbqueue`')

  % 'keyList' is an optional 256-length vector of doubles (not logicals)  
  %  with each element corresponding to a particular key (use [KbName](KbName)  
  %  to map between keys and their positions). If the double value  
  %  corresponding to a particular key is zero, events for that key  
  %  are not added to the queue and will not be reported.
  % see also: https://github.com/caomw/Psychtoolbox-3/blob/master/Psychtoolbox/PsychBasic/KbTriggerWait.m
  keyList = zeros(1, 256, 'double');
  keyList(KbName('=+')) = 1.0;
  keyList(KbName('Escape')) = 1.0;
  
  devices = GetKeyboardIndices;
  KbQueueCreate(-1, keyList);
  KbQueueStart;
  KbQueueFlush;

  [realWakeupTimeSecs] = WaitSecs(double(latency) / 1000.0);
  
  % [pressed, firstPress, firstRelease, lastPress, lastRelease] = KbQueueCheck; %([deviceIndex])
  % KbName(firstPress) % TODO
  
  % secs = KbQueueWait([deviceIndex][, forWhat=0][, untilTime=inf]) % http://psychtoolbox.org/docs/KbQueueWait
  run_start_time_acc_kbq = KbQueueWait(-1);
  run_start_time = log_time;

  fprintf('kbq start minus our start: %f\n', run_start_time - run_start_time_acc_kbq);

end

