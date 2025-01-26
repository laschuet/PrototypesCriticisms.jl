using PrototypesCriticisms
using Test

@testset "PrototypesCriticisms.jl" begin
    @testset "clustering" begin end

    @testset "ranking" begin
        observed_ranking = [1, 2, 3, 4, 5, 6]

        @test isapprox(
            [5, 5, 5, 5, 5, 5],
            importances(observed_ranking, [1, 2, 3, 4, 5, 6]),
        )

        ranking_1 = [2, 1, 3, 4, 6, 5]
        ranking_2 = [6, 2, 5, 3, 4, 1]
        expected_importances = [52 // 21, 92 // 21, 89 // 21, 97 // 21, 4, 52 // 21]
        computed_importances = importances(observed_ranking, [ranking_1 ranking_2])
        @test isapprox(expected_importances, computed_importances)
    end
end
