%% Function: Ackermann Solver
% This function takes in car geometry, "neutral" steering angle, 
% and ackermann percentage, 
% returns the exact steering angles of both turning tires
function [delta_l, delta_r] = AckermannSolver(ackermann, delta, t, l)

    syms din dout la Ra
    eqn1 = cot(dout) - cot(din) == t*ackermann/l;
    eqn2 = tan(abs(delta)) == la/Ra;
    eqn3 = tan(dout) == la/(Ra + t/2);
    eqn4 = tan(din) == la/(Ra - t/2);

    if delta == 0

        delta_l = 0;
        delta_r = 0; 

    elseif ackermann == 0

        delta_l = delta;
        delta_r = delta;

    else 

        sol = solve([eqn1, eqn2, eqn3, eqn4], [din dout la Ra]);

        if delta > 0

        delta_r = double(sol.din);
        delta_l = double(sol.dout);

        else

        delta_l = -double(sol.din);
        delta_r = -double(sol.dout);

        end

    end

    return;
    
end