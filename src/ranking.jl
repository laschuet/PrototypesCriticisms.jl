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
    importances(observed_ranking, ranking)

Like [`importances`](@ref), but provide a single ranking for one data feature only.
"""
importances(observed_ranking::Vector{Int}, ranking::Vector{Int}) =
    importances(observed_ranking, hcat(ranking))