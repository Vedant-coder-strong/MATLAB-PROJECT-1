clc; clear; close all;

% Define system parameters
m = 1000;   % Mass of vehicle (kg)
b = 50;     % Damping coefficient (N.s/m)
v_ref = 25; % Desired velocity (m/s)

% Open a new Simulink model
model_name = 'CruiseControlSystem';
open_system(new_system(model_name));

% Add blocks
add_block('simulink/Sources/Constant', [model_name, '/Reference Speed'], 'Position', [50, 50, 100, 70], 'Value', num2str(v_ref));
add_block('simulink/Commonly Used Blocks/Sum', [model_name, '/Sum'], 'Position', [150, 50, 180, 80], 'Inputs', '|+-');
add_block('simulink/Continuous/PID Controller', [model_name, '/PID Controller'], 'Position', [200, 50, 280, 100], 'P', '500', 'I', '100', 'D', '50');
add_block('simulink/Commonly Used Blocks/Gain', [model_name, '/1/m'], 'Position', [350, 50, 390, 80], 'Gain', num2str(1/m));
add_block('simulink/Commonly Used Blocks/Gain', [model_name, '/-b/m'], 'Position', [250, 150, 300, 180], 'Gain', num2str(-b/m));
add_block('simulink/Continuous/Integrator', [model_name, '/Velocity'], 'Position', [450, 50, 500, 80]);

% Add feedback loop
add_block('simulink/Commonly Used Blocks/Scope', [model_name, '/Scope'], 'Position', [550, 50, 600, 80]);

% Connect blocks
add_line(model_name, 'Reference Speed/1', 'Sum/1');
add_line(model_name, 'Velocity/1', 'Sum/2');
add_line(model_name, 'Sum/1', 'PID Controller/1');
add_line(model_name, 'PID Controller/1', '1/m/1');
add_line(model_name, '1/m/1', 'Velocity/1');
add_line(model_name, 'Velocity/1', 'Scope/1');

% Close and Save the model
save_system(model_name);
disp('Cruise Control Simulink Model Created.');