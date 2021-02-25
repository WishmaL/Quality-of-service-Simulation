% Assumed that the each packet(pkt) is unit packet sized

function [dscp0Drops, dscp22Drops, dscp46Drops] = FIFO(N)

    X = PseudoRandomGenerator(N);
   
%     create the main queue in FIFO
    FIFO_Q = queue.MakeVectorOfQueues(1);
    
%   Initialize drop Queue
    FIFO_dropQ = queue.MakeVectorOfQueues(1);
    
%    Set the queue size
    Q_size = 15;%10
%    Set the step size for I/P and O/p
    inputRate = 20;
%     outputRate =5;
    
    k = 1;
    actual_count = 0;
%     Total number of dropped packets
    numberOfDrops = 0;
%     Total number of forwarded packets
    pkt_forwarded = 0;
    
%     Initialize the number of dropped-packets arrays
%     dscp0Drops = 0;
%     dscp22Drops = 0;
%     dscp46Drops = 0;
    
    dscp0Count = 0;
    dscp22Count = 0;
    dscp46Count = 0;

%   Label each packets before go into the router  
    [dscp0, dscp22, dscp46] = getlabel(N);
    while k<length(X)
        
%         input rate
        rateIn = k+(inputRate-1);
%         output rate
%         rateOut = outputRate;
        
%     enqueue-loop represent one second
        for j=k:rateIn
            actual_count = actual_count+1;
            FIFO_Q.enqueue(X(j));
            
            dpt = FIFO_Q.Depth-numberOfDrops;
            if dpt > Q_size
                numberOfDrops=numberOfDrops+1;
                FIFO_dropQ.enqueue(X(j));
            else    
                FIFO_Q.enqueue(X(j));
            end
        end
  
        FIFO_Q.dequeue;
%           count the number of forwarding packets
        pkt_forwarded=pkt_forwarded+1;
       
%       set the k variable to continue the flowing continuesly
        k = rateIn+1;
        
    end

    while FIFO_dropQ.Depth>0
        y = FIFO_dropQ.dequeue;
        if dscp0>=y
            dscp0Count = dscp0Count+1;
        elseif (dscp0<y) && (dscp22>=y)
            dscp22Count = dscp22Count+1;
        elseif dscp22<y && dscp46>=y
            dscp46Count = dscp46Count+1;
        end  
    end
    dscp0Drops = dscp0Count;
    dscp22Drops= dscp22Count;
    dscp46Drops= dscp46Count;
%     Additional information can be found here
    
%     fprintf('pkt_forwarded count = %d\n', pkt_forwarded+pkts_in_the_queue);
    fprintf('dscp0 dropped count = %d\n', dscp0Count);
    fprintf('dscp22 dropped count = %d\n', dscp22Count);
    fprintf('dscp46 dropped count = %d\n\n', dscp46Count);
%     fprintf('total numberOfDrops = %d\n\n', numberOfDrops);
%     disp('---------------------------------------------------------');
end