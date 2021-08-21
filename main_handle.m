%2020.05.05. 重新处理数据，并计算Q = sp * cov

%整个过程是两部分构成的
%1. 构建信息粒
%2. 通过reference scheme， 来对所有未知数进行推断。

% step 1
 clear all
 close all
 
 %将子函数文件夹，填入路径当中
 addpath('D:\Matlab_my_additional_path')
 
 
 %载入数据
 datafilename = 'D2_norm_data.txt';
original_full_data = load(datafilename);

%将数据分为训练集和测试集，其中，训练集占比为ratio
training_data_ratio = 0.6;
[training_data,testing_data] = new_split_train_test(original_full_data,training_data_ratio);

%定义参数区域
c_value = 4;
alpha = 6;
beta = 2;
num_of_divided_steps = 400;
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
       New_cov/N_check
       New_sp/N_check
      N_Q = (New_cov/N_check)*(New_sp/N_check)             
      % Q_c_train = [Q_c_train;N_Q];
      
%       figure
%         for i=1:1:c_value
%         xo = input_granules(i,1);
%         yo = input_granules(i,2);
%         r = input_granules(i,3);
%         my_plot_circle(xo,yo,r);
%         end
% set (gcf,'Position',[400,400,400,400], 'color','w');
% xlabel('\itx_{1}','FontName','Times New Roman');
% ylabel('\itx_{2}','FontName','Times New Roman'); 