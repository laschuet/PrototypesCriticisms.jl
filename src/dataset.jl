"""
	prototypes_criticisms(X, p, c)

Compute prototypes and criticisms following the MMD-critic method.

# Arguments
- `X::AbstractMatrix{<:Real}`: the data.
- `p::Int`: the number of prototypes to compute.
- `c::Int`: the number of criticisms to compute.
"""
function prototypes_criticisms(X::AbstractMatrix{<:Real}, p::Int = 1, c::Int = 1)
    protos = prototypes(X, p)
    critics = criticisms(X, protos, c)
    return protos, critics
end

"""
	prototypes(X, p)

Compute prototypes following the MMD-critic method.

# Arguments
- `X::AbstractMatrix{<:Real}`: the data.
- `p::Int`: the number of prototypes to compute.
"""
function prototypes(X::AbstractMatrix{<:Real}, p::Int = 1)
    protos = Int[]
    while length(protos) < p
        push!(protos, length(protos) + 1)
    end
    return protos
end

"""
	criticisms(X, protos, c)

Compute criticisms following the MMD-critic method.

# Arguments
- `X::AbstractMatrix{<:Real}`: the data.
- `protos::AbstractVector{Int}`: the prototypes.
- `c::Int`: the number of criticisms to compute.
"""
function criticisms(X::AbstractMatrix{<:Real}, protos::AbstractVector{Int}, c::Int = 1)
    initial_candidates = setdiff(1:size(X, 2), protos)
    critics = Int[]
    while length(critics) < c
        candidates = setdiff(initial_candidates, critics)
        push!(critics, candidates[1])
    end
    return critics
end
