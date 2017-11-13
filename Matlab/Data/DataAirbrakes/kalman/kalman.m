
classdef kalman <handle
    properties
        i
        P
        H
        % B pas de commande
        R
        Q
        x
        mass_motor
        mass_rocket
        thrust
    end
    methods
        function obj = kalman(init)
            obj.i = 0;
            obj.P = init.P;
            obj.H = init.H;
            obj.x = init.x;
            obj.thrust = init.thrust;
            obj.mass_motor = init.mass_motor;
            obj.mass_rocket = init.mass_rocket;
        end

        function [ x ] = update(obj, z, R, Q)
            % z = [measured alt, measured speed, measured acc];
            % dt = period
            obj.i = obj.i+1;
            dt = .01;
            m = 2;
            
            % TODO transmetre env.rho, roro.Aref et roro.Cd
            rho = 1.225;
            A_ref = 0.0082;
            Cd = .3;
            
            acc = (0.5*1.225*obj.x(2)^2*(0.0082*.3)+obj.thrust(obj.i))/(obj.mass_motor(obj.i) + obj.mass_rocket);
            % TODO ajouter aire brakes et CD brakes
            
            
            
   
            % motion model that predicts the current state frome previous
            x_hat = motion_model(obj, dt);
            
            % Jacobian of the motion model
            F = [1 dt acc*dt^2; 0 1 acc*dt; 0 0 acc];
            obj.P = F*obj.P*F' + Q;

            y = z - obj.H * x_hat;   %x_hat(2)
            S = obj.H*obj.P*obj.H' + R;
            K = obj.P * (obj.H')/(S);
            obj.x = obj.x + K*y;
            obj.P = (eye(3)-K*obj.H)*obj.P;
            x = obj.x;

        end
   end
end