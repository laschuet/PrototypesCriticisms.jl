module PrototypesCriticisms

using Clustering
using Distances
using KernelFunctions
using Statistics

export importances, prototypes_criticisms

include("dataset.jl")
include("clustering.jl")
include("ranking.jl")

end
