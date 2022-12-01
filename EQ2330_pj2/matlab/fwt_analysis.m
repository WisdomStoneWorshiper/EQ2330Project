function [cA,cD] = fwt_analysis(signal, LPF)
    HPF = wrev(qmf(wrev(LPF)));
    
    padded = padarray(signal, [0,length(LPF)-1], "circular");
    
    output_lp = conv(padded, LPF, "full");
    output_hp = conv(padded, HPF, "full");
    
    output_lp = output_lp((length(LPF)-1)*2:(length(LPF)-1)*2+length(signal)-1);
    output_hp = output_hp((length(HPF)-1)*2:(length(HPF)-1)*2+length(signal)-1);

    cA = downsample(output_lp, 2);
    cD = downsample(output_hp, 2);
    
end

