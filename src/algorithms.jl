"""
    Algorithm

Supertype of the methods for computing prototypes and criticisms.
"""
abstract type Algorithm end

"""
    MMDCritic(k=SqExponentialKernel())
    MMDCritic(nothing)

The MMD-critic method with the kernel function `k`.

With `nothing`, the data passed along is taken as a precomputed kernel matrix.
"""
struct MMDCritic{K <: Union{Kernel, Nothing}} <: Algorithm
    k::K
end

MMDCritic() = MMDCritic(SqExponentialKernel())

"""
    Centroid()

The centroid-based method.

It ranks the observations of a cluster by their distance to the cluster center.
"""
struct Centroid <: Algorithm end
