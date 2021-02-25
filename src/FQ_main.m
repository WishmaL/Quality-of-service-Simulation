function FQ_main
%     Packets rates
    total_PKTs = [100,200,300,400,500,600,700,800,900,1000];
    
%    __FAIR QUEUE__ 

    dscp0_FQ = zeros(10,1);
    dscp22_FQ = zeros(10,1);
    dscp46_FQ = zeros(10,1);
    
    for r=1:length(total_PKTs)
        [dscp0_FQ(r,1),dscp22_FQ(r,1),dscp46_FQ(r,1)] = FQ(total_PKTs(r));
    end
    
%     Linear plot
    figure(3)
    hold on
    plot(total_PKTs,dscp0_FQ, 'r');
    plot(total_PKTs,dscp22_FQ, 'g');
    plot(total_PKTs,dscp46_FQ, 'k');
    title('FQ Scheduling <I>');
    xlabel('Packet input rate');
    ylabel('Number of packets dropped');
    legend('DSCP0','DSCP22','DSCP46');
    hold off;
    
    %   Calculate the accumilative values
    cumulative_FQ_dscp0 = cumsum(dscp0_FQ);
    cumulative_FQ_dscp22 = cumsum(dscp22_FQ);
    cumulative_FQ_dscp46 = cumsum(dscp46_FQ);

    %     cummilative plot
    
    figure(4)
    hold on;
    plot(total_PKTs,cumulative_FQ_dscp0, 'g');
    plot(total_PKTs,cumulative_FQ_dscp22, 'r');
    plot(total_PKTs,cumulative_FQ_dscp46, 'k');
    title('FQ Scheduling <II>');
    xlabel('Packet input rate');
    ylabel('Number of packets dropped (cumulative values)');
    legend('DSCP0','DSCP22','DSCP46');
    hold off;

end