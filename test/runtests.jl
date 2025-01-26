using PrototypesCriticisms
using Test

@testset "PrototypesCriticisms.jl" begin
    include("clustering.jl")
    include("dataset.jl")
    include("ranking.jl")
end
