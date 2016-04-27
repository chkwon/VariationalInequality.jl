# VariationalInequality.jl

[![Build Status](https://travis-ci.org/chkwon/VariationalInequality.jl.svg?branch=master)](https://travis-ci.org/chkwon/VariationalInequality.jl)
[![Coverage Status](https://coveralls.io/repos/chkwon/VariationalInequality.jl/badge.svg)](https://coveralls.io/r/chkwon/VariationalInequality.jl)

This package implements solution algorithms for solving finite-dimensional [variational inequality](https://en.wikipedia.org/wiki/Variational_inequality) (VI) problems. This package is an extension of the [JuMP.jl](https://github.com/JuliaOpt/JuMP.jl) package.

# Documentation

- [Read the Documentation](http://VariationalInequalityjl.readthedocs.org/).


# Other Links

For solving complementarity problems, the [PATHSolver.jl](https://github.com/chkwon/PATHSolver.jl) package provides a wrapper for the well-known PATH solver.




### To Do

- Implementing the Diagonalization algorithm, as a simple experiment.

- Implementing the convex optimization method of [Aghassi et al. (2006)](http://dx.doi.org/10.1016/j.orl.2005.09.006)

- Implementing the projection algorithm of [Solodov and Svaiter (1999)](http://dx.doi.org/10.1137/S0363012997317475) and check the performance.

- Interior-point method for VI?
