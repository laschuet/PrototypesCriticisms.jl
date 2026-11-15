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

    @testset "prototypes" begin
        @test prototypes(C1, 1) == [[2], [5]] == prototypes(C2, 1)
        @test prototypes(C1, 10) == [[2, 1, 3], [5, 4, 6]] == prototypes(C2, 10)

        @test_throws ArgumentError prototypes(C1, 0)
        @test_throws ArgumentError prototypes(C2, 0)

        @test prototypes(ys, X, 1) == [[2], [5]]
        @test prototypes(ys, X, 10) == [[2, 1, 3], [5, 4, 6]]
        @test prototypes([5, 5, 5, 2, 2, 2], X, 1) == [[5], [2]]
        @test prototypes([-1, -1, -1, 0, 0, 0], X, 1) == [[2], [5]]

        @test_throws ArgumentError prototypes(ys, X, 0)
    end

    @testset "criticisms" begin
        @test criticisms(C1, 1) == [[1], [4]] == criticisms(C2, 1)
        @test criticisms(C1, 10) == [[1, 3, 2], [4, 6, 5]] == criticisms(C2, 10)

        @test_throws ArgumentError criticisms(C1, 0)
        @test_throws ArgumentError criticisms(C2, 0)

        @test criticisms(ys, X, 1) == [[1], [4]]
        @test criticisms(ys, X, 10) == [[1, 3, 2], [4, 6, 5]]
        @test criticisms([5, 5, 5, 2, 2, 2], X, 1) == [[4], [1]]

        @test_throws ArgumentError criticisms(ys, X, 0)
    end
end
