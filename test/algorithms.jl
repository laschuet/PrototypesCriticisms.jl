@testset "algorithms" begin
    @testset "MMDCritic" begin
        @test MMDCritic() isa Algorithm
        @test MMDCritic().k isa SqExponentialKernel
        @test MMDCritic(LinearKernel()).k isa LinearKernel
        @test MMDCritic(nothing).k === nothing
    end

    @testset "Centroid" begin
        @test Centroid() isa Algorithm
    end
end
