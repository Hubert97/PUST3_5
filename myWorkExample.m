clear all
close all
    %addpath('F:\SerialCommunication'); % add a path to the functions
    initSerialControl COM3 % initialise com port
    Y = [];
    U = [];
    k = 1;
    yzad=[];
    u_max=100;
    u_min=0;
    
    load('rozdzielone_odp_skokowe.mat', 'GT')
    
    D=150; N=35; Nu=5; lambda=1;
    Upp=[30 35];
    Ypp=[124  132];
    
    BigMp=cell(1,4); %po wykonaniu ponizszej petli jest zamieniona na macierz 2x2
    smallMp=zeros(N,D-1);        %macierz ma wymiary Nx(D-1)
    for j=1:4
        gotowa_odp_skokowa=GT(:,j);
        for i=1:D-1 %wypelnianie macierzy Mp
           smallMp(1:N, i)=gotowa_odp_skokowa(i+1:N+i)-gotowa_odp_skokowa(i);
        end
        BigMp(j)={smallMp};
    end
    BigMp(2,1:2)=BigMp(1,3:4); %zrobienie z Mp macierzy kwadratowej zamiast wektora
    BigMp=BigMp(:,1:2);
    
    
    BigM=cell(1,4); %po wykonaniu ponizszej petli jest zamieniona na macierz 2x2
    for i2=1:4
        smallM=zeros(N, Nu);
        i=0;
        gotowa_odp_skokowa=GT(:,i2);
        for j=1:Nu  %wypelnianie macierzy trojkatnej dolnej M
           smallM(j:N,j)=gotowa_odp_skokowa(1:N-i).';  
           i=i+1;
        end
        BigM(i2)={smallM};
    end
    BigM(2,1:2)=BigM(1,3:4); %zrobienie z M macierzy kwadratowej zamiast wektora
    BigM=BigM(:,1:2);
    
    I=eye(Nu);%tworzenie macierzy jednostkowej o wymiarach NuxNu
    
    K=cell(2,2);
    for i=1:2
        for j=1:2
            M=BigM(i,j);
            M=cell2mat(M);
            K(i,j)={inv(M.'*M+lambda*I)*M.'};   %macierz K
        end
    end
    K_1={K{1,1}(1,1:N), K{1,2}(1,1:N);...
        K{2,1}(1,1:N), K{2,2}(1,1:N)};
    Ke=[sum(K_1{1,1}), sum(K_1{1,2})
        sum(K_1{2,1}), sum(K_1{2,2})];
    Ku={K_1{1,1}(1,:)*BigMp{1,1}(:,:),K_1{1,2}(1,:)*BigMp{1,1}(:,:);...
        K_1{2,1}(1,:)*BigMp{1,1}(:,:),K_1{2,2}(1,:)*BigMp{1,1}(:,:)};
    
    deltaUP(1:D-1,1:2)=0;
    iloczynyMpDeltaUp=cell(2,2);
    iloczynyKuDeltaUp=cell(2,2);
    while(1)
        %% obtaining measurements
        measurements = readMeasurements([1,3]); % read measurements 1 and 3
        
%         %% processing of the measurements and new control values calculation
        disp(measurements); % process measurements
%         
%         %% sending new values of control signals
        if(    k <  10)
            if k>0
                yzad(k,:)=Ypp;
            end
        elseif(k <  50)
                yzad(k,:)=Ypp;
        elseif(k < 100)
                yzad(k,:)=[50 75];
        else
                yzad(k,:)=[80 65];
        end
        
        
        
        Y = [Y; measurements]; 
        
        yzad(k,:)=yzad(k,:)-Ypp;
        y=Y-Ypp;
        e=yzad(k,:)-y(k,:);
        Yzad(1:N,1)=yzad(k,1)*ones(N,1);
        Yzad(1:N,2)=yzad(k,2)*ones(N,1);
        
        %niezrobione
        
        if k>2
            deltaUP(2:D-1, :)=deltaUP(1:D-2, :);
            deltaUP(1,:) = u(k-1)-u(k-2);
        elseif k==2
            deltaUP(1,:)=u(k-1);
        end
        
        sumaIloczynowMpDeltaUp=[0 0];
        for i=1:2
            for j=1:2
                iloczynyMpDeltaUp(i,j)={BigMp{i,j}(:,:)*deltaUP};
            end
            sumaIloczynowMpDeltaUp=sumaIloczynowMpDeltaUp+iloczynyMpDeltaUp{i,j}(:,:);
        end
        Y0=sumaIloczynowMpDeltaUp+y(k);
        
        sumaIloczynowKuDeltaUp=[0 0];
        for i=1:2
            for j=1:2
                iloczynyKuDeltaUp(i,j)={Ku{i,j}(:,:)*deltaUP};
            end
            sumaIloczynowKuDeltaUp=sumaIloczynowKuDeltaUp+iloczynyKuDeltaUp{i,j}(:,:);
        end
        delta_u=e*Ke-sumaIloczynowKuDeltaUp;
        
        if k<2
            u(k,:)=delta_u;
        else
            u(k,:)=u(k-1,:)+delta_u;
        end
        
        if u(k,1)>u_max
            u(k,1)=u_max;
        elseif u(k,1)<u_min
            u(k,1)=u_min;
        end
        
        if u(k,2)>u_max
            u(k,2)=u_max;
        elseif u(k,2)<u_min
            u(k,2)=u_min;
        end
        
        controls=u(k,:)+Upp;
        yzad(k,:)=yzad(k,:)+Ypp;
        sendControls([5,6]    ,... send for these elements
                     controls);  % new corresponding control values
        subplot(2,1,1); 
        h=plot(Y); hold on; legend; stairs(yzad(:,1), '--','DisplayName', 'yzad1');
        stairs(yzad(:,2), '--','DisplayName', 'yzad2'); hold off;  drawnow
        U = [U; controls];     subplot(2,1,2); stairs(U); ylim([-5,105]); drawnow
        
        
        k = k+1;
        %% synchronising with the control process
        waitForNewIteration(); % wait for new batch of measurements to be ready
    end
%     [Y,U]=step(300);
%     figure
%     subplot(2,1,1); plot(Y);
%     subplot(2,1,2); stairs(U); ylim([-5,105]);

