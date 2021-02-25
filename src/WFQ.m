% function [numberOfDrops0, numberOfDrops22, numberOfDrops46] = FQ_test2(N)
function [WFQ0_drops, WFQ22_drops, WFQ46_drops] = WFQ(N)

    X = PseudoRandomGenerator(N);
   
%     create the 3 class queues 
    dscp0_Q = queue.MakeVectorOfQueues(1);
    dscp22_Q = queue.MakeVectorOfQueues(1);
    dscp46_Q = queue.MakeVectorOfQueues(1);
    
%     set packet sizes for each pkt
    PKT_size0=6;
    PKT_size22=4;
    PKT_size46=5;
    
%    Set equal queue size for each queue
    Q_size = 12;%10
%    Set the step size for I/P and O/p
    

%     HERE THE INPUT'N' MUST BE MULTIPLES OF inputRate; 
    inputRate = 10;
    
%     weights
    weight0 = 1;
    weight22 = 2;
    weight46 = 6;
    
%     Initialized drop Queues dor each class to _ 
%     _collect dropped pkts
    dscp0_dropQ = queue.MakeVectorOfQueues(1);
    dscp22_dropQ = queue.MakeVectorOfQueues(1);
    dscp46_dropQ = queue.MakeVectorOfQueues(1);
    
    k = 1;
%     actual_count = 0;
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
%         output rate
%         rateOut = outputRate;
        
        for j=k:rateIn
           
%             ________DSCP0________
            if dscp0>=X(j)
                dscp0Count = dscp0Count+1;
                
                dpt0 = (dscp0_Q.Depth)*PKT_size0;
                if dpt0 > Q_size
                    numberOfDrops0=numberOfDrops0+1;
                    dscp0_dropQ.enqueue(X(j));
                else
%                     now the packet is in the dscp0_Q
                    dscp0_Q.enqueue(X(j));
%                     dscp0_Q_PKTSizes.enqueue(PKT_sizes(j));
                    count0=count0+1;
                end
%              ________DSCP22________  
            elseif (dscp0<X(j)) && (dscp22>=X(j))
                dscp22Count = dscp22Count+1;
                dpt22 = (dscp22_Q.Depth)*PKT_size22;
                if dpt22 > Q_size
                    numberOfDrops22=numberOfDrops22+1;
                    dscp22_dropQ.enqueue(X(j));
                else
%                     now the packet is in the dscp22_Q
                    dscp22_Q.enqueue(X(j));
%                     dscp22_Q_PKTSizes.enqueue(PKT_sizes(j));
                    count22=count22+1;
                end
%              ________DSCP46________                 
            elseif dscp22<X(j) && dscp46>=X(j)
                dscp46Count = dscp46Count+1;
                dpt46 = (dscp46_Q.Depth)*PKT_size46;
                if dpt46 > Q_size
                    numberOfDrops46=numberOfDrops46+1;
                    dscp46_dropQ.enqueue(X(j));
                else
%                     now the packet is in the dscp46_Q
                    dscp46_Q.enqueue(X(j));
%                     dscp46_Q_PKTSizes.enqueue(PKT_sizes(j));
                    count46=count46+1;
                end
            end 
        end
      
        arr_0 = (1:count0).*(PKT_size0/weight0);
        arr_22 = (1:count22).*(PKT_size22/weight22);
        arr_46 = (1:count46).*(PKT_size46/weight46);
       
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
            
%             arr size =0, there will be a prolm, fixit
            
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
        k = rateIn+1;
        
    end
    
    fprintf('# of dscp0_dropQ: %d\n', dscp0_dropQ.Depth);
    fprintf('# of dscp22_dropQ: %d\n', dscp22_dropQ.Depth);
    fprintf('# of dscp46_dropQ: %d\n\n', dscp46_dropQ.Depth);
    
    WFQ0_drops = dscp0_dropQ.Depth; 
    WFQ22_drops = dscp22_dropQ.Depth; 
    WFQ46_drops = dscp46_dropQ.Depth;

end