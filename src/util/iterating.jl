jointuples() = ()
jointuples(tuple::Tuple) = tuple
jointuples(first::Tuple, second::Tuple, others::Tuple...) = jointuples((first..., second...), others...)

adjacent(seq) = Iterators.zip(seq, Iterators.drop(seq, 1))

"""
If `seq1` and `seq2` are identical apart from 1 element at the same position in each, apply `f` to merge the differing items.
If `f` returns `nothing`, return `nothing`.
"""
function map_single_difference(f, seq1, seq2)
    if length(seq1) != length(seq2); return end
    if isempty(seq1); return end

    merged = nothing
    i_diff = nothing

    for ((i1, item1), item2) in zip(pairs(seq1), seq2)
        if !isequal(item1, item2)
            if !isnothing(i_diff) return end;

            merged = @returnnothing f(item1, item2)
            i_diff = i1
        end
    end
    
    @returnnothing merged

    updated = copy(seq1)
    updated[i_diff] = merged
    updated
end

maybe_flip_pair(doflip::Bool, item1, item2) = doflip ? (item2, item1) : (item1, item2)

"""
Compare 2 sequences to see if they differ by the inclusion of a single extra element.
If they don't, returns `nothing`. If they do, apply `f` to the extra element.
If f evaluates to nothing, returns `nothing`.
Otherwise, return the longer sequence with the extra item replaced by the output of `f`.

Both sequences must support slice indexing, copying, and mutation.
"""
function map_one_extra(f, seq1, seq2)
    lengthdiff = length(seq1) - length(seq2)

    if abs(lengthdiff) != 1; return end

    is_first_longer = lengthdiff > 0

    shorter, longer = maybe_flip_pair(is_first_longer, seq1, seq2)

    extra_index = lastindex(longer)
    extra_item = last(longer)

    for ((iL, itemL), (iS, itemS)) in zip(pairs(longer), pairs(shorter))
        if isequal(itemL, itemS); continue end

        if !isequal(longer[iL+1:end], shorter[iS:end]); return end
    
        extra_index = iL
        extra_item = itemL

        break
    end

    updated_item = @returnnothing f(extra_item)

    updated = copy(longer)
    updated[extra_index] = updated_item
    updated
end

"""
Return all elements of `sequence`, split into two collections, based on `condition`.
"""
function ipartition(condition, sequence)
    selected = condition.(sequence)

    itrue = findall(selected)
    ifalse = findall(.!selected)

    zip(itrue, sequence[itrue]), zip(ifalse, sequence[ifalse])
end

function replacesome(vec::Vector{T}, replacements::Pair{Int, <:Union{Nothing, T}}...) where T
    replacements = sort!(collect(replacements), by=first)
    
    lengthchange = count(r -> isnothing(r[2]), replacements)

    newvec = Vector{T}(undef, length(vec) - lengthchange)

    oldhead = 0
    newhead = 0
    for (index, newvalue) in replacements
        segment = vec[oldhead+1:index-1]
        seglength = length(segment)

        newvec[(1:seglength) .+ newhead] = segment

        oldhead = index
        newhead += seglength

        if isnothing(newvalue); continue end
        
        newhead += 1
        newvec[newhead] = newvalue
    end

    newvec[newhead+1:end] = vec[oldhead+1:end]

    newvec
end