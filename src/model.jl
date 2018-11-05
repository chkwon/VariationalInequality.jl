
mutable struct VIPData
    F::Array{JuMP.NonlinearExpression,1}
    var::Array{JuMP.Variable,1}
    relation::Dict{JuMP.Variable, JuMP.NonlinearExpression}
end

function VIPModel(solver=Ipopt.IpoptSolver(print_level=0))
    m = Model(solver=solver)
    m.ext[:VIP] = VIPData(Array{JuMP.NonlinearExpression}[], Array{JuMP.Variable}[], Dict{JuMP.Variable, JuMP.NonlinearExpression}() )
    return m
end

function getVIPData(m::Model)
    if haskey(m.ext, :VIP)
        return m.ext[:VIP]::VIPData
    else
        error("The 'getVIPData' function is only for VIP models as in VariationalInequality.jl")
    end
end



@eval const $(Symbol("@mapping")) = $(Symbol("@NLexpression"))


macro innerproduct(args...)
  if length(args) != 3
    error("3 arguments are required in @innerproduct(...)")
  end

  m = esc(args[1])
  F_name = esc(args[2])
  var = esc(args[3])

  code = quote
    innerproduct($m, $F_name, $var)
  end

  return code
end




################################################################################
# correspond interface
# The most basic/important one. All other interfaces call this method.
function innerproduct(m::Model, expression::JuMP.NonlinearExpression, variable::JuMP.Variable)
    data = getVIPData(m)
    data.relation[variable] = expression
end
# Alternative
function innerproduct(m::Model, variable::JuMP.Variable, expression::JuMP.NonlinearExpression)
    innerproduct(m, expression, variable)
end


# Do we need the below?
# function correspond(m::Model, variables::Array{JuMP.Variable,1}, expressions::Array{JuMP.NonlinearExpression,1})
#     correspond(m, expressions, variables)
# end
# function correspond(m::Model, expressions::Array{JuMP.NonlinearExpression,1}, variables::Array{JuMP.Variable,1})
#     @assert length(expressions) == length(variables)
#     for i in 1:length(variables)
#         correspond(m, expressions[i], variables[i])
#     end
# end

function innerproduct(m::Model, expressions::Array{JuMP.NonlinearExpression}, variables::Array{JuMP.Variable})
    expressions = collect(expressions)
    variables = collect(variables)
    @assert length(expressions) == length(variables)
    for i in 1:length(variables)
        innerproduct(m, expressions[i], variables[i])
    end
end
function innerproduct(m::Model, variables::Array{JuMP.Variable}, expressions::Array{JuMP.NonlinearExpression})
    innerproduct(m, expressions, variables)
end

# Do we need the below?
# function correspond(m::Model, expressions::JuMP.JuMPArray, variables::JuMP.JuMPArray)
#     variables = collect(variables.innerArray)
#     expressions = collect(expressions.innerArray)
#     @assert length(expressions) == length(variables)
#     for i in 1:length(variables)
#         correspond(m, expressions[i], variables[i])
#     end
# end
################################################################################



# function setVIP(m::Model, expressions::Array{JuMP.NonlinearExpression,1}, variables::Array{JuMP.Variable,1})
#     @assert length(expressions) == length(variables)
#
#     data = getVIPData(m)
#     data.F = expressions
#     data.var = variables
#
#     return m
# end


# function solveVIP(m::Model    ; step_size=0.01,
#                                 algorithm=:fixed_point,
#                                 tolerance=1e-10,
#                                 max_iter=1000            )
#
#     F = getVIPData(m).F
#     var = getVIPData(m).var
#     @assert length(F) == length(var)
#     dim = length(F)
#
#     x0 = zeros(dim)
#
#     return solveVIP(m, x0, step_size=step_size, algorithm=algorithm, tolerance=tolerance, max_iter=max_iter)
#
# end



# Copied from JuMP.jl
# internal method that doesn't print a warning if the value is NaN
_get_value(v::JuMP.Variable) = v.m.colVal[v.col]




function clear_values(m)
    relation = getVIPData(m).relation
    for variable in keys(relation)
        setvalue(variable, NaN)
    end
end

function initial_projection(m::JuMP.Model)
    relation = getVIPData(m).relation

    initial_values = Dict{JuMP.Variable, Float64}()
    for variable in keys(relation)
        val = _get_value(variable)
        if isnan(val)
            val = 0.0
        end
        initial_values[variable] = val
    end

    @objective(m, Min, sum( ( variable - initial_values[variable] )^2 for variable in keys(relation) ) )
    status = solve(m)
    @assert status==:Optimal
end

function gap_function(m)
    relation = getVIPData(m).relation
    var = get_variables(relation)
    y = get_current_x(relation)
    Fy = get_current_F(relation)

    @objective(m, Max,
        sum( Fy[j] * ( y[j] - var[j] ) for j in 1:length(var))
    )
    solve(m)
    return getobjectivevalue(m)
end

function save_solution(m)
    relation = getVIPData(m).relation
    var = get_variables(relation)
    x = get_current_x(relation)
    F = get_current_F(relation)

    solution = Dict(zip(var, x))
    F_value = Dict(zip(var, F))
    gap = gap_function(m)

    return solution, F_value, gap
end

function solveVIP(m::Model;    step_size=0.01,
                                algorithm=:fixed_point,
                                tolerance=1e-6,
                                max_iter=1000            )

    initial_projection(m)

    if algorithm==:fixed_point
        _fixed_point(m, step_size, tolerance, max_iter)
    elseif algorithm==:extra_gradient
        _extra_gradient(m, step_size, tolerance, max_iter)
    # elseif algorithm==:hyperplane
    #     _hyperplane(m, step_size, tolerance, max_iter)
    end

    # sol, Fval, gap = save_solution(m)
    return save_solution(m)
end
