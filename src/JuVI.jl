isdefined(Base, :__precompile__) && __precompile__()

module JuVI

# package code goes here

using JuMP
import Ipopt



include("model.jl")
include("algorithms.jl")


export  JuVIModel,
        JuVIData,
        solveVIP!,
        addRelation!,
        clearValues!,
        saveSolution,
        gap_function






end # module
