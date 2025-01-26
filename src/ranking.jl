"""
    prototypes_criticisms(observed_ranking, rankings, p, c)

Find prototypes and criticisms.

# Arguments
- `observed_ranking::Vector{Int}`: the observed ranking.
- `rankings::Matrix{Int}`: the rankings per data feature.
- `p::Int`: the number of protoypes to find.
- `c::Int`: the number of criticisms to find.
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

    # TODO The ranking contains the data instance identifiers, so it is a
    # mapping of index to data instance, i.e., observed_ranking[3] = data
    # instancce at rank 3. However, we need the inverse mapping, i.e., data
    # instance mapped to rank

    prototypes = Int[]
    criticisms = Int[]

    weighted_importances = importances(observed_ranking, rankings)
    sorted_indices = sortperm(weighted_importances, rev=true)
    prototypes = sorted_indices[1:p]
    criticisms = sorted_indices[(end - c + 1):end]

    return prototypes, criticisms
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
    importances(observed_ranking, rankings)

Compute the importances for every data instance.

# Arguments
- `observed_ranking::Vector{Int}`: the originally observed ranking.
- `rankings::Matrix{Int}`: the rankings per data feature.
"""
function importances(observed_ranking::Vector{Int}, rankings::Matrix{Int})
    deviations = abs.(observed_ranking .- rankings)
    k = length(observed_ranking)
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