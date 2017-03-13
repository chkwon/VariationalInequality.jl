# isdefined(Base, :__precompile__) && __precompile__()

module VariationalInequality

# package code goes here

using JuMP
import Ipopt



include("model.jl")
include("algorithms.jl")


export  VIPModel,
        VIPData,
        solveVIP,
        correspond,
        clearValues,
        saveSolution,
        gap_function,
        @mapping






end # module
