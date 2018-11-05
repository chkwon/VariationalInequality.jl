# isdefined(Base, :__precompile__) && __precompile__()

module VariationalInequality

# package code goes here

using JuMP, LinearAlgebra, SparseArrays, Printf
import Ipopt



include("model.jl")
include("algorithms.jl")


export  VIPModel,
        VIPData,
        solveVIP,
        clear_values,
        save_solution,
        gap_function,
        @mapping,
        @innerproduct






end # module
