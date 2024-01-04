function get_2Dindex(index, nrows)
    zero_based_index = index - 1
    row = Int(mod(zero_based_index, nrows)) + 1
    col = Int(div(zero_based_index, nrows)) + 1
    return (row, col)
end

function getMatches(resultsEM::NamedTuple, patterns::Dict, obs_a::Int;
                    threshold_match=0.85,u_b=1e10)
    match_vector=((resultsEM.zeta_j .>= threshold_match .&& resultsEM.patterns_w.weights .<= u_b) |>
        x->resultsEM.patterns_b[findall(x)] .|>
        k ->  patterns[k]) |>
        recursive_flatten
    result_vector = Vector{Tuple{Int,Int}}(undef, length(match_vector))
    Threads.@threads for i in eachindex(match_vector)
        result_vector[i] = get_2Dindex(match_vector[i], obs_a)
    end

    return result_vector
end


