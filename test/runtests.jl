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
h_star = solveVIP(m)

@show h_star
