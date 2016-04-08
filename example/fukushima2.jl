# using JuMP, JuVI
# using Base.Test

using JuMP, Ipopt
include("../src/model.jl")
include("../src/algorithms.jl")

# https://cdr.lib.unc.edu/indexablecontent/uuid:778ca632-74ca-4858-8c3c-6dcfc7e6e703
# Example 4.2. This example is adapted from the example in (Fukushima, 1986). Let
m = JuVIModel()
@defVar(m, x[1:3])
@addNLConstraint(m, x[1]^2 + 0.4x[2]^2 + 0.6x[3]^2 <= 1)
@addNLConstraint(m, 0.6x[1]^2 + 0.4x[2]^2 + x[3]^2 <= 1)
@addNLConstraint(m, x[1] + x[2] + x[3] >= sqrt(3))
@defNLExpr(m, F1, 2x[1] + 0.2x[1]^3 - 0.5x[2] + 0.1x[3] - 4)
@defNLExpr(m, F2, -0.5x[1] + x[2] + 0.1x[2]^3 + 0.5)
@defNLExpr(m, F3, 0.5x[1] - 0.2x[2] + 2x[3] - 0.5)
F = [F1, F2, F3]
setVIP(m, F, x)

sol1, Fval1, gap1 = solveVIP(m, algorithm=:fixed_point, max_iter=1000, step_size=0.01, tolerance=1e-10)
sol2, Fval2, gap2 = solveVIP(m, algorithm=:hyperplane, max_iter=1000, step_size=0.01, tolerance=1e-10)

println(sol1)
println(sol2)

println(gap1)
println(gap2)
# OKAY.
# x∗ = (0.9168, 0.4850, 0.3303)
