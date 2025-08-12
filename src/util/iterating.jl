jointuples() = ()
jointuples(tuple::Tuple) = tuple
jointuples(first::Tuple, second::Tuple, others::Tuple...) = jointuples((first..., second...), others...)

adjacent(seq) = Iterators.zip(seq, Iterators.drop(seq, 1))
preindexed_combinations(seq, n) = Iterators.filter(Iterators.product(ntuple(i -> seq, n)...)) do indexed_groups
    all(adjacent(indexed_groups)) do ((i1, _), (i2, _)); i1 < i2 end
end

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

"""
Return all elements of `sequence`, split into two collections, based on `condition`.
"""
function partition(condition, sequence)
    selected = condition.(sequence)

    itrue = findall(selected)
    ifalse = findall(.!selected)

    sequence[itrue], sequence[ifalse]
end

replaceat(svec::SVector, i, newval) = Base.setindex(svec, newval, i)
function replaceat(vec::Vector, i, newval)
    newvec = copy(vec)
    newvec[i] = newval
    newvec
end

function mapfirst(f, seq, additional...)
    for ((i, item), extras...) in zip(pairs(seq), additional...)
        @tryreturn mapsome(f(item, extras...)) do result
            replaceat(seq, i, result)
        end
    end
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

exceptfor(seq, i) = [seq[begin:i-1]..., seq[i+1:end]...]
others(seq) = Iterators.map(i -> exceptfor(seq, i), keys(seq))

iunequal(((i1, item1), (i2, item2))) = !isequal(item1, item2)
"""
Split `seq1` and `seq2` into a common initial and final sequence, with the differing middle segments.
Assumes seq1 is longer than seq2.
"""
function findcommon_ordered(seq1, seq2)
    if isempty(seq2); return end

    iseq1 = pairs(IndexLinear(), seq1)
    iseq2 = pairs(IndexLinear(), seq2)

    firstunequal = firstornothing(iunequal, zip(iseq1, iseq2))

    if isnothing(firstunequal)
        return (seq2, empty(seq1), seq1[begin+length(seq2):end], empty(seq2))
    end
        
    lastunequal = firstornothing(iunequal, zip(Iterators.reverse(iseq1), Iterators.reverse(iseq2)))

    if isnothing(lastunequal)
        return (empty(seq1), seq2, seq1[begin:end-length(seq2)], empty(seq2))
    end

    (rest1start, _), (rest2start, _) = firstunequal
    (rest1end, _), (rest2end, _) = lastunequal

    if rest1start > rest1end + 1 || rest2start > rest2end + 1
        return @warn "Impossible state, sequence overlap inconsistent in different directions.\nSequence 1: $seq1\nSequence 2: $seq2"
    end

    seq1[begin:rest1start-1], seq1[rest1end+1:end], seq1[rest1start:rest1end], seq2[rest2start:rest2end]
end

function findcommon(seq1, seq2)
    if length(seq1) >= length(seq2); return findcommon_ordered(seq1, seq2) end

    (commonhead, commontail, rest2, rest1) = findcommon_ordered(seq2, seq1)
    
    commonhead, commontail, rest1, rest2
end