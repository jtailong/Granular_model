%% 这一部分画每一个粒的半径进化记录过程

% step 1
 clear all
 close all
 
 %将子函数文件夹，填入路径当中
 addpath('D:\Matlab_my_additional_path')
 addpath('D:\Endeavor\Paper_list\Gran_network\Sub_functions')
 
 %载入数据
 datafilename = 'D2_norm_data.txt';
original_full_data = load(datafilename);

%将数据分为训练集和测试集，其中，训练集占比为ratio
training_data_ratio = 0.6;
[training_data,testing_data] = new_split_train_test(original_full_data,training_data_ratio);
%定义参数区域
c_value = 16;
alpha = 6;
beta = 20;
num_of_divided_steps = 400;
%[input_granules,output_granules,U ] = generate_granules(training_data,c_value,alpha,beta,num_of_divided_steps);
 [input_granules,output_granules,U,V_rho ] = g_g_add_V_rho(training_data,c_value,alpha,beta,num_of_divided_steps);
 [m,n] = size(V_rho);
figure
for i =1:1:4
    x_rho = linspace(0,1,n);
    plot(x_rho,V_rho(i,:),'LineWidth',1.0)
    hold on
end
xlabel('$\rho$','FontName','Times New Roman','FontSize',12,'Interpreter','latex')  
ylabel('$V$','FontName','Times New Roman','FontSize',12,'Interpreter','latex')
set (gcf,'Position',[400,180,400,180], 'color','w')
set(gca,'FontName','Times New Roman');
set(gca,'fontsize',6,'fontname','Times');%'linewidth',1.0,
axis tight
%grid on
axis([0,1,-inf,inf])
legend('$A_{1}$','$A_{2}$','$A_{3}$','$A_{4}$','FontName','Times New Roman','FontSize',10,'Interpreter','latex')
set(gca,'LooseInset',get(gca,'TightInset'))
%% 这一部分开始画图
%注意，要先运行main_handle.m
figure
        for i=1:1:c_value
        xo = input_granules(i,1);
        yo = input_granules(i,2);
        r = input_granules(i,3);
        my_plot_circle(xo,yo,r);
        end
set (gcf,'Position',[400,400,400,400], 'color','w');
set(gca,'linewidth',1.0,'fontsize',14,'fontname','Times');
xlabel('$x_{\rm1}$','FontName','Times New Roman','FontSize',18,'Interpreter','latex');
ylabel('$x_{\rm2}$','FontName','Times New Roman','FontSize',18,'Interpreter','latex'); 
set(gca,'LooseInset')
%axis tight

figure1 = figure('Color',[1 1 1]);

    axes1 = axes('Parent',figure1,'PlotBoxAspectRatio',[1 1 1],...
    'FontName','Times New Roman');
    view(axes1,[22 32]);
    %axis([0 1 0 1 0 1]);
    axis square;
    grid on;
    for i=1:1:c_value
        x0 = input_granules(i, 1);
        y0 = input_granules(i, 2);
        radius = input_granules(i, end);
        z0 = output_granules(i, 1);
        height = output_granules(i, end) * 2;
        my_plot_cylinder(x0, y0, z0, radius, height);
    end;
%     for i=1:1:N_check
%         hold on; plot3(training_data(i,1), training_data(i,2),training_data(i,3), 'k.', 'Markersize', 6);
%     end;

    xlabel('$x\rm_{1}$','FontName','Times New Roman','FontSize',18,'Interpreter','latex');
    ylabel('$x\rm_{2}$','FontName','Times New Roman','FontSize',18,'Interpreter','latex');
    zlabel('$y$','FontName','Times New Roman','FontSize',18,'Interpreter','latex');
    set (gcf,'Position',[400,400,400,400], 'color','w')
    set(gca,'FontName','Times New Roman','linewidth',1.0,'fontsize',14);
    set(gca,'LooseInset',get(gca,'TightInset'))
 %% 这一部分画 关于D2中，c, alpha ,beta 对于Q值的影响
 %关于c 与Q
 datafilename_c_Q = 'D2_c_vs_Q_train_test.txt';
c_Q =  load(datafilename_c_Q);
     figure
