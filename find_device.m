function dev_idx = find_device(target)
    arguments
        % target = 'Current Devices';
        target = 'Microsoft Natural';
    end

    % device class '4' corresponds to keyboards
    devs = PsychHID('Devices', 4);
    
    for idx = 1:length(devs)
        prod = devs(idx).product;
        dev_idx = devs(idx).index;
        fprintf('\nproduct: %s; index: %d\n', prod, dev_idx);
        
        if contains(prod, target)
            % disp(prod);
            break;
        end
    end
end