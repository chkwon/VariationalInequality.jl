using JuMP, VariationalInequality
# include("../src/model.jl")
# include("../src/algorithms.jl")

using Base.Test
using FactCheck




# https://cdr.lib.unc.edu/indexablecontent/uuid:778ca632-74ca-4858-8c3c-6dcfc7e6e703
# Example 4.3. This example is modified from the Suzuki Rosen problem in (Rosen and Suzuki, 1965).
A = [3.0006 0.0212 0.0141 0.0215 0.0088;
     0.0212 3.7093 0.4708 0.7193 0.2930;
     0.0141 0.4708 4.3125 0.4775 0.1945;
     0.0215 0.7193 0.4775 3.7295 0.2971;
     0.0088 0.2930 0.1945 0.2971 3.1210 ]
b = [-1.5849; 15.8236; 13.1763; 12.0172; 138.7089]

m = VIPModel()
@defVar(m, -100 <= x[1:5] <= 0)
@defNLExpr(m, F[i=1:5], sum{A[i,j]*x[j], j=1:5} - b[i] )
@addNLConstraint(m, x[1]^2 + x[2]^2 + 2x[3]^2 + x[4]^2 - 5x[1] - 5x[2] - 21x[3] + 7x[4] + x[5] <= 0 )
@addNLConstraint(m, 4x[1]^2 + 4x[2]^2 + 5x[3]^2 + 4x[4]^2 - 2x[1] - 8x[2] - 18x[3] + 4x[4] + x[5] - 24 <= 0 )
@addNLConstraint(m, 4x[1]^2 + 7x[2]^2 + 5x[3]^2 + 7x[4]^2 - 8x[1] - 5x[2] - 21x[3] + 4x[4] + x[5] - 30 <= 0 )
@addNLConstraint(m, 7x[1]^2 + 4x[2]^2 + 5x[3]^2 + x[4]^2 + x[1] - 8x[2] - 21x[3] + 4x[4] + x[5] - 15 <= 0 )

addRelation!(m, F, x)

# x0 =  [0, 1, 2, -1, 44]

sol1, Fval1, gap1 = solveVIP!(m, algorithm=:extra_gradient, max_iter=1000, step_size=0.1, tolerance=1e-10)

println(sol1)

println(gap1)

# x∗ = (0, 1, 2, −1, 44).
