"""
	prototypes_criticisms(X, p, c)

Compute prototypes and criticisms following the MMD-critic method.
"""
function prototypes_criticisms(X::AbstractMatrix{<:Real}, p::Int = 1, c::Int = 1)
    protos = prototypes(X, p)
    critics = criticisms(X, protos, c)
    return protos, critics
end

"""
	prototypes(X, p)

Compute prototypes following the MMD-critic method.
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
