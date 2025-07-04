%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPML101
% Project Title: Evolutionary Clustering in MATLAB
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function y=Mutate(x,mu,VarMin,VarMax)

    nVar=numel(x);
    
    nmu=ceil(mu*nVar);
    
    j=randsample(nVar,nmu);
  
    sigma=0.1*(VarMax-VarMin);
    
    y=x;
    
%     disp( y(j));
%     disp(sigma*randn(size(j)));
%     
    y(j)=x(j)+(sigma*randn(size(j)))';
    
   
    y=max(y,VarMin);
    y=min(y,VarMax);

end