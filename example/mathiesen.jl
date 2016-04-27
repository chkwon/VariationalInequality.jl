using VariationalInequality
using JuMP, Ipopt

using Base.Test
using FactCheck

# include("../src/model.jl")
# include("../src/algorithms.jl")


# [21] L. Mathiesen, An algorithm based on a sequence of linear complementarity problems applied
# to a Walrasian equilibrium model: An example, Math. Programming, 37 (1987), pp. 1–18.

m = VIPModel()

@defVar(m, x1>=0)
@defVar(m, x2>=0)
@defVar(m, x3>=0)

@addNLConstraint(m, x1+x2+x3 <= 1)
@addNLConstraint(m, x1-x2-x3 <= 0)

@defNLExpr(m, F1, 0.9* (5*x2 + 3*x3)/x1 )
@defNLExpr(m, F2, 0.1* (5*x2 +3*x3) /x2   -  5)
@defNLExpr(m, F3, -3)

addRelation!(m, [F1, F2, F3], [x1, x2, x3])

solveVIP!(m, algorithm=:fixed_point, max_iter=1000, step_size=0.01)
sol0, Fval0, gap0 = saveSolution(m)

solveVIP!(m, algorithm=:extra_gradient, max_iter=1000, step_size=0.01)
sol1, Fval1, gap1 = saveSolution(m)

println(sol0)
println(sol1)

println(gap0)
println(gap1)


# (1, 0, 0)
