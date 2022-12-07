function [cA,cD] = fwt_analysis(signal, LPF)
    % find the coresponing high pass filter
    HPF = wrev(qmf(wrev(LPF)));
    
    % add the periodic extension to the input signal to prevent border
    % effect
    padded = padarray(signal, [0,length(LPF)-1], "circular");
    
    output_lp = conv(padded, LPF, "full");
    output_hp = conv(padded, HPF, "full");
    
    %remove padding
    output_lp = output_lp((length(LPF)-1)*2:(length(LPF)-1)*2+length(signal)-1);
    output_hp = output_hp((length(HPF)-1)*2:(length(HPF)-1)*2+length(signal)-1);

    cA = downsample(output_lp, 2);
    cD = downsample(output_hp, 2);
    
end

