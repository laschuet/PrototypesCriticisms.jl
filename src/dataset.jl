"""
    prototypes_criticisms(x, k, p=1, c=1)
    prototypes_criticisms(X, k, p=1, c=1)
    prototypes_criticisms(K, p=1, c=1)

Compute prototypes and criticisms following the MMD-critic method and return
a tuple of the indices of the prototypes and the indices of the criticisms.

The data can be given in the following forms:
- `x::AbstractVector`: a vector of observations, e.g., a vector of vectors or a vector of numbers for one-dimensional data.
- `X::AbstractMatrix{<:Real}`: a data matrix, with one observation per column.
- `K::AbstractMatrix{<:Real}`: a precomputed kernel matrix. Only squareness and symmetry are checked.

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
    prototypes(x, k, p=1)
    prototypes(X, k, p=1)
    prototypes(K, p=1)

Compute prototypes following the MMD-critic method and return their indices.

The data `x`, `X`, or `K` and the kernel `k` are as in [`prototypes_criticisms`](@ref).

The remaining argument is:
- `p::Int`: the number of prototypes to compute, with `1 <= p <= n` for `n` observations.

See also [`criticisms`](@ref).
"""
function prototypes end

prototypes(x::AbstractVector, k::Kernel, p::Int = 1) = prototypes(kernelmatrix(k, x), p)

prototypes(X::AbstractMatrix{<:Real}, k::Kernel, p::Int = 1) = prototypes(kernelmatrix(k, X, obsdim = 2), p)

function prototypes(K::AbstractMatrix{<:Real}, p::Int = 1)
    n = check_kernelmatrix(K)
    1 <= p <= n || throw(ArgumentError("p must satisfy 1 <= p <= $n, got p = $p"))
    doubled_kernel_means = 2 * mean(K, dims = 1)
    kernel_diag = diag(K)
    initial_candidates = 1:n
    protos_proximities = zeros(eltype(K), n)
    protos = Int[]
    while length(protos) < p
        candidates = setdiff(initial_candidates, protos)
        avgproximities1 = vec(doubled_kernel_means[candidates])
        proximities2 = 2 * protos_proximities[candidates] + kernel_diag[candidates]
        avgproximities2 = proximities2 / (length(protos) + 1)
        diffs = avgproximities1 - avgproximities2
        proto = candidates[argmax(diffs)]
        push!(protos, proto)
        protos_proximities += K[:, proto]
    end
    return protos
end

"""
    criticisms(x, k, protos, c=1)
    criticisms(X, k, protos, c=1)
    criticisms(K, protos, c=1)

Compute criticisms following the MMD-critic method and return their indices.

The data `x`, `X`, or `K` and the kernel `k` are as in [`prototypes_criticisms`](@ref).

The remaining arguments are:
- `protos::AbstractVector{Int}`: the prototypes, e.g., as returned by [`prototypes`](@ref).
- `c::Int`: the number of criticisms to compute.
"""
function criticisms end

criticisms(x::AbstractVector, k::Kernel, protos::AbstractVector{Int}, c::Int = 1) =
    criticisms(kernelmatrix(k, x), protos, c)

criticisms(X::AbstractMatrix{<:Real}, k::Kernel, protos::AbstractVector{Int}, c::Int = 1) =
    criticisms(kernelmatrix(k, X, obsdim = 2), protos, c)

function criticisms(K::AbstractMatrix{<:Real}, protos::AbstractVector{Int}, c::Int = 1)
    n = check_kernelmatrix(K)
    initial_candidates = setdiff(1:n, protos)
    critics = Int[]
    while length(critics) < c
        candidates = setdiff(initial_candidates, critics)
        push!(critics, candidates[1])
    end
    return critics
end

"""
    mmd2(K::AbstractMatrix{<:Real}, protos::AbstractVector{Int})

Compute the squared maximum mean discrepancy (MMD).
"""
function mmd2(K::AbstractMatrix{<:Real}, protos::AbstractVector{Int})
    n = check_kernelmatrix(K)
    p = length(protos)
    return sum(K) / (n * n) - 2 * sum(K[:, protos]) / (n * p) + sum(K[protos, protos]) / (p * p)
end

"""
	check_kernelmatrix(K)

Check that the matrix `K` is square and symmetric, and return the number
of observations.
"""
function check_kernelmatrix(K::AbstractMatrix{<:Real})
    n = size(K, 1)
    size(K, 2) == n || throw(DimensionMismatch("K must be square, got size $(size(K))"))
    issymmetric(K) || throw(ArgumentError("K must be symmetric"))
    return n
end
