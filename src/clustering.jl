""""""
function prototypes(C::Union{KmeansResult, KmedoidsResult}, p::Int = 1)
    1 <= p || throw(ArgumentError("p must satisfy 1 <= p, got p = $p"))
    return [first(sortedmembers(C, i), p) for i in 1:nclusters(C)]
end

""""""
function criticisms(C::Union{KmeansResult, KmedoidsResult}, c::Int = 1)
    1 <= c || throw(ArgumentError("c must satisfy 1 <= c, got c = $c"))
    return [first(sortedmembers(C, i, rev = true), c) for i in 1:nclusters(C)]
end

""""""
function sortedmembers(C::Union{KmeansResult, KmedoidsResult}, c::Int, rev::Bool = false)
    members = findall(==(c), assignments(C))
    return members[sortperm(C.costs[members], rev = rev)]
end
