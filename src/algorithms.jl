"""
    Algorithm

Supertype of the methods for computing prototypes and criticisms.
"""
abstract type Algorithm end

"""
    MMDCritic(k=SqExponentialKernel())
    MMDCritic(nothing)

The MMD-critic method with the kernel function `k`.
"""
struct MMDCritic{K <: Union{Kernel, Nothing}} <: Algorithm
    k::K
end

MMDCritic() = MMDCritic(SqExponentialKernel())

"""
    Centroid()

The centroid-based method.
"""
struct Centroid <: Algorithm end
