%%%%
%%%% 2024 asathe@mit.edu
%%%%

function dev_idx = find_device(target)
    arguments
        target = 'Current Designs';
    end

    alt_target = 'AT Translated Set 2';

    % device class '4' corresponds to keyboards
    devs = PsychHID('Devices', 4);
    dev_idx = -1;
    dev_idx_alt = -1;
    prod = -1;


    for idx = 1:length(devs)
        prod_ = devs(idx).product;
        dev_idx_ = devs(idx).index;
        fprintf('\nproduct: %s; index: %d', prod_, dev_idx_);
        
        if contains(prod_, target)
            dev_idx = dev_idx_;
            % break;
        end
        if contains(prod_, alt_target)
            dev_idx_alt = dev_idx_;
            % break;
        end
    end
    fprintf('\n');

    % if we didn't find the primary target, 
    % try the secondary target (we are probably not
    % in the scanner, and in debug mode)
    if (dev_idx == -1)
        dev_idx = dev_idx_alt;
    end

    fprintf('\nFINAL: index: %d\n\n', dev_idx);

end
