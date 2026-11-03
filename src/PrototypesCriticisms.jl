module PrototypesCriticisms

using Clustering
using Distances
using KernelFunctions
using LinearAlgebra
using Statistics

export criticisms, importances, mmd2, prototypes, prototypes_criticisms

include("clustering.jl")
include("dataset.jl")
include("ranking.jl")

end
