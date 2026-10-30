"""
	prototypes_criticisms(X, k, p, c)

Compute prototypes and criticisms following the MMD-critic method.

# Arguments
- `X::AbstractMatrix{<:Real}`: the data.
- `k::Kernel`: the kernel function.
- `p::Int`: the number of prototypes to compute.
- `c::Int`: the number of criticisms to compute.
"""
function prototypes_criticisms(X::AbstractMatrix{<:Real}, k::Kernel, p::Int = 1, c::Int = 1)
    protos = prototypes(X, k, p)
    critics = criticisms(X, protos, c)
    return protos, critics
end

"""
	prototypes(X, k, p)

Compute prototypes following the MMD-critic method.

# Arguments
- `X::AbstractMatrix{<:Real}`: the data.
- `k::Kernel`: the kernel function.
- `p::Int`: the number of prototypes to compute.
"""
function prototypes(X::AbstractMatrix{<:Real}, k::Kernel, p::Int = 1)
    K = kernelmatrix(k, X, obsdim = 2)
    return prototypes(K, p)
end

"""
	prototypes(K, p)

Compute prototypes following the MMD-critic method.

# Arguments
- `K::AbstractMatrix{<:Real}`: the kernel matrix.
- `p::Int`: the number of prototypes to compute.
"""
function prototypes(K::AbstractMatrix{<:Real}, p::Int = 1)
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
