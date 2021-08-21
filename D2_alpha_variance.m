% step 1
 clear all
 close all
 
 %将子函数文件夹，填入路径当中
 addpath('C:\Users\Lenovo\Desktop\Gran_network\Sub_functions')
 
 
 %载入数据
 datafilename = 'D2_norm_data.txt';
original_full_data = load(datafilename);

%将数据分为训练集和测试集，其中，训练集占比为ratio
training_data_ratio = 0.9;
[training_data,testing_data] = new_split_train_test(original_full_data,training_data_ratio);

%定义参数区域
alpha_value_min = 1;
alpha_value_max = 12;
alpha_value_step = 1;
Q_alpha_train = [];
Q_alpha_test = [];
cov_alpha_train=[];
cov_alpha_test = [];
sp_alpha_train=[];
sp_alpha_test=[];
beta = 2;
c_value = 4;
for alpha = alpha_value_min:alpha_value_step:alpha_value_max




% num_of_divided_steps = 50;
% [input_granules,output_granules,U ] = generate_granules(training_data,c_value,alpha,beta,num_of_divided_steps);

num_of_divided_steps = 500;
%[input_granules,output_granules,U ] = generate_granules(training_data,c_value,alpha,beta,num_of_divided_steps);
[input_granules,output_granules,U ] = g_g(training_data,c_value,alpha,beta,num_of_divided_steps);

%  Step 2-
        % Inference scheme
        % load data
        %<<<<<<<<<<<<<<<<<<<<<<<train>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        %这一部分用来测试training data
        check_data =  training_data;
        N_check = length(check_data);
        Y_output = zeros(N_check,2);
        
        for k=1:1:N_check
            %step 1 取出该点，检查是否落在了形成的X空间内某一集合内部
            current_point = check_data(k,1:end-1);
            for i=1:1:c_value
                current_c = input_granules(i,1:end-1);
                flag_in = 0;
                if(norm(current_c - current_point)<= input_granules(i,end))
                    flag_in = 1;
                    record_c = i;
                    break
                else
                    continue
                end
            end
            %基于上面的判断，根绝flag是否为0，判断输出Y值，在里面，则直接出，不在，则，进行模糊计算
            if(flag_in==1)
                Y_output(k,:) = output_granules(record_c,:);
            else
                %进行模糊计算
                %计算该点到每一个中心点的距离
                for i=1:1:c_value
                    temp_distance_x_c(i,1) = 1/power(norm(current_point - input_granules(i,1:end-1)),2 );
                end
                %计算模糊关系
                for i=1:1:c_value
                    temp_u_x_c(i,1) = temp_distance_x_c(i,1)/sum(temp_distance_x_c);
                end
                %temp_u_x_c = U(:,k);
                Y_c = temp_u_x_c'*output_granules(:,1:end-1);
                Y_radius = temp_u_x_c'*output_granules(:,end);
                Y_output(k,:) = [Y_c,Y_radius];
            end
        end
        
       %下面开始计算Q值
       New_cov = 0;
       New_sp = 0;
       
       for k=1:1:N_check
           if (abs(check_data(k,end) -Y_output(k,1))<= Y_output(k,2) )
              New_cov = New_cov +1;
              New_sp = New_sp + max(0,1- Y_output(k,2) );
           else
               continue
           end
       end
       New_cov/N_check;
       New_sp/N_check;
      N_Q = (New_cov/N_check)*(New_sp/N_check)             
       Q_alpha_train = [Q_alpha_train;N_Q];
     cov_alpha_train = [cov_alpha_train;New_cov/N_check];
      sp_alpha_train = [sp_alpha_train;New_sp/N_check];
      %  Step 2-
        % Inference scheme
        % load data
        %<<<<<<<<<<<<<<<<<<<<<<<train>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        %这一部分用来测试training data
        check_data =  testing_data;
        N_check = length(check_data);
        Y_output = zeros(N_check,2);
        
        for k=1:1:N_check
            %step 1 取出该点，检查是否落在了形成的X空间内某一集合内部
            current_point = check_data(k,1:end-1);
            for i=1:1:c_value
                current_c = input_granules(i,1:end-1);
                flag_in = 0;
                if(norm(current_c - current_point)<= input_granules(i,end))
                    flag_in = 1;
                    record_c = i;
                    break
                else
                    continue
                end
            end
            %基于上面的判断，根绝flag是否为0，判断输出Y值，在里面，则直接出，不在，则，进行模糊计算
            if(flag_in==1)
                Y_output(k,:) = output_granules(record_c,:);
            else
                %进行模糊计算
                %计算该点到每一个中心点的距离
                for i=1:1:c_value
                    temp_distance_x_c(i,1) = 1/power(norm(current_point - input_granules(i,1:end-1)),2 );
                end
                %计算模糊关系
                for i=1:1:c_value
                    temp_u_x_c(i,1) = temp_distance_x_c(i,1)/sum(temp_distance_x_c);
                end
                %temp_u_x_c = U(:,k);
                Y_c = temp_u_x_c'*output_granules(:,1:end-1);
                Y_radius = temp_u_x_c'*output_granules(:,end);
                Y_output(k,:) = [Y_c,Y_radius];
            end
        end
        
       %下面开始计算Q值
       New_cov = 0;
       New_sp = 0;
       
       for k=1:1:N_check
           if (abs(check_data(k,end) -Y_output(k,1))<= Y_output(k,2) )
              New_cov = New_cov +1;
              New_sp = New_sp + max(0,1- Y_output(k,2) );
           else
               continue
           end
       end
       New_cov/N_check;
       New_sp/N_check;
      N_Q = (New_cov/N_check)*(New_sp/N_check)             
      Q_alpha_test = [Q_alpha_test;N_Q];
      cov_alpha_test = [cov_alpha_test;New_cov/N_check];
      sp_alpha_test = [sp_alpha_test;New_sp/N_check];
end

    x_number = (alpha_value_max -alpha_value_min)/alpha_value_step +1;
    x = linspace(alpha_value_min,alpha_value_max,x_number)';%注意这里的行列变换
        %记录关于cov-c
cov_train_test = [x,cov_alpha_train,cov_alpha_test];
save('D2_alpha_vs_cov_train_test.txt','cov_train_test','-ascii');
%记录关于sp-c
sp_train_test = [x,sp_alpha_train,sp_alpha_test];
save('D2_alpha_vs_sp_train_test.txt','sp_train_test','-ascii');
    %记录 Q-c
 Q_train_test = [x,Q_alpha_train,Q_alpha_test];
save('D2_alpha_vs_Q_train_test.txt','Q_train_test','-ascii');  

    figure
    set (gcf,'Position',[400,400,400,400], 'color','w');
    plot(x,Q_alpha_train,'k-',x,Q_alpha_test,'k--','LineWidth',2)
    xlabel('\it \alpha','FontName','Times New Roman');
    ylabel('\it Q','FontName','Times New Roman');
    legend('\it Q_{\rm train}','\it Q_{\rm test}');
    set (gcf,'Position',[400,240,400,240], 'color','w');
    xlim([alpha_value_min alpha_value_max])
    %axis tight