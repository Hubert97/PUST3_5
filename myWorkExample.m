clear all
close all
    %addpath('F:\SerialCommunication'); % add a path to the functions
    initSerialControl COM3 % initialise com port
    Y = [];
    U = [];
    k = 1;
    yzad=[];
    
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
    
    while(1)
        %% obtaining measurements
        measurements = readMeasurements([1,3]); % read measurements 1 and 3
        
%         %% processing of the measurements and new control values calculation
        disp(measurements); % process measurements
%         
%         %% sending new values of control signals
        if(    k <  10)
            controls = [ 30,   35];
            if k>0
                yzad(k,:)=[100 75];
            end
        elseif(k <  50)
            controls = [ 30, 35];
                yzad(k,:)=[50 75];
        elseif(k < 100)
            controls = [  30,  35];
                yzad(k,:)=[50 75];
        else
                yzad(k,:)=[80 65];
            controls = [  30,  35];
        end
        sendControls([5,6]    ,... send for these elements
                     controls);  % new corresponding control values
        k = k+1;
        
        Y = [Y; measurements]; subplot(2,1,1); 
        h=plot(Y); hold on; legend; stairs(yzad(:,1), '--','DisplayName', 'yzad1');
        stairs(yzad(:,2), '--','DisplayName', 'yzad2'); hold off;  drawnow
        U = [U; controls];     subplot(2,1,2); stairs(U); ylim([-5,105]); drawnow
        
        %% synchronising with the control process
        waitForNewIteration(); % wait for new batch of measurements to be ready
    end
%     [Y,U]=step(300);
%     figure
%     subplot(2,1,1); plot(Y);
%     subplot(2,1,2); stairs(U); ylim([-5,105]);

