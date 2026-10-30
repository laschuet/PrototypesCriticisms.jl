"""
	prototypes_criticisms(x, k, p, c)

Compute prototypes and criticisms following the MMD-critic method.

# Arguments
- `x::AbstractVector`: the observations, e.g., a vector of vectors or a vector of numbers for one-dimensional data.
- `k::Kernel`: the kernel function.
- `p::Int`: the number of prototypes to compute.
- `c::Int`: the number of criticisms to compute.
"""
prototypes_criticisms(x::AbstractVector, k::Kernel, p::Int = 1, c::Int = 1) =
    prototypes_criticisms(kernelmatrix(k, x), p, c)

"""
	prototypes_criticisms(X, k, p, c)

Compute prototypes and criticisms following the MMD-critic method.

# Arguments
- `X::AbstractMatrix{<:Real}`: the data, with one observation per column.
- `k::Kernel`: the kernel function.
- `p::Int`: the number of prototypes to compute.
- `c::Int`: the number of criticisms to compute.
"""
prototypes_criticisms(X::AbstractMatrix{<:Real}, k::Kernel, p::Int = 1, c::Int = 1) =
    prototypes_criticisms(kernelmatrix(k, X, obsdim = 2), p, c)

"""
	prototypes_criticisms(K, p, c)

Compute prototypes and criticisms following the MMD-critic method.

# Arguments
- `K::AbstractMatrix{<:Real}`: the kernel matrix.
- `p::Int`: the number of prototypes to compute.
- `c::Int`: the number of criticisms to compute.
"""
function prototypes_criticisms(K::AbstractMatrix{<:Real}, p::Int = 1, c::Int = 1)
    protos = prototypes(K, p)
    critics = criticisms(K, protos, c)
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
prototypes(x::AbstractVector, k::Kernel, p::Int = 1) = prototypes(kernelmatrix(k, x), p)

"""
	prototypes(X, k, p)

Compute prototypes following the MMD-critic method.

# Arguments
- `X::AbstractMatrix{<:Real}`: the data matrix, with one observation per column.
- `k::Kernel`: the kernel function.
- `p::Int`: the number of prototypes to compute.
"""
prototypes(X::AbstractMatrix{<:Real}, k::Kernel, p::Int = 1) = prototypes(kernelmatrix(k, X, obsdim = 2), p)

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
	criticisms(K, protos, c)

Compute criticisms following the MMD-critic method.

# Arguments
- `K::AbstractMatrix{<:Real}`: the kernel matrix.
- `protos::AbstractVector{Int}`: the prototypes.
- `c::Int`: the number of criticisms to compute.
"""
function criticisms(K::AbstractMatrix{<:Real}, protos::AbstractVector{Int}, c::Int = 1)
    initial_candidates = setdiff(1:size(K, 2), protos)
    critics = Int[]
    while length(critics) < c
        candidates = setdiff(initial_candidates, critics)
        push!(critics, candidates[1])
    end
    return critics
end
