using PrototypesCriticisms
using Test

@testset "PrototypesCriticisms.jl" begin
    include("algorithms.jl")
    include("clustering.jl")
    include("dataset.jl")
    include("ranking.jl")
    include("utils.jl")
end
