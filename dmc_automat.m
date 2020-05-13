function [Y, U, yzad] = dmc_automat(sim_time)
    
    clearvars -except sim_time
    initSerialControl COM3
    object = HeatingCooling(); % walk into lab
    Y = [];
    U = [];
    k = 0;
    controls = [0, 0];
    k = 1;
    ny=2;
    nu=2;
    yzad=[0 0];
    Upp=[30 35];
    Ypp=[120 130];
    u_max=100-Upp;
    u_min=0-Upp;
    
    load('rw_odp_skok_aproks.mat', 'GT_aproksym')
    
    D=100; N=50; Nu=50; lambda=20;
    
    
    S=cell(N+D-1,1);
    for i=1:N+D-1
        S{i}=[GT_aproksym(i,1),   GT_aproksym(i,3);...
              GT_aproksym(i,2),   GT_aproksym(i,4)];
    end
    
    Mcell=cell(N, Nu);
    for i=1:N
        for j=1:Nu
            Mcell{i,j}=zeros(2,2);
        end
    end
    i=0;
    for j=1:Nu  %wypelnianie macierzy trojkatnej dolnej M
       Mcell(j:N,j)=S(1:N-i);  
       i=i+1;
    end
    M=cell2mat(Mcell);
    
    
    Mpcell=cell(N,(D-1));     
    for j=1:N %wypelnianie macierzy Mp
       for i=1:D-1
           Mpcell{j, i}=cell2mat(S(j+i))-cell2mat(S(i));    
       end
    end
    Mp=cell2mat(Mpcell);
    
    psi=1;
    bigPsi=eye(N*ny,N*ny)*psi;
    
    bigLambda=eye(Nu*nu,Nu*nu)*lambda;
    Yzad=zeros(N*ny,1);
    Y_ptak=zeros(N*ny,1);
    deltaU=zeros(Nu*nu,1);
    deltaUP=zeros((D-1)*nu,1);
    K=inv(M'*bigPsi*M+bigLambda)*M'*bigPsi;
    K1=K(1:nu,:);
    while(k < sim_time)
        %% obtaining measurements
        measurements = object.getMeasurementsSim(); % read measurements 1 and 3
        
        noise = normrnd(0, 1, [size(measurements), 1]);
        measurements = measurements + noise;
        
        measurements = measurements';
        
%         %% processing of the measurements and new control values calculation
         disp(measurements); % process measurements
%         
%         %% sending new values of control signals
        if (k == 1)
            controls = [30, 35];
        end
        if(    k <  110)
            if k>0
                yzad(k,:)=[35 60];
            end
        elseif(k <  150)
                yzad(k,:)=[35 60];
        elseif(k < 200)
                yzad(k,:)=[25 60];
        elseif(k < 250)
            yzad(k,:)=[50 20];
        elseif(k < 300)
            yzad(k,:)=[50 40];
        elseif(k < 350)
            yzad(k,:)=[30 60];
        else
            yzad(k,:)=[50 60];
        end
        
        
        
        Y = [Y; measurements]; 
        
        yzad_wykres(k,:)=yzad(k,:);
        yzad(k,:)=yzad(k,:)-Ypp; 
        y=Y(k,:)-Ypp;
        %y_zapisz(k,:)=y;
        %e=yzad(k,:)-y(k,:);
        Yzad=repmat(yzad(k,:)',N, 1);
        Y_wek=repmat(y',N,1);
        
        if k>2
            deltaUP(3:nu*(D-1), 1)=deltaUP(1:nu*(D-1)-nu, 1);
            deltaUP(1:2,1) = u(k-1,:)'-u(k-2,:)';
        elseif k==2
            deltaUP(1:2,1)=u(k-1,:)';
        end
%         for i=1:(D-1)*nu
%             if k-(i+1)>0
%                 deltaUP(i:i+1,1)=u(k-i)'-u(k-(i+1))';
%             end
%         end
        Y0=Y_wek+Mp*deltaUP;
        deltaU=K*(Yzad-Y0);
        deltaY=M*deltaU;
        
        Y_ptak=Y0+deltaY;
        
        delta_u=K1*(Yzad-Y_wek-Mp*deltaUP);
        
        if k<2
            u(k,:)=delta_u';
        else
            u(k,:)=u(k-1,:)+delta_u';
        end
        
        if u(k,1)>u_max(1,1)
            u(k,1)=u_max(1,1);
        elseif u(k,1)<u_min(1,1)
            u(k,1)=u_min(1,1);
        end
        
        if u(k,2)>u_max(1,2)
            u(k,2)=u_max(1,2);
        elseif u(k,2)<u_min(1,2)
            u(k,2)=u_min(1,2);
        end
        
        u_wek(k,:)=u(k,:);
        controls=u(k,:)+Upp;
        %yzad(k,:)=yzad(k,:)+Ypp;
%         if k<500
%            controls=Upp; 
%         end
        sendControls([5,6]    ,... send for these elements
                     controls);  % new corresponding control values
%         subplot(2,1,1); 
%         h=plot(Y); hold on; legend('Location','northwest'); stairs(yzad(:,1), '--','DisplayName', 'yzad1');
%         stairs(yzad(:,2), '--','DisplayName', 'yzad2'); hold off;  drawnow
         U = [U; controls];%     subplot(2,1,2); stairs(U); ylim([-5,105]); drawnow
        
        
        k = k+1;
        
        
        
        object.setControlsSim(controls');  % new corresponding control values
        
        
          
        
        %% synchronising with the control process
        object.nextStepSim();
        object.refresh();
    end
        figure
         subplot(2,1,1); 
         h=plot(Y); hold on; legend('Location','northwest'); stairs(yzad_wykres(:,1), '--','DisplayName', 'yzad1');
         stairs(yzad_wykres(:,2), '--','DisplayName', 'yzad2'); hold off;  drawnow
         subplot(2,1,2); stairs(U); ylim([-5,105]); drawnow
end
