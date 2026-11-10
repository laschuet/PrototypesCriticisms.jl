"""
    prototypes(C, p=1)

Compute the `p` prototypes of every cluster of the k-means or k-medoids clustering `C` with
the centroid-based method, and return their indices, one vector per cluster.

The prototypes of a cluster are its observations closest to the cluster center, i.e., with
the lowest assignment costs. Ties are broken in favor of the lower index. A cluster with
fewer than `p` observations contributes all of them.

See also [`criticisms`](@ref).
"""
function prototypes(C::Union{KmeansResult, KmedoidsResult}, p::Int = 1)
    1 <= p || throw(ArgumentError("p must satisfy 1 <= p, got p = $p"))
    return [first(sortedmembers(C, i), p) for i in 1:nclusters(C)]
end

"""
    criticisms(C, c=1)

Compute the `c` criticisms of every cluster of the k-means or k-medoids clustering `C` with
the centroid-based method, and return their indices, one vector per cluster.

The criticisms of a cluster are its observations farthest from the cluster center, i.e.,
with the highest assignment costs, in decreasing order. Ties are broken in favor of the
lower index. A cluster with fewer than `c` observations contributes all of them.

See also [`prototypes`](@ref).
"""
function criticisms(C::Union{KmeansResult, KmedoidsResult}, c::Int = 1)
    1 <= c || throw(ArgumentError("c must satisfy 1 <= c, got c = $c"))
    return [first(sortedmembers(C, i, rev = true), c) for i in 1:nclusters(C)]
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
