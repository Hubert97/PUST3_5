function [Y, U] = step()
    object = HeatingCooling(); % walk into lab
    Y = [];
    U = [];
    k = 0;
    controls = [0, 0];
    
    figure;
    while(k < 1000)
        %% obtaining measurements
        measurements = object.getMeasurementsSim(); % read measurements 1 and 3
        
        noise = normrnd(0, 1, [size(measurements), 1]);
        measurements = measurements + noise;
        
        measurements = measurements';
        
%         %% processing of the measurements and new control values calculation
%          disp(measurements); % process measurements
%         
%         %% sending new values of control signals
%         if (k == 0)
%               controls = [0, 25];
%         elseif(k>1400)
%             controls = [0, 15];
%         elseif(k>1200)
%             controls = [0, 25];
%         elseif(k>1000)
%             controls = [0, 20];
%         elseif(k>800)
%             controls = [0, 25];
%         elseif(k>600)
%             controls = [0, 35];
%         elseif(k>400)
%             controls = [0, 25];
%         elseif(k>200)
%             controls = [0, 30];
%         end
          controls = [k*0.1, 0];  
                                %%%%%%%%%%%%%% CHARAKTERYSTYKA STATYCZNA
                                for i=1:20000
                                   U(i)=i*0.005;
                                   for k=12:kk
                                       Y(k)=symulacja_obiektu5Y(U(k-10),U(k-11),Y(k-1),Y(k-2));
                                   end
                                   Ustat(i)=U(kk);
                                   Ystat(i)=Y(kk);

                                end
                                %%%%%%%%%%%%%% WZMOCNIENIE STATYCZNE
                                Kstat=(Ystat(400)-Ystat(200))/(Ustat(400)-Ustat(200));

                                %%%%%%%%%%%%%%%%WYKRESY%%%%%%%%%%%%%%%%%%

                                %WYKRES CHARAKTERYSTYKI STATYCZNEJ
                                plot(Ustat,Ystat);
                                xlabel('U');
                                ylabel('Y');
                                title('Charakterystyka statyczna Y(U)');
        
        object.setControlsSim(controls');  % new corresponding control values
        k = k+1;
        
        Y = [Y; measurements];  subplot(2,1,1); plot(Y); drawnow
        U = [U; controls]; subplot(2,1,2); stairs(U); ylim([-5,105]); drawnow  
        
        %% synchronising with the control process
        object.nextStepSim();
        object.refresh();
    end
end