set (gcf,'Position',[400,400,400,400], 'color','w');
set(gca,'FontName','Times New Roman','linewidth',1.0,'fontsize',15);
    plot(c_Q(:,1),c_Q(:,2),'k-',c_Q(:,1),c_Q(:,3),'k--','LineWidth',2)
    xlabel('\it c','FontName','Times New Roman','FontSize',18);
    ylabel('\it Q','FontName','Times New Roman','FontSize',18);
    %legend('\itQ_{train}','\itQ_{test}','FontSize',15);
    set (gcf,'Position',[400,240,400,240], 'color','w');
    %xlim([c_value_min c_value_max])
    set(gca,'LooseInset',get(gca,'TightInset'))%只要这一个命令就可以了
    legend('\itQ_{\rmtr}','\itQ_{\rmte}','FontName','Times New Roman','FontSize',15)
    axis tight
    
 % alpha与Q
datafilename_alpha_Q = 'D2_alpha_vs_Q_train_test.txt';
alpha_Q =  load(datafilename_alpha_Q);
     figure
set(gca,'FontName','Times New Roman','linewidth',1.0,'fontsize',14);
    plot(alpha_Q(:,1),alpha_Q(:,2),'k-',alpha_Q(:,1),alpha_Q(:,3),'k--','LineWidth',2)
    xlabel('\it\alpha','FontName','Times New Roman','FontSize',18);
    ylabel('\itQ','FontName','Times New Roman','FontSize',18);
    %legend('\itQ_{train}','\itQ_{test}','FontSize',15);
    set (gcf,'Position',[400,280,400,280], 'color','w');
    set(gca,'LooseInset',get(gca,'TightInset'))%只要这一个命令就可以了
    %xlim([c_value_min c_value_max])
    legend('\itQ_{\rmtr}','\itQ_{\rmte}','FontName','Times New Roman','FontSize',15)
    axis tight
    
 %beta与Q
datafilename_beta_Q = 'D2_beta_vs_Q_train_test.txt';
beta_Q =  load(datafilename_beta_Q);
     figure
set(gca,'FontName','Times New Roman','linewidth',1.0,'fontsize',14);
    plot(beta_Q(:,1),beta_Q(:,2),'k-',beta_Q(:,1),beta_Q(:,3),'k--','LineWidth',2)
    xlabel('\beta','FontName','Times New Roman','FontSize',18);
    ylabel('\it Q','FontName','Times New Roman','FontSize',18);
    %legend('\itQ_{train}','\itQ_{test}','FontSize',15);
    set (gcf,'Position',[400,280,400,280], 'color','w');
    set(gca,'LooseInset',get(gca,'TightInset'))%只要这一个命令就可以了
    legend('\itQ_{\rmtr}','\itQ_{\rmte}','FontName','Times New Roman','FontSize',15)
    %xlim([c_value_min c_value_max])
    axis tight  
%% 下面画重构图
    %上一步生成的one_one_in_output_granules 对应traning_data 元数据
%这一步，利用one_one_in_output 画出 误差棒状图

%--- training part
original_data = load('check_data.txt');
Y = load('Y_output.txt');
num_pionts = 50;
num_list = randperm(size(Y,1),num_pionts)

check_data = [];
Y_output = [];
for i=1:num_pionts
    check_data = [check_data;original_data(i,:)];
    Y_output = [Y_output;Y(i,:)];
end

figure
% x = one_one_in_output_granules(:,1);
% y=one_one_in_output_granules(:,1);
% variance = one_one_in_output_granules(:,2);
% errorbar(x,y,variance,'.')

plot(check_data(:,end),check_data(:,end),'LineWidth',1.5); %画出target值
hold on
errorbar(check_data(:,end),Y_output(:,1),Y_output(:,2),'.');
%errorbar(one_one_in_output_granules(:,1),one_one_in_output_granules(:,1),one_one_in_output_granules(:,2),'.'); %画出 granule model值
set(gca,'xtick',[0  0.5 1.0]);set(gca,'ytick',[0 0.5 1.0 ]);
set(gca,'FontName','Times New Roman','linewidth',1.0,'fontsize',15);
set (gcf,'Position',[400,400,400,400], 'color','w')
xlabel(' target output','FontName','Times New Roman','FontSize',15);
ylabel(' granule model output','FontName','Times New Roman','FontSize',15); 
box off

