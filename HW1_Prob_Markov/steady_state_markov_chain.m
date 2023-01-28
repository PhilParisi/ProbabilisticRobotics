% calculating the steady state of a markov chain
% create a system of equations

% Eqn 1, all probabilities in steady state must equal 1
    % p1 + p2 + p3

% Eqn 2, p1 must equal all other steady states entering state 1
    % p1 = p1(0.8) + p2(0.4) + p3(0.2)

% Eqn 3, p2 must equal all other steady states entering state 2
    % p2 = p1(0.2) + p2(0.4) + p3 (0.6)

% could also make an equation 4, but we now have 3 eqns and 3 unkowns

% solve using reduced row echelon form, linear algebra

A = [ 1.0 1.0 1.0 1.0;
     -0.2 0.4 0.2 0.0;
     0.2 -0.6 0.6 0.0];

rref(A) %final column shows [p1; p2; p3]