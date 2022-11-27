function output = fwt_synthesis(cA, cD, LPF)
    HPF = qmf(LPF);

    upsampled_cA = upsample(cA ,2);
    upsampled_cD = upsample(cD ,2);

    padded_cA = padarray(upsampled_cA, [0,length(LPF)-1], "circular", "post");
    padded_cD = padarray(upsampled_cD, [0,length(LPF)-1], "circular", "post");

    output1 = conv(padded_cA, LPF, "valid");
    output2 = conv(padded_cD, HPF, "valid");

    output = output1 + output2;
%     output = output(length(LPF):end-length(LPF)+1);
end

