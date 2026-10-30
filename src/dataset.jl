"""
    prototypes_criticisms(x, k, p, c)
    prototypes_criticisms(X, k, p, c)
    prototypes_criticisms(K, p, c)

Compute prototypes and criticisms following the MMD-critic method.

The data can be given in the following forms:
- `x::AbstractVector`: a vector of observations, e.g., a vector of vectors or a vector of numbers for one-dimensional data.
- `X::AbstractMatrix{<:Real}`: a data matrix, with one observation per column.
- `K::AbstractMatrix{<:Real}`: a precomputed kernel matrix.

For `x` and `X`, the kernel matrix is computed with the kernel function `k`.

The numbers of prototypes `p` and criticisms `c` are passed on to [`prototypes`](@ref) and [`criticisms`](@ref).
"""
function prototypes_criticisms end

prototypes_criticisms(x::AbstractVector, k::Kernel, p::Int = 1, c::Int = 1) =
    prototypes_criticisms(kernelmatrix(k, x), p, c)

prototypes_criticisms(X::AbstractMatrix{<:Real}, k::Kernel, p::Int = 1, c::Int = 1) =
    prototypes_criticisms(kernelmatrix(k, X, obsdim = 2), p, c)

function prototypes_criticisms(K::AbstractMatrix{<:Real}, p::Int = 1, c::Int = 1)
    protos = prototypes(K, p)
    critics = criticisms(K, protos, c)
    return protos, critics
end

"""
    prototypes(x, k, p)
    prototypes(X, k, p)
    prototypes(K, p)

Compute prototypes following the MMD-critic method.

The data `x`, `X`, or `K` and the kernel `k` are as in [`prototypes_criticisms`](@ref).

The remaining argument is:
- `p::Int`: the number of prototypes to compute, with `1 <= p <= n` for `n` observations.

See also [`criticisms`](@ref)."""
function prototypes end

prototypes(x::AbstractVector, k::Kernel, p::Int = 1) = prototypes(kernelmatrix(k, x), p)

prototypes(X::AbstractMatrix{<:Real}, k::Kernel, p::Int = 1) = prototypes(kernelmatrix(k, X, obsdim = 2), p)

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
    criticisms(x, k, protos, c)
    criticisms(X, k, protos, c)
    criticisms(K, protos, c)

Compute criticisms following the MMD-critic method.

The data `x`, `X`, or `K` and the kernel `k` are as in [`prototypes_criticisms`](@ref).

The remaining arguments are:
- `protos::AbstractVector{Int}`: the prototypes, e.g., as returned by [`prototypes`](@ref).
- `c::Int`: the number of criticisms to compute.
"""
function criticisms end

function criticisms(x::AbstractVector, k::Kernel, protos::AbstractVector{Int}, c::Int = 1)
    K = kernelmatrix(k, x)
    return criticisms(K, protos, c)
end

function criticisms(X::AbstractMatrix{<:Real}, k::Kernel, protos::AbstractVector{Int}, c::Int = 1)
    K = kernelmatrix(k, X, obsdim = 2)
    return criticisms(K, protos, c)
end

function criticisms(K::AbstractMatrix{<:Real}, protos::AbstractVector{Int}, c::Int = 1)
    initial_candidates = setdiff(1:size(K, 2), protos)
    critics = Int[]
    while length(critics) < c
        candidates = setdiff(initial_candidates, critics)
        push!(critics, candidates[1])
    end
    return critics
end
