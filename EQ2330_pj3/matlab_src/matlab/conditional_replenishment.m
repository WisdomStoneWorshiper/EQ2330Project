function [avg_video_psnr,avg_video_bitrate, copy_per, intra_per] = conditional_replenishment(video_path)
%encode the video using conditional replenishment with copy mode and intra
%mode

%fixed value
frame_width = 176;
frame_height = 144;
block_size = 16;
num_of_frames = 50;

% get teh VLCs of the intra mode
[~, avg_intra_bitrates, ~, ~, org_video, video_intra_idct] = intra_frame_coder(video_path);

video_bitrates = zeros(4, num_of_frames, frame_height / block_size, frame_width / block_size);

video_re = cell(4, num_of_frames);
frame_psnr = zeros(4, num_of_frames);

copy_per = zeros(4,1);
intra_per = zeros(4,1);

% for each step size
for i = 3:6

    copy_count =0;
    intra_count =0;
    total_count = 0;
    
    % for each frame
    for j = 1:num_of_frames
        
        for k = 1:frame_height / block_size

            for l = 1:frame_width / block_size
                y_start = (k - 1) * block_size + 1;
                y_end = k * block_size;
                x_start = (l - 1) * block_size + 1;
                x_end = l * block_size;
                total_count = total_count+1;

                % first frame must be using the intra mode
                if j == 1
                    intra_count = intra_count +1;
                    video_bitrates(i - 2, j, k, l) = avg_intra_bitrates(i-2)*block_size^2+1;
                    video_re{i - 2, j}(y_start:y_end, x_start:x_end) = video_intra_idct{i - 2, j}(y_start:y_end, x_start:x_end);
                else
                    
                    org_frame = org_video{j}(y_start:y_end, x_start:x_end);
                    % calculate the lagrangian cost of intra mode
                    r_intra = avg_intra_bitrates(i-2)*(block_size^2)+1; % add one bit for indicating copy intra mode
                    intra_re = video_intra_idct{i - 2, j}(y_start:y_end, x_start:x_end);
                    intra_distortion = mse(org_frame, intra_re);
                    j_intra = lagrangian_cost(intra_distortion, r_intra, 2 ^ i);

                    % calculate the lagrangian cost of copy mode
                    last_frame = video_re{i - 2, j - 1}(y_start:y_end, x_start:x_end);
                    copy_distortion = mse(org_frame, last_frame);
                    j_copy = lagrangian_cost(copy_distortion, 1, 2 ^ i); % only 1 bit for indicating copy code mode

                    if j_intra < j_copy
                        % if intra mode is selected
                        intra_count = intra_count +1;
                        video_bitrates(i - 2, j, k, l) = r_intra;
                        video_re{i - 2, j}(y_start:y_end, x_start:x_end) = intra_re;
                    else
                        % if copy mode is selected
                        copy_count = copy_count +1;
                        video_bitrates(i - 2, j, k, l) = 1;
                        video_re{i - 2, j}(y_start:y_end, x_start:x_end) = last_frame;
                    end
                    

                end

            end

        end

        frame_psnr(i - 2, j) = psnr_8bits(org_video{j}, video_re{i - 2, j});
    end
    copy_per(i-2) = copy_count/total_count;
    intra_per(i-2) = intra_count/total_count;

end

% calculate the average PSNR
avg_video_psnr = mean(frame_psnr, 2);

% calculate the average bit-rate
frame_bitrate = sum(video_bitrates,[3,4]);

avg_video_bitrate = mean(frame_bitrate, 2);

avg_video_bitrate = avg_video_bitrate* 30 / 1000;

end

