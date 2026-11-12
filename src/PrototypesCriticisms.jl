module PrototypesCriticisms

using Clustering
using Distances
using KernelFunctions
using LinearAlgebra
using Statistics

export criticisms, importances, mmd2, prototypes, prototypes_criticisms, witness

include("clustering.jl")
include("dataset.jl")
include("ranking.jl")
include("utils.jl")

end
