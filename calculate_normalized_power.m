function normalized_psd = calculate_normalized_power(psd_matrix)
    % calculate_normalized_power - Calculates the normalized power of multiple PSD curves
    % psd_matrix - A 2D matrix where each row represents a PSD curve of a signal
    
    % Initialize the output matrix
    normalized_psd = zeros(size(psd_matrix));
    
    % Number of PSD curves
    num_curves = size(psd_matrix, 1);
    
    % Iterate over each PSD curve
    for i = 1:num_curves
        % Select the i-th PSD curve
        psd_curve = psd_matrix(i, :);
        
        % Calculate the total power of the current PSD curve
        total_power = sum(psd_curve);
        
        % Check for zero to prevent division by zero
        if total_power ~= 0
            % Calculate the normalized power (fraction of total)
            normalized_psd(i, :) = psd_curve / total_power;
        else
            % If total power is zero, set the normalized PSD to zero (or handle as needed)
            normalized_psd(i, :) = zeros(1, size(psd_matrix, 2));
        end
    end
end