%画三维重构图
figure
X1 =check_data(:,1);
Y1 = check_data(:,2);
Z1 = check_data(:,3);
Z0 = Y_output(:,1)-Y_output(:,2);%信息粒下面
Z2 = Y_output(:,1)+Y_output(:,2);%对应信息粒上面

[X_grid,Y_grid,Z1_grid]=griddata(X1,Y1,Z1',linspace(min(X1),max(Y1))',linspace(min(Y1),max(Y1)),'v4');
[X_grid,Y_grid,Z0_grid]=griddata(X1,Y1,Z0',linspace(min(X1),max(Y1))',linspace(min(Y1),max(Y1)),'v4');
[X_grid,Y_grid,Z2_grid]=griddata(X1,Y1,Z2',linspace(min(X1),max(Y1))',linspace(min(Y1),max(Y1)),'v4');
%figure,mesh(X_grid,Y_grid,Z_grid)%三维曲面
%colormap hsv
%hold on
mesh(X_grid,Y_grid,Z0_grid,'FaceAlpha',1)%三维曲面
%colormap gray
hold on
mesh(X_grid,Y_grid,Z2_grid,'FaceAlpha',1)%三维曲面
%colormap pink
hold on
plot3(X1,Y1,Z1,'r.','MarkerSize',6)
set(gca,'FontName','Times New Roman','linewidth',1.0,'fontsize',15);
%自定义坐标轴等区域
xlabel('\itx\rm_{1}','FontName','Times New Roman','FontSize',15);
ylabel('\itx\rm_{2}','FontName','Times New Roman','FontSize',15);
zlabel('\it y','FontName','Times New Roman','FontSize',15);
grid on
box off;ax = gca;ax.BoxStyle = 'full';
%set(gca,'xtick',[-0.5 0  0.5 1]);set(gca,'ytick',[-1 -0.5 0 0.5 1.2]);set(gca,'ztick',[-0.2 -0.1 0 0.1 0.2]);
set (gcf,'Position',[400,400,400,400], 'color','w')




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%这一部分用来画 cov-sp的图，分开画training部分和testing部分
% 数据加载
%cov 
datafilename_cov_c = 'D2_c_vs_cov_train_test.txt';
datafilename_cov_c_TS0 = 'D2_c_vs_cov_train_test_TS0.txt';
datafilename_cov_c_TS1 = 'D2_c_vs_cov_train_test_TS1.txt';

cov =  load(datafilename_cov_c);
cov_TS0 =  load(datafilename_cov_c_TS0);
cov_TS1 =  load(datafilename_cov_c_TS1);
%sp
datafilename_sp_c = 'D2_c_vs_sp_train_test.txt';
datafilename_sp_c_TS0 = 'D2_c_vs_sp_train_test_TS0.txt';
datafilename_sp_c_TS1 = 'D2_c_vs_sp_train_test_TS1.txt';

sp =  load(datafilename_sp_c);
sp_TS0 =  load(datafilename_sp_c_TS0);
sp_TS1 =  load(datafilename_sp_c_TS1);

%画图 training 部分 cov-sp
    figure
    set (gcf,'Position',[400,400,400,400], 'color','w');
   % plot(cov(:,2),sp(:,2),cov_TS0(:,2),sp_TS0(:,2),cov_TS1(:,2),sp_TS1(:,2))
   plot(cov(:,2),sp(:,2),'o-',cov_TS0(:,2),sp_TS0(:,2),'v-',cov_TS1(:,2),sp_TS1(:,2),'*-')
   legend('Granular model','TS 0 model','TS 1 model')
    xlabel('cov','FontName','Times New Roman');
    ylabel('sp','FontName','Times New Roman');
    grid on

   
%画图 testing 部分 cov-sp
    %画图 training 部分 cov-sp
    figure
    set (gcf,'Position',[400,400,400,400], 'color','w');
   % plot(cov(:,2),sp(:,2),cov_TS0(:,2),sp_TS0(:,2),cov_TS1(:,2),sp_TS1(:,2))
   plot(cov(:,3),sp(:,3),'o-',cov_TS0(:,3),sp_TS0(:,3),'v-',cov_TS1(:,3),sp_TS1(:,3),'*-')
   legend('Granular model','TS 0 model','TS 1 model')
    xlabel('cov','FontName','Times New Roman');
    ylabel('sp','FontName','Times New Roman');
    grid on
    
    


    

