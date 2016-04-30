
using JuMP
import MathProgBase




m = Model()
@defVar(m, x1)
@addNLConstraint(m, cons1, x1^2 <= 1)
@addNLConstraint(m, cons2, x1^2 >= 2)
@addNLConstraint(m, cons2, x1^2 == 2)
z = [1.0]

d = JuMPNLPEvaluator(m)
MathProgBase.initialize(d, [:Grad])

g_val= zeros(3)
MathProgBase.eval_g(d, g_val, z)
@show g_val

I,J = MathProgBase.jac_structure(d)
jac_val = zeros(size(J))
MathProgBase.eval_jac_g(d, jac_val, z)
jac = full(sparse(I, J, jac_val))
@show jac

lb_consts, ub_consts = JuMP.getConstraintBounds(m)

println("----")
