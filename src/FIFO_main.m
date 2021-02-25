function FIFO_main
%     Packets rates
    total_PKTs = [100,200,300,400,500,600,700,800,900,1000];
    
    
%     Initialize each class to be plotted
    dscp0_FIFO = zeros(10,1);
    dscp22_FIFO = zeros(10,1);
    dscp46_FIFO = zeros(10,1);
    
%     Get dropped values for each class in each rates
    for r=1:length(total_PKTs)
        [dscp0_FIFO(r,1),dscp22_FIFO(r,1),dscp46_FIFO(r,1)] = FIFO(total_PKTs(r));
    end
    
    figure(1)
%     Linear plot
    
    hold on
    plot(total_PKTs,dscp0_FIFO, 'r');
    plot(total_PKTs,dscp22_FIFO, 'g');
    plot(total_PKTs,dscp46_FIFO, 'k');
    title('FIFO Scheduling <I>');
    xlabel('Packet input rate');
    ylabel('Number of packets dropped');
    legend('DSCP0','DSCP22','DSCP46');
    hold off;
 
%   Calculate the accumilative values
    cumulative_FIFO_dscp0 = cumsum(dscp0_FIFO);
    cumulative_FIFO_dscp22 = cumsum(dscp22_FIFO);
    cumulative_FIFO_dscp46 = cumsum(dscp46_FIFO);

%     cummilative plot
    figure(2)
    hold on;
    plot(total_PKTs,cumulative_FIFO_dscp0, 'g');
    plot(total_PKTs,cumulative_FIFO_dscp22, 'r');
    plot(total_PKTs,cumulative_FIFO_dscp46, 'k');
    title('FIFO Scheduling <II>');
    xlabel('Packet input rate');
    ylabel('Number of packets dropped (cumulative values)');
    legend('DSCP0','DSCP22','DSCP46');
    hold off;
    
end