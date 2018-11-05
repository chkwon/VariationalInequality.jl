using JuMP, VariationalInequality
using Test

# https://supernet.isenberg.umass.edu/articles/SPE_Model_Information_Asymmetry_in_Quality.pdf
# Problem (15), Data in Table 1, Example 1
m = 2; n = 1

model = VIPModel()

@variable(model, s[i=1:m] >=0)
@variable(model, d[j=1:n] >=0)
@variable(model, Q[i=1:m, j=1:n] >= 0)
@variable(model, q[i=1:m] >= 0)

@constraint(model, supply[i=1:m], s[i] == sum(Q[i,j] for j in 1:n))
@constraint(model, demand[j=1:n], d[j] == sum(Q[i,j] for i in 1:m))

as = [5; 2]
bs = [5; 10]
@mapping(model, pi[i=1:m], as[i] * s[i] + q[i] + bs[i])

ac = [1; 2]
bc = [15; 20]
@mapping(model, c[i=1:m, j=1:n], ac[i,j] * Q[i,j] + bc[i,j] )

ad = [2]
bd = [100]
@NLexpression(model, qhat[j=1:n], sum(q[i]*Q[i,j] for i in 1:m) / ( sum(Q[i,j] for i in 1:m) + 1e-6 ) )
@mapping(model, nrho[j=1:n], ad[j] * d[j] - qhat[j] - bd[j] )

aq = [5; 10]
@mapping(model, Fq[i=1:m], aq[i] * q[i] - pi[i] )


@innerproduct(model, pi, s)
@innerproduct(model, c, Q)
@innerproduct(model, nrho, d)
@innerproduct(model, Fq, q)

for i=1:m, j=1:n
    setvalue(Q[i,j], 1.0)
end

sol1, Fval1, gap1 = solveVIP(model, algorithm=:fixed_point, max_iter=10000, step_size=0.1, tolerance=1e-10)
@assert 0<= gap1 < 1e-6

@show sol1
@show gap1

@show sol1[Q[1,1]]
@show sol1[Q[2,1]]
@show sol1[q[1]]
@show sol1[q[2]]
