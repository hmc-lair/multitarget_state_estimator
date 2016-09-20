% Plot 3d bar graph of muhat_list_x90
% Can be changed for muhat_list_d90

bar3(seg_list,muhat_list_x90)
set(gca,'XTickLabel',seg_list)
set(gca,'XTickLabel',numshark_list)
xlabel('Segment Length (m)')
ylabel('Number of Sharks')
zlabel('\rho_{90} (m)')
title('\rho_{90} (n,L)')
ylabel('Segment Length (m)')
xlabel('Number of Sharks')
zlabel('\psi_{90} (m)')
title('\psi_{90} (n,L)')