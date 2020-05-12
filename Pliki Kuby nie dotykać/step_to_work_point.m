function [Y_synt, U_synt] = step_to_work_point(sim_time)
    object = HeatingCooling(); % walk into lab
    Y_synt = [];
    U_synt = [];
    k = 0;
    controls = [0, 0];
    
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
%             controls = [23, 28]; tak by³o
              controls = [20, 25];   
        end
        object.setControlsSim(controls');  % new corresponding control values
        k = k+1;
        
        Y_synt = [Y_synt; measurements];   
        U_synt = [U_synt; controls];  
        
        %% synchronising with the control process
        object.nextStepSim();
        object.refresh();
    end
end
