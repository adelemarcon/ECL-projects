function [b0, A] = myaryule( y, na, intype)

% myaryule : AR model parameter estimation via Yule-Walker method.
%
%   [b0, A] = myaryule( y, na, type) returns the coefficients A = [1, a_1, ..., a_na] and b_0
%   of the transfert function
%
%           F(z) = b_0 / ( 1 + a_1 z^(-1) + ... + a_na z^(-na) )
%
%   associated with the autoregressive (AR) parametric model of the signal y.
%   This method solves the Yule-Walker equations by means of the Levinson-Durbin recursion.
%   
%   The input "intype" must be set to 'det' for deterministic signals and to 'rand' for random signals.
%   For a model order na, the output A is a row vector of length na+1.


narginchk(3,3)

y = y(:); % perform column vector conversion
if size(y,1) < na
   error(message('signal:aryule:InvalidVectorLength'));
end

switch intype
    case  'rand'
        Ry = xcorr(y,na,'biased');
    case  'det'
        Ry = xcorr(y,na,'none');
end
Ry = double(Ry); % LEVINSON does not support 'R' of data type 'Single'.
A = levinson(Ry(na+1:end),na);

b0 = sqrt(A*Ry(na+1:end));


