%--------------------------------------------------------------------------
%Using sensitivity matrix computed in DriverBasic_sens.m, identifies 
%pairwise correlations between parameters and returns sensitive and 
%linearly independent parameter subset
%--------------------------------------------------------------------------

%covariance

clear all 

load('Sens/sensHPV68_20150112_val1.mat')
%INDMAP = [1 6 8 14 15 20]; 
%(1,14),(1,15),(14,15) correlated > 0.95, remove 1
%INDMAP = [6 8 14 15 20]; 
%none correlated

S = sens(:,INDMAP);

% Model Hessian
A  = S'*S;
Ai = inv(A);
disp('condition number of A = transpose(S)S and S');
disp([ cond(A) cond(S) cond(Ai)] );

% Calculate the covariance matrix
[a,b] = size(Ai);
for i = 1:a
    for j = 1:b
        r(i,j)=Ai(i,j)/sqrt(Ai(i,i)*Ai(j,j)); % covariance matrix
    end
end

tol = .9; 
rn = triu(r,1) % extract upper triangular part of the matrix
[i,j] = find(abs(rn)>tol); % parameters with a value bigger than 0.95 are correlated

disp('correlated parameters');
for k = 1:length(i)
   disp([INDMAP(i(k)),INDMAP(j(k)),rn(i(k),j(k))]);
end

disp(Isens)