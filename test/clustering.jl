using Clustering

@testset "clustering" begin
    C1 = KmeansResult(
        [2.0 9.0], [1, 1, 1, 2, 2, 2], [1.0, 0.0, 1.0, 1.0, 0.0, 1.0], [3, 3],
        [3, 3], 4.0, 1, true
    )
    C2 = KmedoidsResult(
        [2, 5], [1, 1, 1, 2, 2, 2], [1.0, 0.0, 1.0, 1.0, 0.0, 1.0], [3, 3],
        4.0, 1, true
    )
    X = [1 2 3 6 7 8]
    ys = [1, 1, 1, 2, 2, 2]
    alg = Centroid()

    @testset "prototypes_criticisms" begin
        @test prototypes_criticisms(alg, C1) == ([[2], [5]], [[1], [4]]) ==
            prototypes_criticisms(alg, C2)
        @test prototypes_criticisms(alg, C1, 1, 2) == ([[2], [5]], [[1, 3], [4, 6]]) ==
            prototypes_criticisms(alg, C2, 1, 2)

        @test_throws ArgumentError prototypes_criticisms(alg, C1, 0, 1)
        @test_throws ArgumentError prototypes_criticisms(alg, C1, 1, 0)

        @test prototypes_criticisms(alg, X, ys, 1) == ([[2], [5]], [[1], [4]])
        @test prototypes_criticisms(alg, X, ys, 1, 2) == ([[2], [5]], [[1, 3], [4, 6]])

        @test_throws ArgumentError prototypes_criticisms(alg, X, ys, 0, 1)
        @test_throws ArgumentError prototypes_criticisms(alg, X, ys, 1, 0)
    end

    @testset "prototypes" begin
        @test prototypes(alg, C1, 1) == [[2], [5]] == prototypes(alg, C2, 1)
        @test prototypes(alg, C1, 10) == [[2, 1, 3], [5, 4, 6]] == prototypes(alg, C2, 10)

        @test_throws ArgumentError prototypes(alg, C1, 0)
        @test_throws ArgumentError prototypes(alg, C2, 0)

        @test prototypes(alg, X, ys, 1) == [[2], [5]]
        @test prototypes(alg, X, ys, 10) == [[2, 1, 3], [5, 4, 6]]
        @test prototypes(alg, X, [5, 5, 5, 2, 2, 2], 1) == [[5], [2]]
        @test prototypes(alg, X, [-1, -1, -1, 0, 0, 0], 1) == [[2], [5]]

        @test_throws ArgumentError prototypes(alg, X, ys, 0)
    end

    @testset "criticisms" begin
        @test criticisms(alg, C1, 1) == [[1], [4]] == criticisms(alg, C2, 1)
        @test criticisms(alg, C1, 10) == [[1, 3, 2], [4, 6, 5]] == criticisms(alg, C2, 10)

        @test_throws ArgumentError criticisms(alg, C1, 0)
        @test_throws ArgumentError criticisms(alg, C2, 0)

        @test criticisms(alg, X, ys, 1) == [[1], [4]]
        @test criticisms(alg, X, ys, 10) == [[1, 3, 2], [4, 6, 5]]
        @test criticisms(alg, X, [5, 5, 5, 2, 2, 2], 1) == [[4], [1]]

        @test_throws ArgumentError criticisms(alg, X, ys, 0)
    end
end
