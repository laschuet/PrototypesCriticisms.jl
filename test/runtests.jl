using PrototypesCriticisms
using PrototypesCriticisms: Algorithm, checksymmetric, centroidcosts, clustermembers,
    sortedmembers
using Clustering
using Distances
using KernelFunctions
using LinearAlgebra
using Random
using Test

Random.seed!(42)

@testset "PrototypesCriticisms.jl" begin
    include("algorithms.jl")
    include("clustering.jl")
    include("dataset.jl")
    include("ranking.jl")
    include("utils.jl")
end
