"""
    prototypes(C, p=1)

Compute the prototypes of every cluster of the clustering `C` with the centroid-based method
and return their indices, one vector per cluster.
"""
function prototypes(C::Union{KmeansResult, KmedoidsResult}, p::Int = 1)
    1 <= p || throw(ArgumentError("p must satisfy 1 <= p, got p = $p"))
    return [first(sortedmembers(C, i), p) for i in 1:nclusters(C)]
end

"""
    criticisms(C, c=1)

Compute the criticisms of every cluster of the clustering `C` with the centroid-based method
and return their indices, one vector per cluster.
"""
function criticisms(C::Union{KmeansResult, KmedoidsResult}, c::Int = 1)
    1 <= c || throw(ArgumentError("c must satisfy 1 <= c, got c = $c"))
    return [first(sortedmembers(C, i, rev = true), c) for i in 1:nclusters(C)]
end

"""
    sortedmembers(C, c, rev=false)

Return the indices of the observations in cluster `c` of the clustering `C`, sorted by their
assignment costs. Observations with equal assignment costs keep the order of their indices.
"""
function sortedmembers(C::Union{KmeansResult, KmedoidsResult}, c::Int, rev::Bool = false)
    members = findall(==(c), assignments(C))
    return members[sortperm(C.costs[members], rev = rev)]
end
