using VariationalInequality
using JuMP

using Test

@testset "Nagurney Model" begin
    include(joinpath(dirname(dirname(@__FILE__)), "example", "nagurney.jl"))
end

@testset "Traffic Equilibrium" begin
    include(joinpath(dirname(dirname(@__FILE__)), "example", "traffic.jl"))
end

@testset "Fukushima1" begin
    include(joinpath(dirname(dirname(@__FILE__)), "example", "fukushima1.jl"))
end
