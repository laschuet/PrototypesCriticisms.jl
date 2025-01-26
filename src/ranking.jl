"""
    feature_importances(observed_ranking, rankings)

Compute the feature importances for every data instance.

# Arguments
- `observed_ranking::Vector{Int}`: the originally observed ranking.
- `rankings::Matrix{Int}`: the rankings per data feature.
"""
function feature_importances(observed_ranking::Vector{Int}, rankings::Matrix{Int})
    deviations = abs.(observed_ranking .- rankings)
    k = length(observed_ranking)
    importances = fill(k - 1, k) .- deviations
    feature_importances = sum(importances, dims=1)

    # TODO Per feature, there should be two rankings, one that represents the
    # data instances in ascending order, and the other that represents the data
    # instances in descending order
    # TODO The ranking with the highest importances should be selected per
    # feature for further processing

    feature_importances_ratio = feature_importances / sum(feature_importances)
    return importances * feature_importances_ratio'
end
