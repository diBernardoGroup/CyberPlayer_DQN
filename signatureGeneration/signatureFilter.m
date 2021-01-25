function [ positionFiltered ] = signatureFilter(position)

    global naturalFrequencyPlayer dt_MC

    %butterworth filter
    %first order with cutoff frequency in the natural frequency of the player
    [b, a] = butter(2, (2*naturalFrequencyPlayer)/(1/(dt_MC*2)), 'low');
    
    %b and a are the transfer function coefficients
    positionFiltered = filtfilt(b, a, position);
end

