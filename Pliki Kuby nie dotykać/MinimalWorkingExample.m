function MinimalWorkingExample()
    addpath('C:\Users\Kuba\Desktop\PUST lab 3.5'); % add a path to the functions
    initSerialControl COM3 % initialise com port
    Y = [];
    U = [];
    k = 0;
    while(1)
        %% obtaining measurements
        measurements = readMeasurements([1,3]); % read measurements 1 and 3
        
%         %% processing of the measurements and new control values calculation
        disp(measurements); % process measurements
%         
%         %% sending new values of control signals
        if(    k<1)
            controls = [20, 25];
        end

        if(    k <  10 && k>=1)
            controls = [ 100,   0];
        elseif(k <  50)
            controls = [ 100, 100];
        elseif(k < 100)
            controls = [  20,  20];
        else
            controls = [  25,  15];
        end
        sendControls([5,6]    ,... send for these elements
                     controls);  % new corresponding control values
        k = k+1;
        
        Y = [Y; measurements]; subplot(2,1,1); plot(Y);                   drawnow
        U = [U; controls];     subplot(2,1,2); stairs(U); ylim([-5,105]); drawnow
        
        %% synchronising with the control process
        waitForNewIteration(); % wait for new batch of measurements to be ready
    end
end
