clc;
clear;

frame_width = 176;
frame_height = 144;
block_size = 16;
num_of_frames = 50;

[~, ~, intra_distortion, intra_bitrates, org_video, video_intra_idct] = intra_frame_coder('../../foreman_qcif/foreman_qcif.yuv');

video_bitrates = zeros(4, num_of_frames, frame_height / block_size, frame_width / block_size);
% video_bitrates_debug = cell(4, num_of_frames);

video_re = cell(4, num_of_frames);
frame_psnr = zeros(4, num_of_frames);

for i = 3:6

    for j = 1:num_of_frames

        for k = 1:frame_height / block_size

            for l = 1:frame_width / block_size

                if j == 1
                    video_bitrates(i - 2, j, k, l) = intra_bitrates(i - 2, k, l) + 1;
%                     video_bitrates_debug{i - 2, j}(k, l) = intra_bitrates(i - 2, k, l) + 1; % add 1 start bit for indicating copy or intra mode
                    y_start = (k - 1) * block_size + 1;
                    y_end = k * block_size;
                    x_start = (l - 1) * block_size + 1;
                    x_end = l * block_size;
                    video_re{i - 2, j}(y_start:y_end, x_start:x_end) = video_intra_idct{i - 2, j}(y_start:y_end, x_start:x_end);
                else
                    j_intra = lagrangian_cost(intra_distortion(i - 2, j, k, l), intra_bitrates(i - 2, k, l) + 1, 2 ^ i);

                    y_start = (k - 1) * block_size + 1;
                    y_end = k * block_size;
                    x_start = (l - 1) * block_size + 1;
                    x_end = l * block_size;

                    org_frame = org_video{j}(y_start:y_end, x_start:x_end);
                    last_frame = video_re{i - 2, j - 1}(y_start:y_end, x_start:x_end);
                    copy_distortion = mse(org_frame, last_frame);
                    j_copy = lagrangian_cost(copy_distortion, 1, 2 ^ i); % only 1 start bit for indicating copy intra mode

                    if j_intra < j_copy
                        % if intra mode is selected
                        video_bitrates(i - 2, j, k, l) = intra_bitrates(i - 2, k, l) + 1;
%                         video_bitrates_debug{i - 2, j}(k, l) = intra_bitrates(i - 2, k, l) + 1;
                        video_re{i - 2, j}(y_start:y_end, x_start:x_end) = video_intra_idct{i - 2, j}(y_start:y_end, x_start:x_end);
                    else
                        % if copy mode is selected
                        video_bitrates(i - 2, j, k, l) = 0;
%                         video_bitrates_debug{i - 2, j}(k, l) = 1;
                        video_re{i - 2, j}(y_start:y_end, x_start:x_end) = video_re{i - 2, j - 1}(y_start:y_end, x_start:x_end);
                    end

                end

            end

        end

        frame_psnr(i - 2, j) = psnr_8bits(org_video{j}, video_re{i - 2, j});
    end

end

avg_video_psnr = mean(frame_psnr, 2);

avg_video_bitrate = mean(video_bitrates, 3);

avg_video_bitrate = mean(avg_video_bitrate, 4);

avg_video_bitrate = mean(avg_video_bitrate, 2);

avg_video_bitrate = avg_video_bitrate* 30 * frame_width * frame_height / 1000;
