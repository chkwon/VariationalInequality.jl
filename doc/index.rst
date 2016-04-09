.. _index:

----------------------------------------
JuVI: Julia for Variational Inequalities
----------------------------------------

This package, `JuVI.jl <https://github.com/chkwon/JuVI.jl>`_, implements solution algorithms for solving finite-dimensional variational inequality (VI) problems of the following form:

To find :math:`x^* \in X` such that

.. math::
    F(x^*)^\top (x-x^*) \geq 0 \qquad \forall x \in X

where the set :math:`X` is defined by equalities and inequalities. The problem may be called :math:`VI(F,X)`.

This package requires ``Ipopt`` and only support nonlinear constraints and expressions; that is, one must use ``@addNLConstraint`` and `@defNLExpr` instead of ``@addConstraint`` and ``@defExpr``.


Installation
^^^^^^^^^^^^

Please note that currently JuVI is under development.

.. code-block:: julia

   Pkg.clone("https://github.com/chkwon/JuVI.jl.git")



Example 1
^^^^^^^^^

.. math::
    \sum_{p=1}^3 F_p(h^*) (h_p - h_p^*) \geq 0 \quad\forall h \in X \\
    X = \bigg\{ h : \sum_{p=1}^3 h_p = T_{14} \bigg\}

.. code-block:: julia

    using JuMP, JuVI

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

    # The order in F and h should match.
    F = [F1, F2, F3]
    addRelation!(m, F, h)

    # sol = the solution x^*
    # Fval = F(x^*)
    # gap = value of the gap function
    sol, Fval, gap = solveVIP!(m, algorithm=:extra_gradient, max_iter=1000, step_size=0.01)

    @show sol



Example 2
^^^^^^^^^

.. code-block:: julia

    # https://supernet.isenberg.umass.edu/articles/SPE_Model_Information_Asymmetry_in_Quality.pdf
    # Problem (15), Data in Table 1, Example 1
    m = 2; n = 1

    model = JuVIModel()

    @defVar(model, s[i=1:m] >=0)
    @defVar(model, d[j=1:n] >=0)
    @defVar(model, Q[i=1:m, j=1:n] >= 0)
    @defVar(model, q[i=1:m] >= 0)

    @addNLConstraint(model, supply[i=1:m], s[i] == sum{Q[i,j], j=1:n})
    @addNLConstraint(model, demand[j=1:n], d[j] == sum{Q[i,j], i=1:m})

    as = [5; 2]
    bs = [5; 10]
    @defNLExpr(model, pi[i=1:m], as[i] * s[i] + q[i] + bs[i])

    ac = [1; 2]
    bc = [15; 20]
    @defNLExpr(model, c[i=1:m, j=1:n], ac[i,j] * Q[i,j] + bc[i,j] )

    ad = [2]
    bd = [100]
    @defNLExpr(model, qhat[j=1:n], sum{q[i]*Q[i,j], i=1:m} / ( sum{Q[i,j], i=1:m} + 1e-6 ) )
    @defNLExpr(model, nrho[j=1:n], ad[j] * d[j] - qhat[j] - bd[j] )

    aq = [5; 10]
    @defNLExpr(model, OC[i=1:m], aq[i] * q[i] )
    @defNLExpr(model, Fq[i=1:m], OC[i] - pi[i] )


    addRelation!(model, pi, s)
    addRelation!(model, c, Q)
    addRelation!(model, nrho, d)
    addRelation!(model, Fq, q)

    for i=1:m, j=1:n
        setValue(Q[i,j], 1.0)
    end

    sol1, Fval1, gap1 = solveVIP!(model, algorithm=:fixed_point, max_iter=10000, step_size=0.1, tolerance=1e-10)
    @assert 0<= gap1 < 1e-6

    @show gap1

    @show sol1[Q[1,1]]
    @show sol1[Q[2,1]]
    @show sol1[q[1]]
    @show sol1[q[2]]
