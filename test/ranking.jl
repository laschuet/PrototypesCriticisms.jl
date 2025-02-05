using Random

Random.seed!(42)

@testset "ranking" begin
    observed_ranking = [11, 22, 33, 44, 55, 66]
    ranking_1 = [22, 11, 33, 44, 66, 55]
    ranking_2 = [66, 22, 44, 55, 33, 11]

    @testset "importances" begin
        expected_importances = [52 // 21, 92 // 21, 89 // 21, 97 // 21, 84 // 21, 52 // 21]
        computed_importances = importances(observed_ranking, [ranking_1 ranking_2])
        @test isapprox(expected_importances, computed_importances)
        computed_importances = importances(observed_ranking, [ranking_1, ranking_2])
        @test isapprox(expected_importances, computed_importances)

        expected_importances = [5, 5, 5, 5, 5, 5]
        computed_importances = importances(observed_ranking, observed_ranking)
        @test isapprox(expected_importances, computed_importances)
    end

    @testset "prototypes_criticisms via importances" begin
        prototypes, criticisms =
            prototypes_criticisms(observed_ranking, [ranking_1 ranking_2], 2, 2)
        @test prototypes == [44, 22]
        @test criticisms == [11, 66]

        @test prototypes_criticisms(observed_ranking, [ranking_1, ranking_2], 2, 2) ==
              prototypes_criticisms(observed_ranking, [ranking_1 ranking_2], 2, 2)

        @test_throws ArgumentError prototypes_criticisms(
            observed_ranking,
            [ranking_1, ranking_2],
            length(observed_ranking),
            1,
        )
    end

    @testset "prototypes_criticisms via clusterings" begin
        observed_ranking = [5, 4, 1, 2, 6, 11, 7, 8, 16, 13, 14, 12]
        D = [2 2 2 2 3 3 3 3 5 5 5 5 7 7 7 7]
        k = 2
        prototypes, criticisms, clustering = prototypes_criticisms(observed_ranking, D, k)
        @test length(clustering.medoids) == k
        @test length(clustering.assignments) == length(observed_ranking)
        @test length(prototypes) == k
        @test length(criticisms) == k
        @test intersect(prototypes, criticisms) == []
        @test length(intersect(prototypes, observed_ranking)) > 0
        @test length(intersect(criticisms, observed_ranking)) > 0
        @test prototypes == [5, 16]
        @test criticisms == [12, 14]

        @test_throws ArgumentError prototypes_criticisms([1, 2, 3, 4], [1 2 3], 3)
        @test_throws ErrorException prototypes_criticisms([1, 2, 3], [1 2 3], 3)
    end
end
