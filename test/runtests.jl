using JuMP, JuVI
using Base.Test

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
solution = solveVIP(m, algorithm=:extra_gradient, max_iter=100, step_size=0.01)

@show solution


# Test 2

# m = JuVIModel()
#
# @defVar(m, q_s)
# @defVar(m, q_s_hat)
# @defVar(m, q_d)
# @defVar(m, q_d_hat)
#
# @addNLConstraint(m, q_s - q_d == 0)
# @addNLConstraint(m, q_s_hat - q_d_hat == 0)
#
# @defNLExpr(m, F1, 0.5 + 0.0001 * q_s)
# @defNLExpr(m, F2, 23/70 + 1/70000 * q_s_hat)
# @defNLExpr(m, F3, -2.7984 + 0.0000172 * q_d + 0.00000645 * q_d_hat)
# @defNLExpr(m, F4, -2.2262 + 0.00000239 * q_d + 0.0000287 * q_d_hat)
#
# setVIP(m, [F1, F2, F3, F4], [q_s, q_s_hat, q_d, q_d_hat])
# solution = solveVIP(m, algorithm=:extra_gradient, max_iter=100, step_size=0.01)
#
# println(getValue(q_s))
# println(getValue(q_s_hat))
# println(getValue(q_d))
# println(getValue(q_d_hat))

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
solution = solveVIP(m, algorithm=:extra_gradient, max_iter=1000, step_size=0.1)
println(solution)

# https://cdr.lib.unc.edu/indexablecontent/uuid:778ca632-74ca-4858-8c3c-6dcfc7e6e703
# Example 3.9. I created this simple two dimenional example for testing.
m = JuVIModel()

@defVar(m, x[1:2])

@addNLConstraint(m, x[1]^2 + x[2]^2 <= 1)

@defNLExpr(m, F1, 3x[1] + x[2] - 5)
@defNLExpr(m, F2, 2x[1] + 5x[2] - 3)
F = [F1, F2]
setVIP(m, F, x)
solution = solveVIP(m, algorithm=:extra_gradient, max_iter=1000, step_size=0.1)
println(solution)


# Test
c = [10; 8; 6; 4; 2]
L = [5; 5; 5; 5; 5]
beta = [1.2; 1.1; 1.0; 0.9; 0.8]
s = [178.2339; 173.8586; 163.7603; 148.3378; 128.8948]

m = JuVIModel()
@defVar(m, q[1:5] >= 0)
@addNLConstraint(m, xyconstr[i=1:5], q[i] <= s[i])

@defNLExpr(m, F[i=1:5], c[i] + L[i]^(1/beta[i]) * q[i]^(1/beta[i])
                       - 5000^(1/1.1) * (sum{q[i], i=1:5})^(-1/1.1)
                       + 5000^(1/1.1) / 1.1 * q[i] * (sum{q[i], i=1:5})^(-2.1/1.1) )

setVIP(m, F, q)
# x0 =  [36.9120, 41.8420, 43.7050, 42.6650, 39.1820]
solution, FF = solveVIP(m, algorithm=:fixed_point, max_iter=1000, step_size=0.01, tolerance=1e-10)
# solution, FF = solveVIP(m, x0, algorithm=:extra_gradient, max_iter=1000, step_size=0.01, tolerance=1e-10)
println(solution)
print(FF)
# Obtains an alternative solution

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
solution, FF = solveVIP(m, algorithm=:fixed_point, max_iter=1000, step_size=0.01, tolerance=1e-10)
println(solution)
print(FF)
# OKAY.


# # Example 4.3. This example is modified from the Suzuki Rosen problem in (Rosen and Suzuki, 1965).
# A = [3.0006 0.0212 0.0141 0.0215 0.0088;
#      0.0212 3.7093 0.4708 0.7193 0.2930;
#      0.0141 0.4708 4.3125 0.4775 0.1945;
#      0.0215 0.7193 0.4775 3.7295 0.2971;
#      0.0088 0.2930 0.1945 0.2971 3.1210 ]
# b = [-1.5849; 15.8236; 13.1763; 12.0172; 138.7089]
#
# m = JuVIModel()
# @defVar(m, -100 <= x[1:5] <= 0)
# @defNLExpr(m, F[i=1:5], sum{A[i,j]*x[j], j=1:5} - b[i] )
# @addNLConstraint(m, x[1]^2 + x[2]^2 + 2x[3]^2 + x[4]^2 - 5x[1] - 5x[2] - 21x[3] + 7x[4] + x[5] <= 0 )
# @addNLConstraint(m, 4x[1]^2 + 4x[2]^2 + 5x[3]^2 + 4x[4]^2 - 2x[1] - 8x[2] - 18x[3] + 4x[4] + x[5] - 24 <= 0 )
# @addNLConstraint(m, 4x[1]^2 + 7x[2]^2 + 5x[3]^2 + 7x[4]^2 - 8x[1] - 5x[2] - 21x[3] + 4x[4] + x[5] - 30 <= 0 )
# @addNLConstraint(m, 7x[1]^2 + 4x[2]^2 + 5x[3]^2 + x[4]^2 + x[1] - 8x[2] - 21x[3] + 4x[4] + x[5] - 15 <= 0 )
# setVIP(m, F, x)
# x0 =  [0, 1, 2, -1, 44]
# solution, FF = solveVIP(m, x0, algorithm=:extra_gradient, max_iter=1000, step_size=0.001, tolerance=1e-10)
# println(solution)
