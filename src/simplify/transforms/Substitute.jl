const ExpressionMap = Dict{Expression, Expression}

struct Substitute <: RecursiveTransform
    mapping::ExpressionMap
end

expressionpair(pair::Pair{<:Expression, <:Expression}) = pair
expressionpair(pair::Pair) = Expression(pair.first) => Expression(pair.second)

tryapply(substitute::Substitute, expression::Expression) = get(substitute.mapping, expression, nothing)

Substitute(args::Pair...) = Substitute(ExpressionMap(map(expressionpair, args)...))

substitute(expression::Expression, args...) = simplify(apply(Substitute(args...), expression))
