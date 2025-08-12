function trycombine(simplifier, outer::Type{<:Sum}, expr1::Expression, expr2::Expression)
    @tryreturn @invoke trycombine(simplifier, outer::Type{<:Associative}, expr1, expr2)
    
    @tryreturn mapsome(cofactorise(simplifier, expr1, expr2)) do parts
        (commonleft, commonright, rest1, rest2) = simplify(simplifier, parts)

        mapsome(trysimplify(simplifier, rest1 + rest2)) do combined
            commonleft * combined * commonright
        end
    end

    # expanded = map(tryexpand, (expr1, expr2))

    # if !all(isnothing, expanded)
    #     return (@ordefault(expanded[1], expr1) + @ordefault(expanded[2], expr2))
    # end
end