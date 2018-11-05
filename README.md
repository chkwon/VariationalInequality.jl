# VariationalInequality.jl

<!-- [![VariationalInequality](http://pkg.julialang.org/badges/VariationalInequality_0.5.svg)](http://pkg.julialang.org/?pkg=VariationalInequality)
[![VariationalInequality](http://pkg.julialang.org/badges/VariationalInequality_0.6.svg)](http://pkg.julialang.org/?pkg=VariationalInequality)
[![VariationalInequality](http://pkg.julialang.org/badges/VariationalInequality_0.7.svg)](http://pkg.julialang.org/?pkg=VariationalInequality) -->


[![Build Status](https://travis-ci.org/chkwon/VariationalInequality.jl.svg?branch=master)](https://travis-ci.org/chkwon/VariationalInequality.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/yj93tqlm5r51alen?svg=true)](https://ci.appveyor.com/project/chkwon/variationalinequality-jl)
[![Coverage Status](https://coveralls.io/repos/github/chkwon/VariationalInequality.jl/badge.svg?branch=master)](https://coveralls.io/github/chkwon/VariationalInequality.jl?branch=master)


This package implements solution algorithms for solving finite-dimensional [variational inequality](https://en.wikipedia.org/wiki/Variational_inequality) (VI) problems. This package is an extension of the [JuMP.jl](https://github.com/JuliaOpt/JuMP.jl) package.

# Documentation

- [Read the Documentation](http://VariationalInequalityjl.readthedocs.org/).


# Other Related Packages

- [TrafficAssignment.jl](https://github.com/chkwon/TrafficAssignment.jl) - Solving the variational inequality problem arising in computing the network user equilibrium

- [Complementarity.jl](https://github.com/chkwon/Complementarity.jl) - Modeling and solving complementarity problems




### To Do

- Implementing the Diagonalization algorithm, as a simple experiment.

- Implementing the convex optimization method of [Aghassi et al. (2006)](http://dx.doi.org/10.1016/j.orl.2005.09.006)

- Implementing the projection algorithm of [Solodov and Svaiter (1999)](http://dx.doi.org/10.1137/S0363012997317475) and check the performance.

- Interior-point method for VI?
