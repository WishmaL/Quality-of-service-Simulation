% function [numberOfDrops0, numberOfDrops22, numberOfDrops46] = FQ_test2(N)
function [FQ0_drops, FQ22_drops, FQ46_drops] = FQ(N)

    X = PseudoRandomGenerator(N);
   
%     create the 3 class queues 
    dscp0_Q = queue.MakeVectorOfQueues(1);
    dscp22_Q = queue.MakeVectorOfQueues(1);
    dscp46_Q = queue.MakeVectorOfQueues(1);
    
%     set each packet size of each class
    dscp0_PKT_size=6;
    dscp22_PKT_size=4;
    dscp46_PKT_size=5;
    
%    Set equal queue size for each queue
    Q_size = 12;%10
%    Set the step size for I/P 
%     HERE THE INPUT'N' MUST BE MULTIPLES OF inputRate; 
    inputRate = 10;
    
%     Initialized drop Queues dor each class to collect dropped pkts

    dscp0_dropQ = queue.MakeVectorOfQueues(1);
    dscp22_dropQ = queue.MakeVectorOfQueues(1);
    dscp46_dropQ = queue.MakeVectorOfQueues(1);
    
    k = 1;
%     Total number of dropped packets
    numberOfDrops0 = 0;
    numberOfDrops22 = 0;
    numberOfDrops46 = 0;
    
    
%     Total number of forwarded packets
    pkt_forwarded0 = 0;
    pkt_forwarded22 = 0;
    pkt_forwarded46 = 0;
    
%     Initialize the number of dropped-packets arrays(for testings/unnecessary)
    dscp0Count = 0;
    dscp22Count = 0;
    dscp46Count = 0;

%   Label each packets before go into the router  
    [dscp0, dscp22, dscp46] = getlabel(N);

%     Global accounters for get each sum
    count0 = 0;
    count22 = 0;
    count46 = 0;   
    
%     classify each pkt
    while k<length(X)
        
%         input rate
        rateIn = k+(inputRate-1);
        
        for j=k:rateIn
%             ________DSCP0________
            if dscp0>=X(j)
                dscp0Count = dscp0Count+1;
                
%       dpt is the extra number of pkts in the queue(need to be dropped)
                dpt0 = (dscp0_Q.Depth)*dscp0_PKT_size;
                if dpt0 > Q_size
                    numberOfDrops0=numberOfDrops0+1;
                    dscp0_dropQ.enqueue(X(j));
                else
%                     now the packet is in the dscp0_Q
                    dscp0_Q.enqueue(X(j));
                    count0=count0+dscp0_PKT_size;
                end
                
%              ________DSCP22________  
            elseif (dscp0<X(j)) && (dscp22>=X(j))
                dscp22Count = dscp22Count+1;
                dpt22 = (dscp22_Q.Depth)*dscp22_PKT_size;
                if dpt22 > Q_size
                    numberOfDrops22=numberOfDrops22+1;
                    dscp22_dropQ.enqueue(X(j));
                else
                    dscp22_Q.enqueue(X(j));
                    count22=count22+dscp22_PKT_size;
                end
                
%              ________DSCP46________                 
            elseif dscp22<X(j) && dscp46>=X(j)
                dscp46Count = dscp46Count+1;
                dpt46 = (dscp46_Q.Depth)*dscp46_PKT_size;
                if dpt46 > Q_size
                    numberOfDrops46=numberOfDrops46+1;
                    dscp46_dropQ.enqueue(X(j));
                else
                    dscp46_Q.enqueue(X(j));
                    count46=count46+dscp46_PKT_size;
                end
                
            end  
        end
        
        
        
 %     ___Dequeuing process___  
 
        arr_0 = (1:count0).*dscp0_PKT_size;
        arr_22 = (1:count22).*dscp22_PKT_size;
        arr_46 = (1:count46).*dscp46_PKT_size;

         i0 = 1;
         i22 = 1;
         i46 = 1;
         
         finished46 = 0;
         finished22 = 0;
         finished0 = 0;
        while dscp0_Q.Depth > 0 && dscp22_Q.Depth > 0 && dscp46_Q.Depth > 0    
            
            if i0<= length(arr_0)
                dscp0_out = arr_0(i0);
            else
                dscp0_out=Q_size;
                finished0 = 1;
            end
                
            
%             ////
            if i22<= length(arr_0)
                dscp22_out = arr_22(i22);
            else
                dscp22_out=Q_size;
                finished22 = 1;
            end
            
%             ////
            if i46 <= length(arr_0)
                dscp46_out = arr_46(i46);
            else
                dscp46_out=Q_size;
                finished46 = 1;
            end
            
            minValue = min(dscp0_out, dscp22_out);
            minValue = min(minValue, dscp46_out);
            
            if minValue == dscp46_out
                if ~finished46
                    dscp46_Q.dequeue;
                    pkt_forwarded46 = pkt_forwarded46 +1;
                end
                i46 = i46 + 1;
            end
            if minValue == dscp22_out
                if ~finished22
                    dscp22_Q.dequeue;
                    pkt_forwarded22 = pkt_forwarded22 +1;
                end
                i22 = i22 + 1;
            end
            if minValue == dscp0_out
                if ~finished0
                    dscp0_Q.dequeue;
                    pkt_forwarded0 = pkt_forwarded0 +1;
                end
                i0 = i0 + 1;
            end
            
            if dscp0_out == 12 && dscp22_out == 12 && dscp46_out == 12
                break;
            end
            
        end          
%       set the k variable to continue the flowing continuesly
        k = rateIn+1;
        
    end
    
%     fprintf('# of dscp46_dropQ: %d\n', numberOfDrops46);
%     fprintf('# of dscp22_dropQ: %d\n', numberOfDrops22);
%     fprintf('# of dscp0_dropQ: %d\n\n', numberOfDrops0);
    
    FQ0_drops = numberOfDrops0; 
    FQ22_drops = numberOfDrops22; 
    FQ46_drops = numberOfDrops46;
    
%     FQ0_drops = dscp0_dropQ.Depth; 
%     FQ22_drops = dscp22_dropQ.Depth; 
%     FQ46_drops = dscp46_dropQ.Depth;
    
%     Additional information can be found here
    
%     fprintf('pkt_forwarded count = %d\n', pkt_forwarded+pkts_in_the_queue);
    fprintf('dscp0 dropped count = %d\n', numberOfDrops0);
    fprintf('dscp22 dropped count = %d\n', numberOfDrops22);
    fprintf('dscp46 dropped count = %d\n\n', numberOfDrops46);
%     fprintf('total numberOfDrops = %d\n\n', numberOfDrops);
%     disp('---------------------------------------------------------');
end