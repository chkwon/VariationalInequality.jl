.. _index:

----------------------------------------
JuVI: Julia for Variational Inequalities
----------------------------------------

This package implements solution algorithms for solving finite-dimensional variational inequality (VI) problems of the following form:

To find :math:`x^* \in X` such that

.. math::
    F(x^*)^T (x-x^*) \geq 0 \qquad \forall x \in X

where the set :math:`X` is defined by equalities and inequalities. The problem may be called :math:`VI(F,X)`.


Installation
^^^^^^^^^^^^

Please note that currently JuVI is under development.

.. code-block:: julia

   Pkg.clone("https://github.com/chkwon/JuVI.jl.git")

.. code-block:: julia

    julia> using JuMP

Example 1
^^^^^^^^^

.. math::
    \sum_{p=1}^3 F_p(h^*) (h_p - h_p^*) \geq 0 \quad\forall h \in X \\
    X = \{ h : \sum_{p=1}^3 h_p = T_{14} \}

.. code-block:: julia

    using JuMP, JuVI
    using Base.Test

    # write your own tests here

    m = JuVIModel()

    A = [25; 25; 75; 25; 25]
    B = [0.010; 0.010; 0.001; 0.010; 0.010]
    T14 = 100
    p = 3

    @defVar(m, h[i=1:p] >= 0)

    # Add constraints to construct the feasible space
    # The set X as in VI(F,X)
    @addNLConstraint(m, sum{h[i], i=1:p} == T14)

    # Define expressions to be used for the operator of the VI
    # The operator F as in VI(F,X)
    @defNLExpr(m, F1, A[1]+B[1]*h[1]^2 + A[4]+B[4]*(h[1]+h[2])^2 )
    @defNLExpr(m, F2, A[2]+B[2]*(h[2]+h[3])^2 + A[3]+B[3]*h[2]^2 + A[4]+B[4]*(h[1]+h[2])^2 )
    @defNLExpr(m, F3, A[2]+B[2]*(h[2]+h[3])^2 + A[5]+B[5]*(h[3])^2 )
    F = [F1, F2, F3]

    # The order in F and h should match.
    setVIP(m, F, h)

    # sol = the solution x^*
    # Fval = F(x^*)
    sol, Fval = solveVIP(m, algorithm=:extra_gradient, max_iter=100, step_size=0.01)

    @show solution
