using PrototypesCriticisms: checksymmetric

@testset "checksymmetric" begin
    @test checksymmetric([1 2; 2 1]) == 2
    @test_throws DimensionMismatch checksymmetric(ones(2, 3))
    @test_throws ArgumentError checksymmetric([1 2; 3 4])
end
