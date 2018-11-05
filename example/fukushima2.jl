using JuMP, VariationalInequality

# https://cdr.lib.unc.edu/indexablecontent/uuid:778ca632-74ca-4858-8c3c-6dcfc7e6e703
# Example 4.2. This example is adapted from the example in (Fukushima, 1986). Let
m = VIPModel()
@variable(m, x[1:3])

@constraint(m, x[1]^2 + 0.4x[2]^2 + 0.6x[3]^2 <= 1)
@constraint(m, 0.6x[1]^2 + 0.4x[2]^2 + x[3]^2 <= 1)
@constraint(m, x[1] + x[2] + x[3] >= sqrt(3))

@mapping(m, F1, 2x[1] + 0.2x[1]^3 - 0.5x[2] + 0.1x[3] - 4)
@mapping(m, F2, -0.5x[1] + x[2] + 0.1x[2]^3 + 0.5)
@mapping(m, F3, 0.5x[1] - 0.2x[2] + 2x[3] - 0.5)

@innerproduct(m, F1, x[1])
@innerproduct(m, F2, x[2])
@innerproduct(m, F3, x[3])
# or
# @innerproduct(m, [F1, F2, F3], x)


solveVIP(m, algorithm=:fixed_point, max_iter=1000, step_size=0.1)
sol1, Fval1, gap1 = save_solution(m)
@assert 0<= gap1 < 1e-6

# The above `solveVIP` sets the value of variables at the solution
clear_values(m)

solveVIP(m, algorithm=:extra_gradient, max_iter=1000, step_size=0.1)
sol2, Fval2, gap2 = save_solution(m)
@assert 0<= gap2 < 1e-6

# sol2, Fval2, gap2 = solveVIP(m, algorithm=:hyperplane, max_iter=1000, step_size=0.1)

@show sol1
@show sol2
@show gap1
@show gap2



# OKAY.
# x∗ = (0.9168, 0.4850, 0.3303)
