%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Log start time of a script after triggering (typically
%%%% called from within a triggering method; see below)
%%%% 2024 asathe@mit.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function run_start_time = log_time()
  
  run_start_time = GetSecs;

  % global script_start_time;
  % fprintf('\n------------- TRIGGERED! STARTING RUN! Run onset since start of script: %f\n', run_start_time-script_start_time)
  
  fprintf('\n\nTRIGGERED! STARTING RUN! Run onset (absolute): %f\n', run_start_time)
end
