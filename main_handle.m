%2020.05.05. ���´������ݣ�������Q = sp * cov

%���������������ֹ��ɵ�
%1. ������Ϣ��
%2. ͨ��reference scheme�� ��������δ֪�������ƶϡ�

% step 1
 clear all
 close all
 
 %���Ӻ����ļ��У�����·������
 addpath('D:\Matlab_my_additional_path')
 
 
 %��������
 datafilename = 'D2_norm_data.txt';
original_full_data = load(datafilename);

%�����ݷ�Ϊѵ�����Ͳ��Լ������У�ѵ����ռ��Ϊratio
training_data_ratio = 0.6;
[training_data,testing_data] = new_split_train_test(original_full_data,training_data_ratio);

%�����������
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
        %��һ������������training data
        check_data =  training_data;
        N_check = length(check_data);
        Y_output = zeros(N_check,2);
        
        for k=1:1:N_check
            %step 1 ȡ���õ㣬����Ƿ��������γɵ�X�ռ���ĳһ�����ڲ�
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
            %����������жϣ�����flag�Ƿ�Ϊ0���ж����Yֵ�������棬��ֱ�ӳ������ڣ��򣬽���ģ������
            if(flag_in==1)
                Y_output(k,:) = output_granules(record_c,:);
            else
                %����ģ������
                %����õ㵽ÿһ�����ĵ�ľ���
                for i=1:1:c_value
                    temp_distance_x_c(i,1) = 1/power(norm(current_point - input_granules(i,1:end-1)),2 );
                end
                %����ģ����ϵ
                for i=1:1:c_value
                    temp_u_x_c(i,1) = temp_distance_x_c(i,1)/sum(temp_distance_x_c);
                end
                %temp_u_x_c = U(:,k);
                Y_c = temp_u_x_c'*output_granules(:,1:end-1);
                Y_radius = temp_u_x_c'*output_granules(:,end);
                Y_output(k,:) = [Y_c,Y_radius];
            end
        end
        
       %���濪ʼ����Qֵ
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