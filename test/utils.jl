using PrototypesCriticisms: checksymmetric, sortedmembers
using Clustering

@testset "utils" begin
    @testset "checksymmetric" begin
        @test checksymmetric([1 2; 2 1]) == 2
        @test_throws DimensionMismatch checksymmetric(ones(2, 3))
        @test_throws ArgumentError checksymmetric([1 2; 3 4])
    end

    @testset "sortedmembers" begin
        C = KmeansResult([2.0 9.0], [1, 1, 1, 2, 2, 2], [1.0, 0.0, 1.0, 1.0, 0.0, 1.0], [3, 3], [3, 3], 4.0, 1, true)

        @test sortedmembers(C, 1) == [2, 1, 3]
        @test sortedmembers(C, 2) == [5, 4, 6]
        @test sortedmembers(C, 1, rev = true) == [1, 3, 2]
        @test sortedmembers(C, 2, rev = true) == [4, 6, 5]

        @test sortedmembers([1, 1, 1, 2, 2, 2], [1.0, 0.0, 1.0, 1.0, 0.0, 1.0], 1) == [2, 1, 3]
        @test sortedmembers([1, 1, 1, 2, 2, 2], [1.0, 0.0, 1.0, 1.0, 0.0, 1.0], 1, rev = true) == [1, 3, 2]
        @test sortedmembers([1, 1, 1, 2, 2, 2], [1.0, 0.0, 1.0, 1.0, 0.0, 1.0], 3) == []
    end
end
