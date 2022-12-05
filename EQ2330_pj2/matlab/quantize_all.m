function [LLs, LHs, HLs, HHs] = quantize_all(LLs, LHs, HLs, HHs, scale, step)
    for i = 1:scale
        LLs{i} = quantizer(LLs{i}, step);
        LHs{i} = quantizer(LHs{i}, step);
        HLs{i} = quantizer(HLs{i}, step);
        HHs{i} = quantizer(HHs{i}, step);
    end
end

