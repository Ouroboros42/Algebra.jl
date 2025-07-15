abstract type Simplifier <: Transform end

struct SimplifierSequence{S <: NTuple{N, Simplifier} where N} <: Transform
    simplifiers::S
end

chain(simplifiers::Simplifier...) = SimplifierSequence(simplifiers)

aschainargs(simplifier::Simplifier) = (simplifier,)
aschainargs(sequence::SimplifierSequence) = sequence.simplifiers
chain(mixed_simplifiers...) = SimplifierSequence(jointuples(map(aschainargs, mixed_simplifiers)...))

"""
Apply specified simplifiers to the Expression until it can be updated no more.
"""
function tryapply(sequence::SimplifierSequence, expression::Expression)
    for simplifier in sequence.simplifiers
        maybe_simpler = tryapply(simplifier, expression)

        if !isnothing(maybe_simpler)
            @debug "Using $simplifier: $(expression) to $(maybe_simpler)"

            return apply(sequence, maybe_simpler)
        end
    end
end