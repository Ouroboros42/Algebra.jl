struct SimplifierSequence{S <: NTuple{N, Simplifier} where N} <: Simplifier
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
        @tryreturn tryapply(simplifier, expression)
    end
end