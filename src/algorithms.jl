function _solve_fp(m, step_size, tolerance, max_iter)

    F = getJuVIData(m).F
    var = getJuVIData(m).var
    @assert length(F) == length(var)
    dim = length(F)

    # initialization
    xk = zeros(dim)
    # xk = [30, 50, 20]
    setValue(var, xk)
    fk = getValue(F)
    tau = step_size

    for i=1:max_iter
        @setNLObjective(m, Min, sum{ (var[i]-(xk[i]-tau*fk[i]))^2, i=1:dim} )
        solve(m)

        new_xk = getValue(var)
        new_fk = getValue(F)
        rel_err = norm(xk-new_xk) / norm(xk)

        @printf("iteration %4d: rel_err=%10.7f\n", i, rel_err)

        if  rel_err < tolerance
            break
        end

        xk = new_xk
        fk = new_fk
    end

    return xk
end
