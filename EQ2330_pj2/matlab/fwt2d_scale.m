function [LLs, LHs, HLs, HHs] = fwt2d_scale(img, scale)
    [ LPF, ~, ~, ~] = wfilters("db8");
    curr_LL = img;
    LLs = cell(1,scale);
    LHs = cell(1,scale);
    HLs = cell(1,scale);
    HHs = cell(1,scale);

    for i = 1:scale
        [LLs{i}, LHs{i}, HLs{i}, HHs{i}] = fwt2d(curr_LL, LPF);
        curr_LL = LLs{i};
    end
end

