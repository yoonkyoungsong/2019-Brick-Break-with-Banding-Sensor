function deg_filt=MovingAvgFilter2(deg,n)
    persistent k data_buff
    
     if isempty(k)
        k = 1;
     end
     
    if isempty(data_buff)
        data_buff = [0 0 0 0 0];
    end
    
     for i=1:n-1
                data_buff(i)=data_buff(i+1);
     end
     
     data_buff(n)=deg;
    
    if k>=n
        deg_filt=mean(data_buff);
    else
        deg_filt=deg;
    end

    k=k+1;
end