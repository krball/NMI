function Info = nmi(x)
% Find the normalized mutual information among the components of a random vector x taking binary values.
% The NMI is the sum of component entropies minus the multivariate joint entropy,
% normalized by a factor of 1/(n-1).
% INPUTS:
% x is a [n,N] array of signals: n channels, N frames/observations.
% non-zero values of x are converted to one, signals in x should represent spike information.
%
% OUTPUT:
% Info is positive real of type double.
%   Info (NMI value) can be interpreted in terms of the information rate in units of bits per T, where T is the sampling rate.
%   for bits per second simply multiply by the sampling rate.
%
%Copyright 2016 Kenneth Ball
%
%Licensed under the Apache License, Version 2.0 (the "License");
%you may not use this file except in compliance with the License.
%You may obtain a copy of the License at
%
%    http://www.apache.org/licenses/LICENSE-2.0
%
%Unless required by applicable law or agreed to in writing, software
%distributed under the License is distributed on an "AS IS" BASIS,
%WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%See the License for the specific language governing permissions and
%limitations under the License.

% If you use or modify one of these functions please reference the following paper:
%   
% Kenneth R. Ball, Christopher Grant, William R. Mundy, Timothy J. Shafer, 
% A multivariate extension of mutual information for growing neural networks, 
% Neural Networks (2017), In Press.


n = size(x,1); % signal dimensionality
N = size(x,2); % Number of time points in signal.

x(x ~= 0) = 1;

% component entropy:
P = diag(x*x')/N;
H = -P.*log2(P) - (1-P).*log2(1-P);

% remove from analysis any components with trivially low entropy:
entropyCutOff = -.999*log2(.999) - (1-.999)*log2(1-.999);
nn = length(H(H>entropyCutOff)) + length(H(isnan(H)));
x = x(H > entropyCutOff , :);
H = H(H > entropyCutOff);
%nn = size(x,1);
if nn == 1
  Info = 0; % normally we'd return the entropy of the single component, but here we return 0 to signify no interactions.
  return;
elseif nn < 1
  Info = 0;
  return;
end

% joint entropy 
% interpret each column of x as an integers coded in n-bit binary:
% X is [N,1] array of ints. we add +1 so there are no non-zero elements.
X = bin2dec(char(x'+'0')) + 1;

PP = nonzeros(accumarray(X,1));
PP = PP/N;
HH = sum(-PP.*log2(PP));

H(isnan(H)) = 0;
HH(isnan(HH)) = 0;


Info = sum(H) - HH;
Info = 1/(nn-1)*Info;


end