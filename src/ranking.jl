"""
    prototypes_criticisms(observed_ranking, rankings, p, c)

Find prototypes and criticisms based on the data feature importances.

# Arguments
- `observed_ranking::Vector{Int}`: the observed ranking.
- `rankings::Matrix{Int}`: the rankings per data feature.
- `p::Int`: the number of protoypes to find.
- `c::Int`: the number of criticisms to find.

# Notes
Each ranking contains the data instance identifiers, i.e., every ranking is a
mapping of indices to data instances, e.g., `observed_ranking[3]` = "data
instance at rank 3"
"""
function prototypes_criticisms(
    observed_ranking::Vector{Int},
    rankings::Matrix{Int},
    p::Int,
    c::Int,
)
    p + c > length(observed_ranking) && throw(
        ArgumentError("Number of prototypes and criticisms cannot exceed ranking length"),
    )

    weighted_importances = importances(observed_ranking, rankings)
    sorted_indices = sortperm(weighted_importances, rev=true)
    prototypes = sorted_indices[1:p]
    criticisms = sorted_indices[(end - c + 1):end]

    return observed_ranking[prototypes], observed_ranking[criticisms]
end

"""
    prototypes_criticisms(observed_ranking, rankings, p, c)

Like [`prototypes_criticisms`](@ref), but provide a vector of rankings instead of a matrix.
"""
prototypes_criticisms(
    observed_ranking::Vector{Int},
    rankings::Vector{Vector{Int}},
    p::Int,
    c::Int,
) = prototypes_criticisms(observed_ranking, stack(rankings), p, c)

"""
    prototypes_criticisms(observed_ranking::Vector{Int}, D::Matrix, k::Int)

Find prototypes and criticisms based on the clustering of the ranking.

# Arguments
- `observed_ranking::Vector{Int}`: the observed ranking.
- `D::AbstractMatrix`: the data instances.
- `k::Int`: the number of clusters to find.
"""
function prototypes_criticisms(observed_ranking::Vector{Int}, D::AbstractMatrix, k::Int)
    length(observed_ranking) > size(D, 2) && throw(
        ArgumentError(
            "Number of data instances in the ranking must be lesser or equal to the number of data instances in general",
        ),
    )

    X = view(D, :, observed_ranking)
    distances = pairwise(Euclidean(), X, dims=2)

    clustering = kmedoids(distances, k)
    medoid_indices = clustering.medoids
    ys = clustering.assignments

    prototype_indices = observed_ranking[medoid_indices]
    criticism_indices = Vector{Int}()
    for i in unique(ys)
        v = view(distances, ys .== i, medoid_indices[i])
        permutation = sortperm(v)[end]
        push!(criticism_indices, observed_ranking[parentindices(v)[1][permutation]])
    end

    return prototype_indices, criticism_indices, clustering
end

"""
    importances(observed_ranking, rankings)

Compute the importances for every data instance.

# Arguments
- `observed_ranking::Vector{Int}`: the originally observed ranking.
- `rankings::Matrix{Int}`: the rankings per data feature.
"""
function importances(observed_ranking::Vector{Int}, rankings::Matrix{Int})
    # We need the inverse mapping of every ranking, so that data
    # instances are mapped to indices / ranks. This just allows an easier
    # comparison.
    inverse_observed_ranking = sortperm(observed_ranking)
    inverse_rankings = similar(rankings)
    for (i, ranking) in enumerate(eachcol(rankings))
        inverse_rankings[:, i] = sortperm(ranking)
    end

    deviations = abs.(inverse_observed_ranking .- inverse_rankings)
    k = length(inverse_observed_ranking)
    instance_importances = fill(k - 1, k) .- deviations
    feature_importances = sum(instance_importances, dims=1)

    # TODO Per feature, there should be two rankings, one that represents the
    # data instances in ascending order, and the other that represents the data
    # instances in descending order
    # TODO The ranking with the highest importances should be selected per
    # feature for further processing

    feature_importances_ratio = feature_importances / sum(feature_importances)
    return vec(instance_importances * feature_importances_ratio')
end

"""
    importances(observed_ranking, rankings)

Like [`importances`](@ref), but provide a vector of rankings instead of a matrix.
"""
importances(observed_ranking::Vector{Int}, rankings::Vector{Vector{Int}}) =
    importances(observed_ranking, stack(rankings))

"""
    importances(observed_ranking, ranking)

Like [`importances`](@ref), but provide a single ranking for one data feature only.
"""
importances(observed_ranking::Vector{Int}, ranking::Vector{Int}) =
    importances(observed_ranking, hcat(ranking))