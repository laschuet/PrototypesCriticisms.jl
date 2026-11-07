using KernelFunctions

@testset "dataset" begin
    @testset "mmd2" begin
        x = [1, 2, 3, 6, 7, 8]
        X = [x x .+ 1]
        k = LinearKernel()

        @test isapprox(mmd2(x, k, eachindex(x)), 0)
        @test isapprox(mmd2(X, k, eachindex(eachcol(X))), 0)

        @test mmd2(x, k, [1, 2]) == mmd2(x, k, [2, 1])

        # For a linear kernel, mmd2 is the squared distance between the means
        @test isapprox(mmd2(x, k, [1]), (4.5 - 1)^2)
        @test isapprox(mmd2(x, k, [1, 2]), (4.5 - 1.5)^2)
        @test isapprox(mmd2(x, k, [1, 6]), 0)

        @test_throws ArgumentError mmd2(x, k, Int[])
    end
end
