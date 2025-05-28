
adjacent(seq) = Iterators.zip(seq, Iterators.drop(seq, 1))

ienumerate(seq) = pairs(IndexLinear(), seq)

"""
If `seq1` and `seq2` are identical apart from 1 element at the same position in each, apply `f` to merge the differing items.
If `f` returns `nothing`, return `nothing`.
"""
function map_single_difference(f, seq1, seq2)
    if length(seq1) != length(seq2); return end
    if isempty(seq1); return end

    merged = nothing
    i_diff = nothing

    for ((i1, item1), item2) in zip(ienumerate(seq1), seq2)
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

    for ((iL, itemL), (iS, itemS)) in zip(ienumerate(longer), ienumerate(shorter))
        if isequal(itemL, itemS); continue end

        if longer[iL+1:end] != shorter[iS:end]; return end
    
        extra_index = iL
        extra_item = itemL

        break
    end

    updated_item = @returnnothing f(extra_item)

    updated = copy(longer)
    updated[extra_index] = updated_item
    updated
end