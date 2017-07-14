# NMI
Octave and R functions for computing normalized multiinformation (a multivariate version of mutual information) on binary signals.

Copyright 2016 Kenneth Ball
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

If you use or modify one of these functions please reference the following paper:

Kenneth R. Ball, Christopher Grant, William R. Mundy, Timothy J. Shafer, 
A multivariate extension of mutual information for growing neural networks,
Neural Networks (2017), In Press.

Dependencies:
Octave/MATLAB version: NONE
R version: pracma (required), compiler (optional)

nmi.m is an Octave/MATLAB function that computes normalized multiinformation (NMI) on binary valued signals.

nmi.r is an R script that defines a function called nmi that computes NMI on binary valued signals.

INPUTS:
x <- an [n,N] array of binary values, where n is the number of channels and N is the number of observations.
(note) both functions will accept arrays with non-binary numbers, but will convert nonzero values to 1.

OUTPUTS:
Info <- a scalar value greater than or equal to zero, representing the NMI.

Both functions work by estimating entropy of individual channels and the aggregate entropy of the multidimensional signal. In the latter case this is accomplished by converting individual observations (time frames) across all channels to binary numbers. Then an instance count of each "number" (state of the system) is aggregated via accumarry. A maximally entropic system would have be uniformly distributed in the accumarry output.

An "entropyCutoff" is hard coded into each function that removes from consideration certain channels with nearly trivial entropy. The user may need to adjust this depending on needs.

The Octave function is vectorized and quite fast. The R version is a bit slower, but can be sped up using the compiler package to compile the function.

These functions are designed to work with binary variables. They could be modified to work with more general discrete our continuous signal types (using binning), however dimensionality quickly becomes a problem for reliable and efficient estimation of multivariate entropy.
