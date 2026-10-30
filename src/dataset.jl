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
	prototypes(x, k, p)

Compute prototypes following the MMD-critic method.

# Arguments
- `x::AbstractVector`: the observations, e.g., a vector of vectors or a vector of numbers for one-dimensional data.
- `k::Kernel`: the kernel function.
- `p::Int`: the number of prototypes to compute.
"""
function prototypes(x::AbstractVector, k::Kernel, p::Int = 1)
    K = kernelmatrix(k, x)
    return prototypes(K, p)
end

"""
	prototypes(X, k, p)

Compute prototypes following the MMD-critic method.

# Arguments
- `X::AbstractMatrix{<:Real}`: the data matrix, with one observation per column.
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
- `p::Int`: the number of prototypes to compute, with `1 <= p <= size(K, 1)`.
"""
function prototypes(K::AbstractMatrix{<:Real}, p::Int = 1)
    n = size(K, 1)
    size(K, 2) == n || throw(DimensionMismatch("K must be square, got size $(size(K))"))
    issymmetric(K) || throw(ArgumentError("K must be symmetric"))
    1 <= p <= n || throw(ArgumentError("p must satisfy 1 <= p <= $n, got p = $p"))
    doubled_kernel_means = 2 * mean(K, dims = 1)
    kernel_diag = diag(K)
    initial_candidates = 1:size(K, 2)
    protos = Int[]
    while length(protos) < p
        candidates = setdiff(initial_candidates, protos)
        avgproximities1 = vec(doubled_kernel_means[candidates])
        proximities2 = vec(2 * sum(K[protos, candidates], dims = 1)) + kernel_diag[candidates]
        avgproximities2 = proximities2 / (length(protos) + 1)
        diffs = avgproximities1 - avgproximities2
        proto = candidates[argmax(diffs)]
        push!(protos, proto)
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
