"""
    prototypes(C, p=1)
    prototypes(assignments, X, p=1)

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
function prototypes(C::Union{KmeansResult, KmedoidsResult}, p::Int = 1)
    1 <= p || throw(ArgumentError("p must satisfy 1 <= p, got p = $p"))
    return [first(sortedmembers(C, i), p) for i in 1:nclusters(C)]
end

function prototypes(
        assignments::AbstractVector{<:Integer}, X::AbstractMatrix{<:Real}, p::Int = 1
    )
    1 <= p || throw(ArgumentError("p must satisfy 1 <= p, got p = $p"))
    costs = centroidcosts(assignments, X)
    clusters = sort(unique(assignments))
    return [first(sortedmembers(assignments, costs, i), p) for i in clusters]
end

"""
    criticisms(C, c=1)
    criticisms(assignments, X, c=1)

Compute the `c` criticisms of every cluster with the centroid-based method, and return their
indices, one vector per cluster.

The clusters are given by `C` or by `assignments` and `X` as in [`prototypes`](@ref).

The criticisms of a cluster are its observations farthest from the cluster center, in
decreasing order. Ties are broken in favor of the lower index. A cluster with fewer than `c`
observations contributes all of them.

See also [`prototypes`](@ref).
"""
function criticisms(C::Union{KmeansResult, KmedoidsResult}, c::Int = 1)
    1 <= c || throw(ArgumentError("c must satisfy 1 <= c, got c = $c"))
    return [first(sortedmembers(C, i, rev = true), c) for i in 1:nclusters(C)]
end

function criticisms(
        assignments::AbstractVector{<:Integer}, X::AbstractMatrix{<:Real}, c::Int = 1,
    )
    1 <= c || throw(ArgumentError("c must satisfy 1 <= c, got c = $c"))
    costs = centroidcosts(assignments, X)
    clusters = sort(unique(assignments))
    return [first(sortedmembers(assignments, costs, i, rev = true), c) for i in clusters]
end
