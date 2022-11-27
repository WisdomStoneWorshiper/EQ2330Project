function [cA,cD] = fwt_analysis(signal, LPF)
    HPF = wrev(qmf(wrev(LPF)));
    
    padded = padarray(signal, [0,length(LPF)-1], "circular", "pre");
    
    output_lp = conv(padded, LPF, "valid");
    output_hp = conv(padded, HPF, "valid");
    
    cA = downsample(output_lp, 2);
    cD = downsample(output_hp, 2);

end

