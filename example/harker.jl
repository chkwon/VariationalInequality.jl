# using JuMP, VariationalInequality
# using Base.Test

using JuMP, VariationalInequality
# include("../src/model.jl")
# include("../src/algorithms.jl")


# https://cdr.lib.unc.edu/indexablecontent/uuid:778ca632-74ca-4858-8c3c-6dcfc7e6e703
# Harker 1984
c = [10.0; 8; 6; 4; 2]
L = [5.0; 5; 5; 5; 5]
beta = [1.2; 1.1; 1.0; 0.9; 0.8]
s = [178.2339; 173.8586; 163.7603; 148.3378; 128.8948]

m = VIPModel()
@variable(m, q[1:5] >= 0)
@NLconstraint(m, upperbounds[i=1:5], q[i] <= s[i])

@NLexpression(m, F[i=1:5], c[i] + L[i]^(1/beta[i]) * q[i]^(1/beta[i])
                       - 5000^(1/1.1) * (sum{q[i], i=1:5})^(-1/1.1)
                       + ( 5000^(1/1.1) ) / 1.1 * q[i] * (sum{q[i], i=1:5})^(-2.1/1.1) )

correspond(m, F, q)

x0 =  [36.9120, 41.8420, 43.7050, 42.6650, 39.1820]

solveVIP(m, algorithm=:fixed_point, max_iter=1000, step_size=0.01)
sol1, Fval1, gap1 = saveSolution(m)

solveVIP(m, algorithm=:extra_gradient, max_iter=1000, step_size=0.01)
sol2, Fval2, gap2 = saveSolution(m)

@show sol1
@show sol2
@show gap1
@show gap2

# sol2, Fval2 = solveVIP(m, x0, algorithm=:extra_gradient, max_iter=1000, step_size=0.01, tolerance=1e-10)
# sol3, Fval3 = solveVIP(m, algorithm=:hyperplane, max_iter=1000, step_size=0.01, tolerance=1e-10)
# sol4, Fval4 = solveVIP(m, x0, algorithm=:hyperplane, max_iter=1000, step_size=0.01, tolerance=1e-10)
#
# println(sol1)
# println(sol2)
# println(sol3)
# println(sol4)
#
# println(Fval1)
# println(Fval2)
# println(Fval3)
# println(Fval4)

# Obtains another solution
# Something is wrong...

# q∗ = [36.9120, 41.8420, 43.7050, 42.6650, 39.1820].
