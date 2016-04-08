using JuVI
using JuMP, Ipopt

using Base.Test
using FactCheck

# include("../src/model.jl")
# include("../src/algorithms.jl")


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

@show sol1
@show gap1

@show sol1[Q[1,1]]
@show sol1[Q[2,1]]
@show sol1[q[1]]
@show sol1[q[2]]

# # The above `solveVIP!` sets the value of variables at the solution
# clearValues!(model)
#
# solveVIP!(model, algorithm=:extra_gradient, max_iter=1000, step_size=0.01)
# sol2, Fval2, gap2 = saveSolution(model)
# @assert 0<= gap2 < 1e-6
#
# # sol2, Fval2, gap2 = solveVIP(m, algorithm=:hyperplane, max_iter=1000, step_size=0.1)
#
# @show sol1
# @show sol2
# @show gap1
# @show gap2