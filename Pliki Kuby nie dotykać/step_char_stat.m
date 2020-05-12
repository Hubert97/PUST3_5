% function [Y, U] = step()
function T2 = step()
    object = HeatingCooling(); % walk into lab
    Y = [];
    U = [];
    k = 0;
    controls = [0, 0];
    T2=[];
    
    figure;
    for i=1:1000
        for j=1:1000
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

              controls = [i*0.1, j*0.1];  


            object.setControlsSim(controls');  % new corresponding control values
        
            T2(i,j) = measurements(2);  %subplot(3,1,1); plot(Y); drawnow
            %U = [U; controls]; subplot(3,1,2); stairs(U); ylim([-5,105]); drawnow 
%              subplot(3,1,3); plot(U,Y(:,1)); drawnow

            %% synchronising with the control process
            object.nextStepSim();
            object.refresh();
        end
    end
end
