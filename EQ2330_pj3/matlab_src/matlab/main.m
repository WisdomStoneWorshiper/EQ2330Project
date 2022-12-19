% q1
clc;
clear;

frame_width = 176;
frame_height = 144;

foreman = '../../foreman_qcif/foreman_qcif.yuv';
[avg_i_foreman_psnr, avg_i_foreman_bitrates, ~,~,~,~] = intra_frame_coder(foreman);

avg_i_foreman_bitrates = avg_i_foreman_bitrates * 30 * frame_width * frame_height / 1000;

md = '../../mother-daughter_qcif/mother-daughter_qcif.yuv';
[avg_i_md_psnr, avg_i_md_bitrates, ~,~,~,~] = intra_frame_coder(md);

avg_i_md_bitrates = avg_i_md_bitrates * 30 * frame_width * frame_height / 1000;


figure(1);

plot(avg_i_foreman_bitrates, avg_i_foreman_psnr, '-bo');
hold on;
plot(avg_i_md_bitrates, avg_i_md_psnr, '-ro');
xlabel("Bit-rates");
ylabel("PSNR");
legend("foreman", "mother-daughter");
grid on;

%q2

[avg_c_foreman_psnr, avg_c_foreman_bitrates] = conditional_replenishment(foreman);

[avg_c_md_psnr, avg_c_md_bitrates] = conditional_replenishment(md);

figure(2);

plot(avg_i_foreman_bitrates, avg_i_foreman_psnr, '-bo');
hold on;
plot(avg_c_foreman_bitrates, avg_c_foreman_psnr, '-ro');
xlabel("Bit-rates");
ylabel("PSNR");
legend("foreman-intra coder only", "foreman-conditional replenishment");
grid on;

figure(3);

plot(avg_i_md_bitrates, avg_i_md_psnr, '-bo');
hold on;
plot(avg_c_md_bitrates, avg_c_md_psnr, '-ro');
xlabel("Bit-rates");
ylabel("PSNR");
legend("mother-daughter-intra coder only", "mother-daughter-conditional replenishment");
grid on;

%q3
[avg_m_foreman_psnr, avg_m_foreman_bitrates] = motion_compensation(foreman);

[avg_m_md_psnr, avg_m_md_bitrates] = motion_compensation(md);

figure(4);

plot(avg_i_foreman_bitrates, avg_i_foreman_psnr, '-bo');
hold on;
plot(avg_m_foreman_bitrates, avg_m_foreman_psnr, '-ro');
xlabel("Bit-rates");
ylabel("PSNR");
legend("foreman-intra coder only", "foreman-conditional replenishment with motion compensation");
grid on;

figure(5);

plot(avg_i_md_bitrates, avg_i_md_psnr, '-bo');
hold on;
plot(avg_m_md_bitrates, avg_m_md_psnr, '-ro');
xlabel("Bit-rates");
ylabel("PSNR");
legend("mother-daughter-intra coder only", "mother-daughter-conditional replenishment with motion compensation");
grid on;
