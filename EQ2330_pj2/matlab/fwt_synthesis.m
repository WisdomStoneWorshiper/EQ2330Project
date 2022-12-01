function output = fwt_synthesis(cA, cD, LPF)
    HPF = qmf(LPF);

    upsampled_cA = upsample(cA ,2);
    upsampled_cD = upsample(cD ,2);

    padded_cA = padarray(upsampled_cA, [0,length(LPF)-1], "circular");
    padded_cD = padarray(upsampled_cD, [0,length(HPF)-1], "circular");

    output1 = conv(padded_cA, LPF, "full");
    output2 = conv(padded_cD, HPF, "full");

    output1 = output1(length(LPF)+1:end - (length(LPF)-1)*2+1);
    output2 = output2(length(HPF)+1:end - (length(HPF)-1)*2+1);

    output = output1 + output2;
end

