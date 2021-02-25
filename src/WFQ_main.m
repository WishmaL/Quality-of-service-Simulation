function WFQ_main
%     Packets rates
    total_PKTs = [100,200,300,400,500,600,700,800,900,1000];
    
%     Initialize each class to be plotted
    dscp0_WFQ = zeros(10,1);
    dscp22_WFQ = zeros(10,1);
    dscp46_WFQ = zeros(10,1);


    for r=1:length(total_PKTs)
        [dscp0_WFQ(r,1),dscp22_WFQ(r,1),dscp46_WFQ(r,1)] = WFQ(total_PKTs(r));
    end
    
%     Linear plot    
    figure(5);
    hold on;
    plot(total_PKTs,dscp0_WFQ, 'r');
    plot(total_PKTs,dscp22_WFQ, 'g');
    plot(total_PKTs,dscp46_WFQ, 'k');
    title('WFQ Scheduling <I>');
    xlabel('Packet input rate');
    ylabel('Number of packets dropped');
    legend('DSCP0','DSCP22','DSCP46');
    hold off;
    
    %   Calculate the accumilative values
    cumulative_WFQ_dscp0 = cumsum(dscp0_WFQ);
    cumulative_WFQ_dscp22 = cumsum(dscp22_WFQ);
    cumulative_WFQ_dscp46 = cumsum(dscp46_WFQ);

    %     cummilative plot
    figure(6);
    hold on;
    plot(total_PKTs,cumulative_WFQ_dscp0, 'g');
    plot(total_PKTs,cumulative_WFQ_dscp22, 'r');
    plot(total_PKTs,cumulative_WFQ_dscp46, 'k');
    title('WFQ Scheduling <II>');
    xlabel('Packet input rate');
    ylabel('Number of packets dropped (cumulative values)');
    legend('DSCP0','DSCP22','DSCP46');
    hold off;
end