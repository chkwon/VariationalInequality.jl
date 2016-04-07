function _solve_fp(m, x0, step_size, tolerance, max_iter)

    F = getJuVIData(m).F
    var = getJuVIData(m).var
    @assert length(F) == length(var)
    dim = length(F)

    # initialization
    xk = x0
    setValue(var, x0)
    fk = getValue(F)
    tau = step_size

    for i=1:max_iter
        @setNLObjective(m, Min, sum{ (var[i]-(xk[i]-tau*fk[i]))^2, i=1:dim} )
        solve(m)

        new_xk = getValue(var)
        new_fk = getValue(F)
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



# Extragradient Section 12.1.2 of Facchinei and Pang (2003)
function _solve_eg(m, x0, step_size, tolerance, max_iter)

    F = getJuVIData(m).F
    var = getJuVIData(m).var
    @assert length(F) == length(var)
    dim = length(F)

    # initialization
    xk = x0
    setValue(var, x0)
    fk = getValue(F)
    tau = step_size

    for i=1:max_iter
        @setNLObjective(m, Min, sum{ ( var[i] - (xk[i]-tau*fk[i]) )^2, i=1:dim} )
        status = solve(m)
        # @assert status == :optimal
        mid_xk = getValue(var)
        mid_fk = getValue(F)

        @setNLObjective(m, Min, sum{ ( var[i] - (xk[i]-tau*mid_fk[i]) )^2, i=1:dim} )
        status = solve(m)
        # @assert status == :optimal
        new_xk = getValue(var)
        new_fk = getValue(F)

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
