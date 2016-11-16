function [b,psi] = Kalman_matlab_fnc(u, y, data)
%#codegen
persistent init_flag A B C E Q R P_ x_ I 

if (isempty(init_flag))
    init_flag = 1;
    
    % Initialization for system
    [A,B,C,E,Q,R,P_,x_, I] = deal(data.Ad,data.Bd,data.Cd,data.Ed, ...
        data.Q, data.R, data.P_0, data.X_0, data.I);
end

% 1 - Compute the Kalman Gain
    L = (P_*C')/((C*P_*C'+R));
% 2 - Update estimate with measurment
    x = x_ + L*(y-C*x_);
% 3 - Update error covariance matrix
    P = (I - L*C)*P_*(I-L*C)'+L*R*L';
% 4 - Projet ahead
    x_ = A*x + B*u;
    P_ = A*P*A' + E*Q*E';

psi = x(3); b = x(5);

end