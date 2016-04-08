# using JuMP, JuVI
# using Base.Test

using JuMP, Ipopt
include("../src/model.jl")
include("../src/algorithms.jl")

# Gabriel book


# Something's wrong....
# NOT YET BEEN TESTED


m = JuVIModel()

@defVar(m, q_s)
@defVar(m, q_s_hat)
@defVar(m, q_d)
@defVar(m, q_d_hat)

@addNLConstraint(m, q_s - q_d == 0)
@addNLConstraint(m, q_s_hat - q_d_hat == 0)

@defNLExpr(m, F1, 0.5 + 0.0001 * q_s)
@defNLExpr(m, F2, 23/70 + 1/70000 * q_s_hat)
@defNLExpr(m, F3, -2.7984 + 0.0000172 * q_d + 0.00000645 * q_d_hat)
@defNLExpr(m, F4, -2.2262 + 0.00000239 * q_d + 0.0000287 * q_d_hat)

addRelation!(m, [F1, F2, F3, F4], [q_s, q_s_hat, q_d, q_d_hat])

sol1, Fval1, gap1 = solveVIP!(m, algorithm=:extra_gradient, max_iter=10000, step_size=0.1)

println(sol1[q_s])
println(sol1[q_s_hat])
println(sol1[q_d])
println(sol1[q_d_hat])

println(sol1)

println(gap1)
