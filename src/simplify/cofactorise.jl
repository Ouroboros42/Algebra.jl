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

trycofactorise(simplifier, expr1::Expression, expr2::Expression) = if isequal(expr1, expr2)
    (expr1, one(expr1), one(expr1), one(expr1))
end

function trycofactorise(simplifier, prod1::Prod, prod2::Prod)
    commonsplit = findcommon(args(prod1), args(prod2))

    if all(isempty, first(commonsplit, 2)); return end

    T = infervaltype(Sum, prod1, prod2)

    map(arguments -> Prod{T}(arguments, Literal(one(T))), commonsplit)
end