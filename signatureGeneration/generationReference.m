function[Z] = generationReference(currentPlayer)
    
    global dequantizer num_symbols
    global dt_MC T
    global overlapping num_samples
    
    % load MM
    load(['MarkovChains/trained_MM_player' num2str(currentPlayer) '.mat'], 'trained_MM');
    MM = trained_MM;
    
    sequence_length = ceil(((T*(1/dt_MC))/(num_samples - overlapping))-3);
    
    [seq_symbols, seq_states] = hmmgenerate(sequence_length, MM.transitionMatrix, MM.observationMatrix, ...
         'Symbols', 0:1:num_symbols-1);
    
    FFT_sequence = [];

    for z = 1:sequence_length
        %inverse_FFT_position is a matrix 299x20
        FFT_sequence = [FFT_sequence; step(dequantizer, uint16(seq_symbols(z)))'];
    end

    FFT_sequence = FFT_sequence';
    half = (size(FFT_sequence,1)+2)/2;
    FFT_complex_sequence = FFT_sequence(1:half,:)+[zeros(1,sequence_length) ; 1i*FFT_sequence(half+1:end,:) ; zeros(1,sequence_length)];
    % REVERSE WINDOWING
    [position,t] = istft(FFT_complex_sequence, num_samples, num_samples-overlapping, num_samples, dt_MC);
    
    %MM is trained for a range -5,5
    %here the range is -0.5,0.5
    position = signatureFilter(position./10);  
    velocity = fin_diff(position, dt_MC);
    
    Z = [position', velocity]';
end
