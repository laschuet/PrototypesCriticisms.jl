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

Return the indices of the observations in cluster `c` of the clustering `C`, sorted by
increasing assignment costs, or by decreasing costs if `rev` is `true`. Observations with
equal costs keep the order of their indices.
"""
function sortedmembers(C::Union{KmeansResult, KmedoidsResult}, c::Int; rev::Bool = false)
    members = findall(==(c), assignments(C))
    return members[sortperm(C.costs[members], rev = rev)]
end
