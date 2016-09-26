% Plot 3d bar graph of muhat_list_x90
% Can be changed for muhat_list_d90
clf
subplot(1,2,1)
bar3(seg_list,muhat_list_d90_round)
set(gca,'XTickLabel',numshark_list)
title('\rho_{90} (n,L)')
xlabel('Number of Sharks')
ylabel('Segment Length (m)')
zlabel('\rho_{90} (m)')
ylim([39 61])
zlim([1.5 3])

subplot(1,2,2)
bar3(seg_list,muhat_list_x90_round)
set(gca,'XTickLabel',seg_list)
set(gca,'XTickLabel',numshark_list)
xlabel('Number of Sharks')
ylabel('Segment Length (m)')
zlabel('\psi_{90} (m)')
title('\psi_{90} (n,L)')
ylim([39 61])
zlim([15 20])

