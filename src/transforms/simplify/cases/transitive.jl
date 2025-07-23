adjacent(relation::Transitive) = issymmetric(relation) ? preindexed_combinations(iargs(relation), 2) : adjacent(iargs(relation))

function tryapply(simplifier::Simplifier, relation::Transitive)
    for ((i1, expr1), (i2, expr2)) in adjacent(relation)
        @tryreturn mapsome(matchtrycombine(simplifier, relation, expr1, expr2)) do combined
            replacesomeargs(relation, i1 => nothing) & combined
        end
    end
end

function tryapply(simplifier::Trivial, relation::Transitive)
    if length(args(relation)) <= 1; return TRUE end

    if issymmetric(relation); @tryreturn trysort(relation) end

    @tryreturn @invoke tryapply(simplifier::Simplifier, relation)
end

function trycombine(::Trivial, relation::Type{<:Transitive}, expr1::Expression, expr2::Expression)
    if isreflexive(relation) && isequal(expr1, expr2)
        TRUE
    end
end

function trycombine(simplifier::Trivial, relation::Type{<:Transitive}, a::Literal, b::Literal)
    @tryreturn @invoke trycombine(simplifier, relation::Type{<:Compound}, a, b)
    @tryreturn @invoke trycombine(simplifier, relation, a::Expression, b::Expression)
end

function trycombine(::Trivial, ::Type{<:And}, trans1::Transitive{Op}, trans2::Transitive{Op}) where Op
    if issymmetric(trans1) && issymmetric(trans2)
        if isempty(intersect(args(trans1), args(trans2))); return end

        similar(trans1, vcat(args(trans1), args(trans2)))
    else

    end
end