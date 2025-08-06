adjacent(relation::Transitive) = issymmetric(relation) ? preindexed_combinations(iargs(relation), 2) : adjacent(iargs(relation))

function trysimplify(simplifier::Simplifier, relation::Transitive)
    @tryreturn @invoke trysimplify(simplifier, relation::Compound)

    for ((i1, expr1), (i2, expr2)) in adjacent(relation)
        @tryreturn mapsome(matchtrycombine(simplifier, relation, expr1, expr2)) do combined
            replacesome(relation, i1 => nothing) & combined
        end
    end

    if length(args(relation)) <= 1; return TRUE end

    if issymmetric(relation); @tryreturn trysort(relation) end
end

function trycombine(::Simplifier, relation::Type{<:Transitive}, expr1::Expression, expr2::Expression)
    if isreflexive(relation) && isequal(expr1, expr2)
        TRUE
    end
end

function trycombine(simplifier::Simplifier, relation::Type{<:Transitive}, a::Literal, b::Literal)
    @tryreturn @invoke trycombine(simplifier, relation::Type{<:Compound}, a, b)
    @tryreturn @invoke trycombine(simplifier, relation, a::Expression, b::Expression)
end

function trycombine(simplifier::Simplifier, outer::Type{<:And}, trans1::Transitive{Op}, trans2::Transitive{Op}) where Op
    @tryreturn @invoke trycombine(simplifier, outer, trans1::Expression, trans2::Expression)

    if issymmetric(trans1) && issymmetric(trans2)
        if isempty(intersect(args(trans1), args(trans2))); return end

        similar(trans1, vcat(args(trans1), args(trans2)))
    else

    end
end