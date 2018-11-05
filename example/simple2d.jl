using JuMP, VariationalInequality
using Test




# https://cdr.lib.unc.edu/indexablecontent/uuid:778ca632-74ca-4858-8c3c-6dcfc7e6e703
# Example 3.9. I created this simple two dimenional example for testing.
m = VIPModel()

@variable(m, x[1:2])

@constraint(m, x[1]^2 + x[2]^2 <= 1)

@mapping(m, F1, 3x[1] + x[2] - 5)
@mapping(m, F2, 2x[1] + 5x[2] - 3)

F = [F1, F2]
@innerproduct(m, F, x)

sol1, Fval1, gap1 = solveVIP(m, algorithm=:extra_gradient, max_iter=1000, step_size=0.1)

@show sol1
@show Fval1
@show gap1



# (0.9890, 0.1480)
