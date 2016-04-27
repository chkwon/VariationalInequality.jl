# functions that return arrays
getCurrentX(relation) = getValue(collect(keys(relation)))
getCurrentF(relation) = getValue(collect(values(relation)))
getVariables(relation) = collect(keys(relation))

# function createSolutionDict(m::Model)
#     relation = getVIPData(m).relation
#
#     sol_dict = Dict()
#     for variable in keys(relation)
#         xstar = getValue(variable)
#         Fstar = getValue(relation[variable])
#         sol_dict[variable] = getValue(variable)
#     end
#
#     return sol_dict
# end

function _fixed_point!(m, step_size, tolerance, max_iter)
    relation = getVIPData(m).relation

    # initialization
    var = getVariables(relation)
    xk = getCurrentX(relation)
    fk = getCurrentF(relation)
    tau = step_size

    for i=1:max_iter
        @setNLObjective(m, Min,
            sum{ ( var[j] - (xk[j]-tau*fk[j]) )^2, j=1:length(var)}
        )

        solve(m)

        new_xk = getCurrentX(relation)
        new_fk = getCurrentF(relation)
        rel_err = norm(xk-new_xk)  #/ norm(xk)

        @printf("iteration %4d: rel_err=%15.12f\n", i, rel_err)

        if  rel_err < tolerance
            break
        end

        xk = new_xk
        fk = new_fk
    end

    return xk, fk
end



# Extragradient Section 12.1.2 of Facchinei and Pang (2003)
function _extra_gradient!(m, step_size, tolerance, max_iter)
    relation = getVIPData(m).relation

    # initialization
    var = getVariables(relation)
    xk = getCurrentX(relation)
    fk = getCurrentF(relation)
    tau = step_size

    for i=1:max_iter
        @setNLObjective(m, Min,
            sum{ ( var[j] - (xk[j]-tau*fk[j]) )^2, j=1:length(var)}
        )
        status = solve(m)
        mid_fk = getCurrentF(relation)

        @setNLObjective(m, Min,
            sum{ ( var[j] - (xk[j]-tau*mid_fk[j]) )^2, j=1:length(var)}
        )
        status = solve(m)

        new_xk = getCurrentX(relation)
        new_fk = getCurrentF(relation)
        rel_err = norm(xk-new_xk) / norm(xk)

        @printf("iteration %4d: rel_err=%15.12f\n", i, rel_err)

        if  rel_err < tolerance
            break
        end

        xk = new_xk
        fk = new_fk
    end

    return xk, fk
end




# # Hyperplane Projection Algorithm Section 12.1.3 of Facchinei and Pang (2003)
# function _hyperplane!(m, x0, step_size, tolerance, max_iter)
#
#     F = getVIPData(m).F
#     var = getVIPData(m).var
#     @assert length(F) == length(var)
#     dim = length(F)
#
#     # initialization
#     xk = x0
#     setValue(var, x0)
#     fk = getValue(F)
#     tau = step_size
#     sigma = 0.5
#
#     for k=1:max_iter
#
#         # yk = P_X ( xk - tau F(xk) )
#         @setNLObjective(m, Min, sum{ ( var[i] - (xk[i]-tau*fk[i]) )^2, i=1:dim} )
#         status = solve(m)
#         yk = getValue(var)
#
#         # find the smallest nonnegative integer i such that...
#         # F(2^(-i)yk + (1-2^(-i))xk) ^T (xk - yk) >= sigma / tau || xk - yk ||^2
#         ik = Inf
#         for i=0:10000
#             # println("------------------------")
#             # println("i=", i)
#             # println("var=", 2.0^(-i)*yk + (1-2.0^(-i))*xk)
#
#             setValue(var, 2.0^(-i)*yk + (1-2.0^(-i))*xk)
#             FF = getValue(F)
#
#             # println("FF=", FF)
#             # println("dot(FF, xk-yk)=", dot(FF, xk-yk))
#             # println("sigma / tau * dot(xk-yk, xk-yk)=", sigma / tau * dot(xk-yk, xk-yk))
#
#             if dot(FF, xk-yk) >= sigma / tau * dot(xk-yk, xk-yk)
#                 ik = i
#                 break
#             end
#         end
#
#         zk = 2.0^(-ik) * yk + (1-2.0^(-ik)) * xk
#         setValue(var, zk)
#         Fzk = getValue(F)
#
#         wk = xk - dot(Fzk, xk-zk) / dot(Fzk, Fzk) * Fzk
#
#         @setNLObjective(m, Min, sum{ ( var[i] - wk[i] )^2, i=1:dim} )
#         status = solve(m)
#         new_xk = getValue(var)
#         new_fk = getValue(F)
#
#         rel_err = norm(xk-new_xk) / norm(xk)
#
#         @printf("iteration %4d: rel_err=%15.12f\n", k, rel_err)
#
#         if  rel_err < tolerance
#             break
#         end
#
#         xk = new_xk
#         fk = new_fk
#     end
#
#     return xk, fk
# end
