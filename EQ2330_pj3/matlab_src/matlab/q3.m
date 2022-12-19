clc;
clear;

frame_width = 176;
frame_height = 144;
block_size = 16;
num_of_frames = 50;
video_path = '../../foreman_qcif/foreman_qcif.yuv';

[~, avg_intra_bitrates, intra_distortion, ~, org_video, video_intra_idct] = intra_frame_coder(video_path);

video_bitrates = zeros(4, num_of_frames, frame_height / block_size, frame_width / block_size);
% video_bitrates_debug = cell(4, num_of_frames);



residual_bitrates = zeros(4, block_size, block_size);

best_shift = cell(4, 1);

motion_video_re = cell(4, num_of_frames-1);

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

                original_block = video_intra_idct{i - 2, j + 1}(y_start:y_end,x_start:x_end);

                best_shift_y = best_shift{i - 2}(j, k, l, 1);
                best_shift_x = best_shift{i - 2}(j, k, l, 2);

                motion_y_start = y_start+best_shift_y;
                motion_y_end = y_end+best_shift_y;
                motion_x_start = x_start+best_shift_x;
                motion_x_end = x_end+best_shift_x;
                motion_block = video_intra_idct{i - 2, j}(motion_y_start:motion_y_end,motion_x_start:motion_x_end);

                residual_signal =  original_block-motion_block;
                residual_signal_dct = blockproc(residual_signal, [8 8], @(block_struct) dct2(block_struct.data));
                residual_signal_dct_q = quantizer(residual_signal_dct, 2^i);
                residual_signal_idct = blockproc(residual_signal_dct_q, [8 8], @(block_struct) idct2(block_struct.data));
                
                reconstrcuted = motion_block + residual_signal;
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

for i = 3:6

    for j = 1:num_of_frames

        for k = 1:frame_height / block_size

            for l = 1:frame_width / block_size
                y_start = (k - 1) * block_size + 1;
                y_end = k * block_size;
                x_start = (l - 1) * block_size + 1;
                x_end = l * block_size;

                if j == 1
                    video_bitrates(i - 2, j, k, l) = avg_intra_bitrates(i - 2) * block_size ^ 2 + 2;
                    %                     video_bitrates_debug{i - 2, j}(k, l) = intra_bitrates(i - 2, k, l) + 1; % add 2 bits for indicating copy or intra mode

                    video_re{i - 2, j}(y_start:y_end, x_start:x_end) = video_intra_idct{i - 2, j}(y_start:y_end, x_start:x_end);
                else
                    org_frame = org_video{j}(y_start:y_end, x_start:x_end);

                    r_intra = avg_intra_bitrates(i - 2) * (block_size ^ 2) + 2;
                    intra_re = video_intra_idct{i - 2, j}(y_start:y_end, x_start:x_end);
                    intra_distortion = mse(org_frame, intra_re);
                    j_intra = lagrangian_cost(intra_distortion, r_intra, 2 ^ i);

                    r_inter = avg_residual_bitrates(i - 2) * (block_size ^ 2) + 2+10;
                    inter_re = motion_video_re{i - 2, j-1}(y_start:y_end, x_start:x_end);
                    inter_distortion = mse(org_frame, r_inter);
                    j_inter = lagrangian_cost(inter_distortion, r_inter, 2 ^ i);

                    r_copy = 2;
                    last_frame = video_re{i - 2, j - 1}(y_start:y_end, x_start:x_end);
                    copy_distortion = mse(org_frame, last_frame);
                    j_copy = lagrangian_cost(copy_distortion, r_copy, 2 ^ i); % only 2 bits for indicating copy intra mode

                    if j_intra < j_copy && j_intra<j_inter
                        % if intra mode is selected
                        video_bitrates(i - 2, j, k, l) = r_intra;
                        %                         video_bitrates_debug{i - 2, j}(k, l) = intra_bitrates(i - 2, k, l) + 1;
                        video_re{i - 2, j}(y_start:y_end, x_start:x_end) = intra_re;
                    elseif j_inter<j_intra && j_inter<j_copy
                        video_bitrates(i - 2, j, k, l) = r_inter;
                        video_re{i - 2, j}(y_start:y_end, x_start:x_end) = inter_re;
                    else
                        % if copy mode is selected
                        video_bitrates(i - 2, j, k, l) = r_copy;
                        %                         video_bitrates_debug{i - 2, j}(k, l) = 1;
                        video_re{i - 2, j}(y_start:y_end, x_start:x_end) = last_frame;
                    end

                end

            end

        end

        frame_psnr(i - 2, j) = psnr_8bits(org_video{j}, video_re{i - 2, j});
    end

end

avg_video_psnr = mean(frame_psnr, 2);

frame_bitrate = sum(video_bitrates, [3, 4]);

avg_video_bitrate = mean(frame_bitrate, 2);

avg_video_bitrate = avg_video_bitrate * 30/1000;

figure(1);

plot(avg_video_bitrate, avg_video_psnr, '-bo');
title("conditional replenishment with Motion Compensation when lambda = 0.002Q^2");
xlabel("Bit-rates");
ylabel("PSNR");
grid on;
