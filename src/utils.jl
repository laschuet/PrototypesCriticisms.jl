"""
    checksymmetric(K)

Check that the matrix `K` is square and symmetric, and return the number of observations.
"""
function checksymmetric(K::AbstractMatrix{<:Real})
    n = size(K, 1)
    size(K, 2) == n || throw(DimensionMismatch("K must be square, got size $(size(K))"))
    issymmetric(K) || throw(ArgumentError("K must be symmetric"))
    return n
end

"""
    sortedmembers(C, c; rev=false)
    sortedmembers(assignments, costs, c; rev=false)

Return the indices of the observations in cluster `c`, sorted by increasing assignment
costs, or by decreasing costs if `rev` is `true`. Observations with equal costs keep the
order of their indices.

The clusters and costs are those of the clustering `C`, or given by `assignments` and
`costs` with one entry per observation.
"""
sortedmembers(C::Union{KmeansResult, KmedoidsResult}, c::Int; rev::Bool = false) =
    sortedmembers(assignments(C), C.costs, c, rev = rev)

function sortedmembers(
        assignments::AbstractVector{<:Integer},
        costs::AbstractVector{<:Real}, c::Int; rev::Bool = false
    )
    members = findall(==(c), assignments)
    return members[sortperm(costs[members], rev = rev)]
end

"""
    centroidcosts(X, assignments)

Return the squared Euclidean distance of every observation in the data matrix `X` to the
mean of its cluster in `assignments`.
"""
function centroidcosts(X::AbstractMatrix{<:Real}, assignments::AbstractVector{<:Integer})
    n = size(X, 2)
    length(assignments) == n || throw(
        DimensionMismatch("got $(length(assignments)) assignments for $n observations"),
    )
    costs = zeros(n)
    for c in unique(assignments)
        members = findall(==(c), assignments)
        centroid = vec(mean(X[:, members], dims = 2))
        costs[members] = colwise(SqEuclidean(), X[:, members], centroid)
    end
    return costs
end

"""
    clustermembers(assignments)

Return the indices of the observations of every cluster in `assignments`, one vector per
cluster, ordered by increasing "label".
"""
clustermembers(assignments::AbstractVector{<:Integer}) =
    [findall(==(c), assignments) for c in sort(unique(assignments))]
