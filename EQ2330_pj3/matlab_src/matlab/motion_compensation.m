function [avg_video_psnr, avg_video_bitrate, copy_per, intra_per, inter_per] = motion_compensation(video_path)
    %encode the video using conditional replenishment with copy mode, intra
    %mode and inter mode

    %fixed value
    frame_width = 176;
    frame_height = 144;
    block_size = 16;
    num_of_frames = 50;

    % get teh VLCs of the intra mode
    [~, avg_intra_bitrates, ~, ~, org_video, video_intra_idct] = intra_frame_coder(video_path);

    video_bitrates = zeros(4, num_of_frames, frame_height / block_size, frame_width / block_size);

    residual_bitrates = zeros(4, block_size, block_size);

    best_shift = cell(4, 1);

    motion_video_re = cell(4, num_of_frames - 1);

    % for each step size, find the restructed block and bitrate of the motion compensation
    for i = 3:6
        quantized_video = video_intra_idct(i - 2, :)';

        best_shift{i - 2} = get_best_shift(quantized_video, block_size);
        concated_coffs = 0;

        for j = 1:num_of_frames - 1

            for k = 1:frame_height / block_size

                for l = 1:frame_width / block_size

                    y_start = (k - 1) * block_size + 1;
                    y_end = k * block_size;
                    x_start = (l - 1) * block_size + 1;
                    x_end = l * block_size;

                    original_block = video_intra_idct{i - 2, j + 1}(y_start:y_end, x_start:x_end);

                    best_shift_y = best_shift{i - 2}(j, k, l, 1);
                    best_shift_x = best_shift{i - 2}(j, k, l, 2);

                    motion_y_start = y_start + best_shift_y;
                    motion_y_end = y_end + best_shift_y;
                    motion_x_start = x_start + best_shift_x;
                    motion_x_end = x_end + best_shift_x;
                    motion_block = video_intra_idct{i - 2, j}(motion_y_start:motion_y_end, motion_x_start:motion_x_end);

                    residual_signal = original_block - motion_block;
                    residual_signal_dct = blockproc(residual_signal, [8 8], @(block_struct) dct2(block_struct.data));
                    residual_signal_dct_q = quantizer(residual_signal_dct, 2 ^ i);
                    residual_signal_idct = blockproc(residual_signal_dct_q, [8 8], @(block_struct) idct2(block_struct.data));

                    reconstrcuted = motion_block + residual_signal_idct;
                    motion_video_re{i - 2, j}(y_start:y_end, x_start:x_end) = reconstrcuted;

                    if j == 1 && k == 1 && l == 1
                        concated_coffs = residual_signal_dct_q;
                    else
                        concated_coffs = cat(3, concated_coffs, residual_signal_dct_q);
                    end

                end

            end

        end

        for k = 1:block_size

            for l = 1:block_size
                residual_bitrates(i - 2, k, l) = bitrate(reshape(concated_coffs(k, l, :), 1, []));
            end

        end

    end

    avg_residual_bitrates = mean(residual_bitrates, 2);
    avg_residual_bitrates = mean(avg_residual_bitrates, 3);

    video_re = cell(4, num_of_frames);
    frame_psnr = zeros(4, num_of_frames);

    copy_per = zeros(4, 1);
    intra_per = zeros(4, 1);
    inter_per = zeros(4, 1);

    % for each step size
    for i = 3:6

        copy_count = 0;
        intra_count = 0;
        inter_count = 0;
        total_count = 0;

        % for each frame
        for j = 1:num_of_frames

            for k = 1:frame_height / block_size

                for l = 1:frame_width / block_size
                    y_start = (k - 1) * block_size + 1;
                    y_end = k * block_size;
                    x_start = (l - 1) * block_size + 1;
                    x_end = l * block_size;
                    total_count = total_count + 1;
                    % first frame must be using the intra mode
                    if j == 1
                        intra_count = intra_count +1;
                        video_bitrates(i - 2, j, k, l) = avg_intra_bitrates(i - 2) * block_size ^ 2 + 2;

                        video_re{i - 2, j}(y_start:y_end, x_start:x_end) = video_intra_idct{i - 2, j}(y_start:y_end, x_start:x_end);
                    else
                        org_frame = org_video{j}(y_start:y_end, x_start:x_end);
                        % calculate the lagrangian cost of intra mode
                        r_intra = avg_intra_bitrates(i - 2) * (block_size ^ 2) + 2; % add two bits for indicating copy intra mode
                        intra_re = video_intra_idct{i - 2, j}(y_start:y_end, x_start:x_end);
                        intra_distortion = mse(org_frame, intra_re);
                        j_intra = lagrangian_cost(intra_distortion, r_intra, 2 ^ i);

                        % calculate the lagrangian cost of inter mode
                        % add two bits for indicating copy inter mode, 10 bits for shift vector
                        r_inter = avg_residual_bitrates(i - 2) * (block_size ^ 2) + 2 +10;
                        inter_re = motion_video_re{i - 2, j - 1}(y_start:y_end, x_start:x_end);
                        inter_distortion = mse(org_frame, inter_re);
                        j_inter = lagrangian_cost(inter_distortion, r_inter, 2 ^ i);

                        % calculate the lagrangian cost of copy mode
                        r_copy = 2;
                        last_frame = video_re{i - 2, j - 1}(y_start:y_end, x_start:x_end);
                        copy_distortion = mse(org_frame, last_frame);
                        j_copy = lagrangian_cost(copy_distortion, r_copy, 2 ^ i); % only 2 bits for indicating copy intra mode

                        if j_intra < j_copy && j_intra < j_inter
                            % if intra mode is selected
                            intra_count = intra_count +1;
                            video_bitrates(i - 2, j, k, l) = r_intra;
                            video_re{i - 2, j}(y_start:y_end, x_start:x_end) = intra_re;
                        elseif j_inter < j_intra && j_inter < j_copy
                            % if inter mode is selected
                            inter_count = inter_count +1;
                            video_bitrates(i - 2, j, k, l) = r_inter;
                            video_re{i - 2, j}(y_start:y_end, x_start:x_end) = inter_re;
                        else
                            % if copy mode is selected
                            copy_count = copy_count +1;
                            video_bitrates(i - 2, j, k, l) = r_copy;
                            video_re{i - 2, j}(y_start:y_end, x_start:x_end) = last_frame;
                        end

                    end

                end

            end

            frame_psnr(i - 2, j) = psnr_8bits(org_video{j}, video_re{i - 2, j});
        end

        copy_per(i - 2) = copy_count / total_count;
        intra_per(i - 2) = intra_count / total_count;
        inter_per(i - 2) = inter_count / total_count;
    end

    % calculate the average PSNR
    avg_video_psnr = mean(frame_psnr, 2);

    % calculate the average bit-rate
    frame_bitrate = sum(video_bitrates, [3, 4]);

    avg_video_bitrate = mean(frame_bitrate, 2);

    avg_video_bitrate = avg_video_bitrate * 30/1000;
end
