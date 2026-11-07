using KernelFunctions

@testset "dataset" begin
    @testset "mmd2" begin
        x = [1, 2, 3, 6, 7, 8]
        X = [x x .+ 1]
        k = LinearKernel()

        @test isapprox(mmd2(x, k, eachindex(x)), 0)
        @test isapprox(mmd2(X, k, eachindex(eachcol(X))), 0)

        @test mmd2(x, k, [1, 2]) == mmd2(x, k, [2, 1])
    end
end
