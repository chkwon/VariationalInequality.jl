using VariationalInequality
using JuMP

using Base.Test

info("Nagurney Model")
include(joinpath(dirname(dirname(@__FILE__)), "example", "nagurney.jl"))
info("Traffic Equilibrium")
include(joinpath(dirname(dirname(@__FILE__)), "example", "traffic.jl"))
info("Fukushima1")
include(joinpath(dirname(dirname(@__FILE__)), "example", "fukushima1.jl"))
