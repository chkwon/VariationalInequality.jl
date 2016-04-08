# using JuMP, JuVI
# using Base.Test

using JuMP, Ipopt
include("../src/model.jl")
include("../src/algorithms.jl")

# https://cdr.lib.unc.edu/indexablecontent/uuid:778ca632-74ca-4858-8c3c-6dcfc7e6e703
# Example 3.8. This example is used for testing the RPM in (Fukushima, 1986).
m = JuVIModel()

@defVar(m, x1)
@defVar(m, x2)
@defVar(m, x3)

@addNLConstraint(m, x1^2 + 0.4x2^2 + 0.6x3^2 <= 1)

@defNLExpr(m, F1, 2x1 + 0.2x1^3 - 0.5x2 + 0.1x3 - 4)
@defNLExpr(m, F2, -0.5x1 + x2 + 0.1x2^3 + 0.5)
@defNLExpr(m, F3, 0.5x1 - 0.2x2 + 2x3 - 0.5)

setVIP(m, [F1, F2, F3], [x1, x2, x3])

sol0, Fval0, gap0 = solveVIP(m, algorithm=:fixed_point, max_iter=1000, step_size=0.1)
sol1, Fval1, gap1 = solveVIP(m, algorithm=:extra_gradient, max_iter=1000, step_size=0.1)
sol2, Fval2, gap2 = solveVIP(m, algorithm=:hyperplane, max_iter=1000, step_size=0.1)

println(sol0)
println(sol1)
println(sol2)

println(gap0)
println(gap1)
println(gap2)
# (1, 0, 0)
