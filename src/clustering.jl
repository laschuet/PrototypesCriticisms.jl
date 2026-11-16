"""
    prototypes_criticisms(alg, C, p=1, c=1)
    prototypes_criticisms(alg, X, assignments, p=1, c=1)

Compute the `p` prototypes and the `c` criticisms of every cluster with the centroid-based
method, and return a tuple of the indices of the prototypes and the indices of the
criticisms, each with one vector per cluster.

The clusters are given by `C`, or by `X` and `assignments` as in [`prototypes`](@ref). The
prototypes are computed with [`prototypes`](@ref), and the criticisms are computed with
[`criticisms`](@ref).
"""
prototypes_criticisms(
    alg::Centroid, C::Union{KmeansResult, KmedoidsResult}, p::Int = 1, c::Int = 1
) = prototypes(alg, C, p), criticisms(alg, C, c)

prototypes_criticisms(
    alg::Centroid, X::AbstractMatrix{<:Real}, assignments::AbstractVector{<:Integer},
    p::Int = 1, c::Int = 1
) = prototypes(alg, X, assignments, p), criticisms(alg, X, assignments, c)

"""
    prototypes(alg, C, p=1)
    prototypes(alg, X, assignments, p=1)

Compute the `p` prototypes of every cluster with the centroid-based method, and return
their indices, one vector per cluster.

The clusters are those of the k-means or k-medoids clustering `C`, or given by
`assignments`, the cluster label of every observation in the data matrix `X`. In the latter
case, the clusters are ordered by increasing label.

The prototypes of a cluster are its observations closest to the cluster center, i.e., the
center of `C` or the mean of the cluster in `X`. Ties are broken in favor of the lower
index. A cluster with fewer than `p` observations contributes all of them.

See also [`criticisms`](@ref).
"""
function prototypes(::Centroid, C::Union{KmeansResult, KmedoidsResult}, p::Int = 1)
    1 <= p || throw(ArgumentError("p must satisfy 1 <= p, got p = $p"))
    return [first(sortedmembers(C, i), p) for i in 1:nclusters(C)]
end

function prototypes(
        ::Centroid, X::AbstractMatrix{<:Real}, assignments::AbstractVector{<:Integer},
        p::Int = 1
    )
    1 <= p || throw(ArgumentError("p must satisfy 1 <= p, got p = $p"))
    costs = centroidcosts(X, assignments)
    clusters = sort(unique(assignments))
    return [first(sortedmembers(assignments, costs, i), p) for i in clusters]
end

"""
    criticisms(alg, C, c=1)
    criticisms(alg, X, assignments, c=1)

Compute the `c` criticisms of every cluster with the centroid-based method, and return their
indices, one vector per cluster.

The clusters are given by `C` or by `X` and `assignments` as in [`prototypes`](@ref).

The criticisms of a cluster are its observations farthest from the cluster center, in
decreasing order. Ties are broken in favor of the lower index. A cluster with fewer than `c`
observations contributes all of them.

See also [`prototypes`](@ref).
"""
function criticisms(::Centroid, C::Union{KmeansResult, KmedoidsResult}, c::Int = 1)
    1 <= c || throw(ArgumentError("c must satisfy 1 <= c, got c = $c"))
    return [first(sortedmembers(C, i, rev = true), c) for i in 1:nclusters(C)]
end

function criticisms(
        ::Centroid, X::AbstractMatrix{<:Real}, assignments::AbstractVector{<:Integer},
        c::Int = 1,
    )
    1 <= c || throw(ArgumentError("c must satisfy 1 <= c, got c = $c"))
    costs = centroidcosts(X, assignments)
    clusters = sort(unique(assignments))
    return [first(sortedmembers(assignments, costs, i, rev = true), c) for i in clusters]
end
