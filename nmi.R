# Find the normalized mutual information among the components of a random vector x taking binary values.
# The NMI is the sum of component entropies minus the multivariate joint entropy,
# normalized by a factor of 1/(n-1).
# INPUTS:
#   x is a [n,N] array of signals: n channels, N frames/observations.
# non-zero values of x are converted to one, signals in x should represent spike information.
#
# OUTPUT:
#   Info is positive real of type double.
#   Info (NMI value) can be interpreted in terms of the information rate in units of bits per T, where T is the sampling rate.
#   for bits per second simply multiply by the sampling rate.
#
# Copyright 2016 Kenneth Ball
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 
# If you use or modify one of these functions please reference the following paper:
#   
# Kenneth R. Ball, Christopher Grant, William R. Mundy, Timothy J. Shafer, 
# A multivariate extension of mutual information for growing neural networks, 
# Neural Networks (2017), In Press.

require('pracma')
library('compiler')

nmi<-function(x){  
  
  #n=size(x,1)
  #N=size(x,2)
  x <- as.matrix(x)
  n <- dim(x)[1]
  N <- dim(x)[2]
  
  x[x!=0]<-1
  
  P= diag(x%*%t(x))/N;  
  
  H = -P*log2(P) - (1-P)*log2(1-P);
  
  entropyCutOff = -.999*log2(.999) - (1-.999)*log2(1-.999);
  
  x=x[H > entropyCutOff,]
  H=H[H > entropyCutOff]
  nn <- dim(x)[1]
  # nn=size(x,1)
  if (nn<=1){
    Info=0
    return(Info)
  }
#X<-c()  
#for (i in 1:nrow(t(x))){  
# X[i]=strtoi(gsub(" ","",gsub(",","",toString(t(x)[i,]))),base=2)+1
#}
 bin2Dec <- function(m) {sum(2^(which(rev(m) == 1)-1))}
 X <- apply(x,2,bin2Dec)+1

 

 


 PP=accumarray(X,rep(1,length(X)))
 PP<-PP[PP!=0]
 PP<-PP/N
 HH = sum(-PP*log2(PP))

 H[is.nan(H)]<-0
 HH[is.nan(HH)]<-0

 
 
 
 Info=sum(H)-HH
 Info=(1/(nn-1))*Info
 return(Info)
}

nmi <-cmpfun(nmi)