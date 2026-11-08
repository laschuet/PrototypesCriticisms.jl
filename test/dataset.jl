using KernelFunctions
using LinearAlgebra

@testset "dataset" begin
    @testset "prototypes" begin
        x = [1, 2, 3, 6, 7, 8]
        X = [x x .+ 1]
        k = LinearKernel()

        @test sort(prototypes(x, k, length(x))) == eachindex(x)
        @test sort(prototypes(X, k, size(X, 2))) == eachindex(eachcol(X))

        # Linear kernel: the first prototype is closest to the mean etc.
        @test prototypes(x, k, 1) == [3]
        @test prototypes(x, k, 2) == [3, 4]
        @test prototypes(X', k, 1) == [3]
        @test prototypes(X', k, 2) == [3, 4]

        @test_throws ArgumentError prototypes(x, k, 0)
        @test_throws ArgumentError prototypes(x, k, length(x) + 1)
    end

    @testset "criticisms" begin
        x = [1, 2, 3, 6, 7, 8]
        X = [x x .+ 1]
        k = LinearKernel()

        @test sort(criticisms(x, k, [1], length(x) - 1)) == 2:6
        @test sort(criticisms(X, k, [1], size(X, 2) - 1)) == 2:6

        @test_throws ArgumentError criticisms(x, k, Int[], 0)
        @test_throws ArgumentError criticisms(x, k, Int[], length(x) + 1)
    end

    @testset "mmd2" begin
        x = [1, 2, 3, 6, 7, 8]
        X = [x x .+ 1]
        k = LinearKernel()

        @test mmd2(x, k, eachindex(x)) ≈ 0
        @test mmd2(X, k, eachindex(eachcol(X))) ≈ 0

        @test mmd2(x, k, [1, 2]) == mmd2(x, k, [2, 1])

        # Linear kernel: squared distance between the means
        @test mmd2(x, k, [1]) ≈ (4.5 - 1)^2
        @test mmd2(x, k, [1, 2]) ≈ (4.5 - 1.5)^2
        @test mmd2(x, k, [1, 6]) ≈ 0

        @test_throws ArgumentError mmd2(x, k, Int[])
    end

    @testset "witness" begin
        x = [1, 2, 3, 6, 7, 8]
        X = [x x .+ 1]
        k = LinearKernel()

        @test witness(x, k, eachindex(x)) ≈ zero(x)
        @test witness(X, k, eachindex(eachcol(X))) ≈ zeros(size(X, 2))

        @test witness(x, k, [1, 2]) == witness(x, k, [2, 1])

        # Linear kernel: z ⋅ (mean of all observations - mean of the prototypes)
        @test witness(x, k, [1]) ≈ (4.5 - 1) * x
        @test witness(x, k, [1, 2]) ≈ (4.5 - 1.5) * x
        @test witness(x, k, [1, 6]) ≈ zero(x)
        @test witness(x, k, [1], 2) ≈ (4.5 - 1) * 2
        @test witness(X, k, [1], ones(6)) ≈ dot(ones(6), (x .+ 0.5) - x)
        @test witness(X, k, [1], x) ≈ dot(x, (x .+ 0.5) - x)

        @test_throws ArgumentError witness(x, k, Int[])
        @test_throws ArgumentError witness(x, k, Int[], 1)
    end
end
