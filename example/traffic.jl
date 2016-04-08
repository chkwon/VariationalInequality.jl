# using JuMP, JuVI
# using Base.Test

using JuMP, Ipopt
include("../src/model.jl")
include("../src/algorithms.jl")

# write your own tests here

m = JuVIModel()

A = [25; 25; 75; 25; 25]
B = [0.010; 0.010; 0.001; 0.010; 0.010]
T14 = 100
p = 3

@defVar(m, h[i=1:p] >= 0)

@defNLExpr(m, F1, A[1]+B[1]*h[1]^2 + A[4]+B[4]*(h[1]+h[2])^2 )
@defNLExpr(m, F2, A[2]+B[2]*(h[2]+h[3])^2 + A[3]+B[3]*h[2]^2 + A[4]+B[4]*(h[1]+h[2])^2 )
@defNLExpr(m, F3, A[2]+B[2]*(h[2]+h[3])^2 + A[5]+B[5]*(h[3])^2 )

F = [F1, F2, F3]

@addNLConstraint(m, sum{h[i], i=1:p} == T14)

setVIP(m, F, h)
solution = solveVIP(m, algorithm=:extra_gradient, max_iter=1000, step_size=0.01)
@show solution
solution = solveVIP(m, algorithm=:hyperplane, max_iter=1000, step_size=0.1)




# Test 2

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

setVIP(m, [F1, F2, F3, F4], [q_s, q_s_hat, q_d, q_d_hat])
solution = solveVIP(m, algorithm=:hyperplane, max_iter=100, step_size=0.1)

println(getValue(q_s))
println(getValue(q_s_hat))
println(getValue(q_d))
println(getValue(q_d_hat))
