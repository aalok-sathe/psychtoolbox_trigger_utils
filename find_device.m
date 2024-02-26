function dev_idx = find_device(target)
    arguments
        target = 'Current Designs';
        % target = 'Microsoft Natural';
    end

    dev_idx = -1;
    % device class '4' corresponds to keyboards
    devs = PsychHID('Devices', 4);
    
    for idx = 1:length(devs)
        prod = devs(idx).product;
        dev_idx_ = devs(idx).index;
        fprintf('\nproduct: %s; index: %d\n', prod, dev_idx_);
        
        if contains(prod, target)
            dev_idx = dev_idx_;
            % break;
        end
    end
end
