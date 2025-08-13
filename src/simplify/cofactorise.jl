function cofactorise(simplifier, expr1::Expression, expr2::Expression)
    commonleft, commonright, rest1, rest2 = @returnnothing trycofactorise(simplifier, expr1, expr2)

    while !isnothing((newfactorisation = trycofactorise(simplifier, rest1, rest2);))
        extraleft, extraright, rest1, rest2 = newfactorisation

        commonleft = commonleft * extraleft
        commonright = extraright * commonright

        if isone(rest1) && isone(rest2); break end
    end

    simplify(simplifier, (commonleft, commonright, rest1, rest2))
end

function trycofactorise(simplifier, expr1::Expression, expr2::Expression)
    if isequal(expr1, expr2)
        return (expr1, one(expr1), one(expr1), one(expr1))
    end

    if any(isinst(Prod), (expr1, expr2))
        factors1 = toargs(Prod, expr1)
        factors2 = toargs(Prod, expr2)

        commonsplit = findcommon(factors1, factors2)

        if all(isempty, first(commonsplit, 2)); return end

        T = infervaltype(Sum, expr1, expr2)

        Prod{T}.(commonsplit, Literal(one(T)))
    end
end