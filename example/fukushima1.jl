using VariationalInequality
using JuMP
using Test

# https://cdr.lib.unc.edu/indexablecontent/uuid:778ca632-74ca-4858-8c3c-6dcfc7e6e703
# Example 3.8. This example is used for testing the RPM in (Fukushima, 1986).
m = VIPModel()

@variable(m, x1)
@variable(m, x2)
@variable(m, x3)

@NLconstraint(m, const1, x1^2 + 0.4x2^2 + 0.6x3^2 <= 1)

@mapping(m, F1, 2x1 + 0.2x1^3 - 0.5x2 + 0.1x3 - 4)
@mapping(m, F2, -0.5x1 + x2 + 0.1x2^3 + 0.5)
@mapping(m, F3, 0.5x1 - 0.2x2 + 2x3 - 0.5)

@innerproduct(m, [F1, F2, F3], [x1, x2, x3])

sol1, Fval1, gap1 = solveVIP(m, algorithm=:fixed_point, max_iter=1000, step_size=0.1)
@assert 0<= gap1 < 1e-6

# The above `solveVIP` sets the value of variables at the solution
clear_values(m)

sol2, Fval2, gap2 = solveVIP(m, algorithm=:extra_gradient, max_iter=1000, step_size=0.1)
@assert 0<= gap2 < 1e-6

# sol2, Fval2, gap2 = solveVIP(m, algorithm=:hyperplane, max_iter=1000, step_size=0.1)

@show sol1
@show sol2
@show gap1
@show gap2

println("x1 = ", sol1[x1] )
println("x2 = ", sol1[x2] )
println("x3 = ", sol1[x3] )

@test isapprox(sol1[x1], 1; atol=1e-5)
@test isapprox(sol1[x2], 0; atol=1e-5)
@test isapprox(sol1[x3], 0; atol=1e-5)
