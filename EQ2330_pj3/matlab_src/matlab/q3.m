clc;
clear;

frame_width = 176;
frame_height = 144;
block_size = 16;
num_of_frames = 50;
video_path = '../../foreman_qcif/foreman_qcif.yuv';

video = yuv_import_y(video_path, [frame_width, frame_height], num_of_frames);

shift_vectors = -10:1:10;

best_shift = get_best_shift(video, block_size);

