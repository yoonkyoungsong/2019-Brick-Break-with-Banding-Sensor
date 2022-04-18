function listener_callback(src,event)

    global ypr Pitch_value flt_data_1 flt_data_3 flt_data_2 avg_data_1 avg_data_2 avg_data_3
          
    ypr = event.Data;
    Bending_1 = mean(ypr(:,1));
    Bending_2 = mean(ypr(:,2));
    Pitch_value = (mean(ypr(:,3))*2*pi/5); %Pitch value만 사용
    
    % Moving Average Filter 적용(size = 7)
    
    new_data = Bending_1;
    
    flt_data_1  = [flt_data_1(2:7) new_data];
    avg_data_1 = mean(flt_data_1);
    
    new_data = Bending_2;
   
    flt_data_2  = [flt_data_2(2:7) new_data];
    avg_data_2 = mean(flt_data_2);
    
    new_data = Pitch_value;
    flt_data_3  = [flt_data_3(2:10) new_data];
    avg_data_3 = mean(flt_data_3);
    

    
end