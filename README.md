# JuVI - Julia for Variational Inequality

[![Build Status](https://travis-ci.org/chkwon/JuVI.jl.svg?branch=master)](https://travis-ci.org/chkwon/JuVI.jl)
[![Coverage Status](https://coveralls.io/repos/chkwon/JuVI.jl/badge.svg)](https://coveralls.io/r/chkwon/JuVI.jl)

This package implements solution algorithms for solving finite-dimensional variational inequality (VI) problems. [Read the Documentation](http://juvijl.readthedocs.org/).

This package is an extension of the [JuMP.jl](https://github.com/JuliaOpt/JuMP.jl) package.

# To Do

- Implementing the projection algorithm of [Solodov and Svaiter (1999)](http://dx.doi.org/10.1137/S0363012997317475) and check the performance.

- Writing a wrapper of the [PATH solver](http://pages.cs.wisc.edu/~ferris/path.html) for complementarity problems.
   - Tried to compile a Standalone-C example; couldn't compile both in Mac OS X and Ubuntu due to incompatibility of the library provided. Any help is welcome.

- Interior-point method for VI? 
